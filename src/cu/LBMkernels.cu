#include <cuda_runtime.h>
#include <stdio.h>
#include "include/LBMkernels.cuh"
#include "include/utils.cuh"
#include "include/SWE.cuh"
#include "include/PDEfeq.cuh"
#include "include/BC.cuh"
#include "../include/structs.h"
#include "../include/macros.h"
 
__device__ void calculateMacroscopic(prec* localMacroscopic, prec* localf, prec e){
	localMacroscopic[0] = localf[0] + (localf[1] + localf[2] + localf[3] + localf[4]) + (localf[5] + localf[6] + localf[7] + localf[8]);
	localMacroscopic[1] = e * ((localf[1] - localf[3]) + (localf[5] - localf[6] - localf[7] + localf[8])) / localMacroscopic[0];
	localMacroscopic[2] = e * ((localf[2] - localf[4]) + (localf[5] + localf[6] - localf[7] - localf[8])) / localMacroscopic[0];
}

__global__ void LBMpull(const configStruct config,
	const prec* __restrict__ b, const unsigned char* __restrict__ binary1, 
	const unsigned char* __restrict__ binary2, const prec* __restrict__ f1, 
	prec* f2, prec* h) {
	int i = threadIdx.x + blockIdx.x*blockDim.x;	
	if (i < config.Lx*config.Ly) {
		unsigned char b1 = binary1[i];
		unsigned char b2 = binary2[i];
		if(b1 != 0 || b2 != 0){
			int ex[8] = {1,0,-1,0,1,-1,-1,1};		
			int ey[8] = {0,1,0,-1,1,1,-1,-1};
			prec forcing[8];
			#if PDE == 1
				calculateForcingSWE(forcing, h, b, config.e, i, config.Lx, ex, ey);
			#elif PDE == 5
				calculateForcingUser(forcing, h, b, config.e, i, config.Lx, ex, ey);
			#else 
				for (int j = 0; j < 8; j++)
					forcing[j] = 0;
			#endif

			prec localf[9];
			localf[0] = f1[i]; 
			for (int j = 1; j < 9; j++){
				if(((b1>>(j-1)) & 1) & (~(b2>>(j-1)) & 1)) 
					localf[j] = f1[IDXcm(IDX(i, j, config.Lx, ex, ey), j, config.Lx, config.Ly)] + forcing[j-1];
				else if((~(b1>>(j-1)) & 1) & (~(b2>>(j-1)) & 1)) 
					localf[j] = f1[IDXcm(i, j, config.Lx, config.Ly)];
			}

			for (int j = 1; j < 9; j++)
				if((~(b1>>(j-1)) & 1) & ((b2>>(j-1)) & 1)) 
					#if BC1 == 1
						OBC(localf, f1, i, j, config.Lx, config.Ly);
					#elif BC1 == 2
						PBC(localf, f1, i, j, config.Lx, config.Ly, ex, ey);
					#elif BC1 == 3
						BBBC(localf, j);
					#elif BC1 == 4
						SBC(localf, j, b1, b2);
					#elif BC1 == 5
						UBC1(localf, f1, i, j, config.Lx, config.Ly, ex, ey, b1, b2);
					#elif BC1 == 6
						UBC2(localf, f1, i, j, config.Lx, config.Ly, ex, ey, b1, b2);
					#endif

			#if BC2 != 0
			for (int j = 1; j < 9; j++)
				if(((b1>>(j-1)) & 1) & ((b2>>(j-1)) & 1)) 
					#if BC2 == 1
						localf[j] = OBC(localf, f1, i, j, config.Lx, config.Ly);
					#elif BC2 == 2
						localf[j] = PBC(localf, f1, i, j, config.Lx, config.Ly, ex, ey);
					#elif BC2 == 3
						localf[j] = BBBC(localf, j);
					#elif BC2 == 4
						localf[j] = SBC(localf, j, b1, b2);
					#elif BC2 == 5
						localf[j] = BC1User(localf, f1, i, j, config.Lx, config.Ly, ex, ey, b1, b2);
					#elif BC2 == 6
						localf[j] = BC2User(localf, f1, i, j, config.Lx, config.Ly, ex, ey, b1, b2);
					#endif
			#endif

			prec localMacroscopic[3];
			calculateMacroscopic(localMacroscopic, localf, config.e);
			h[i] = localMacroscopic[0];

			prec feq[9];
			#if PDE == 1
				calculateFeqSWE(feq, localMacroscopic, config.e);
			#elif PDE == 2
				calculateFeqHE(feq, localMacroscopic, config.e);
			#elif PDE == 3
				calculateFeqWE(feq, localMacroscopic, config.e);
			#elif PDE == 4
				calculateFeqNSE(feq, localMacroscopic, config.e);
			#elif PDE == 5
				calculateFeqUser(feq, localMacroscopic, config.e);
			#endif
			
			for (int j = 0; j < 9; j++)
				f2[IDXcm(i, j, config.Lx, config.Ly)] = localf[j] - (localf[j] - feq[j]) / config.tau;
		}
	} 
} 
