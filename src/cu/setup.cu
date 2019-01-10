#include <cuda_runtime.h>
#include "include/setup.cuh"
#include "include/utils.cuh"
#include "include/SWE.cuh"
#include "../include/structs.h"
#include "../include/macros.h"

__global__ void binaryKernel(const configStruct config, 
	unsigned char* binary1, unsigned char* binary2) {

	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if (i < config.Lx*config.Ly) {
		unsigned char b1;
		unsigned char b2;
		int y = (int)i / config.Lx;
		int x = i - y * config.Lx;
		if (y == 0) {
			if (x == 0){
				b1 = 4 + 8 + 64;
				b2 = 1 + 2 + 16;
			}
			else if (x == config.Lx - 1){
				b1 = 1 + 8 + 128;
				b2 = 2 + 4 + 32;
			}
			else{
				b1 = 1 + 4 + 8 + 64 + 128;
				b2 = 2 + 16 + 32; 
			}
		}
		else if (y == config.Ly - 1) {
			if (x == 0) {
				b1 = 2 + 4 + 32;
				b2 = 1 + 8 + 128;
			}
			else if (x == config.Lx - 1){ 
				b1 = 1 + 2 + 16;
				b2 = 4 + 8 + 64;
			}
			else{ 
				b1 = 1 + 2 + 4 + 16 + 32;
				b2 = 8 + 64 + 128;
			}
		}
		else {
			if (x == 0){
				b1 = 2 + 4 + 8 + 32 + 64;
				b2 = 1 + 16 + 128;
			}
			else if (x == config.Lx - 1){
				b1 = 1 + 2 + 8 + 16 + 128;
				b2 = 4 + 32 + 64;
			}
			else{
				b1 = 255;
				b2 = 0;
			}
		}
		binary1[i] = b1;
		binary2[i] = b2;
	}
}

__global__ void fKernel(const configStruct config,
	const prec* __restrict__ h, prec* f) {

	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if (i < config.Lx*config.Ly) {
		prec feq[9];
		prec localMacroscopic[] = {h[i], 0, 0};
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
			f[IDXcm(i, j, config.Lx, config.Ly)] = feq[j];
	}
}