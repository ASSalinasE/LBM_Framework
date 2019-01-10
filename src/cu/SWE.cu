#include <cuda_runtime.h>
#include "include/SWE.cuh"
#include "include/utils.cuh"
#include "../include/structs.h"
#include "../include/macros.h"

__device__ void calculateFeqSWE(prec* feq, prec* localMacroscopic, prec e){	
	prec factor = 1 / (9 * e*e);	
	prec localh = localMacroscopic[0];
	prec localux = localMacroscopic[1];
	prec localuy = localMacroscopic[2];
	prec gh  = 1.5 * 9.8 * localh;
	prec usq = 1.5 * (localux * localux + localuy * localuy);
	prec ux3 = 3.0 * e * localux;
	prec uy3 = 3.0 * e * localuy;
	prec uxuy5 = ux3 + uy3;
	prec uxuy6 = uy3 - ux3;

	feq[0] = localh * (1 - factor * (5.0 * gh + 4.0 * usq));
	feq[1] = localh * factor * (gh + ux3 + 4.5 * ux3*ux3 * factor - usq);
	feq[2] = localh * factor * (gh + uy3 + 4.5 * uy3*uy3 * factor - usq);
	feq[3] = localh * factor * (gh - ux3 + 4.5 * ux3*ux3 * factor - usq);
	feq[4] = localh * factor * (gh - uy3 + 4.5 * uy3*uy3 * factor - usq);
	feq[5] = localh * factor * 0.25 * (gh + uxuy5 + 4.5 * uxuy5*uxuy5 * factor - usq);
	feq[6] = localh * factor * 0.25 * (gh + uxuy6 + 4.5 * uxuy6*uxuy6 * factor - usq);
	feq[7] = localh * factor * 0.25 * (gh - uxuy5 + 4.5 * uxuy5*uxuy5 * factor - usq);
	feq[8] = localh * factor * 0.25 * (gh - uxuy6 + 4.5 * uxuy6*uxuy6 * factor - usq);
}

__device__ void calculateForcingSWE(prec* forcing, prec* h, const prec* __restrict__ b, prec e, 
									int i, int Lx, int* ex, int* ey){
	prec factor = 1 / (6 * e*e);
	prec localh = h[i];
	prec localb = b[i];
	for (int j = 0; j < 4; j++){
		int index = IDX(i, j, Lx, ex, ey);
		forcing[j] = factor * 9.8 * (localh + h[index]) * (b[index] - localb);
	}
	for (int j = 4; j < 8; j++){
		int index = IDX(i, j, Lx, ex, ey);
		forcing[j] = factor * 0.25 * 9.8 * (localh + h[index]) * (b[index] - localb);
	}
}

__global__ void hKernel(const configStruct config, const prec* __restrict__ w,
	const prec* __restrict__ b, prec* h){

	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if (i < config.Lx*config.Ly) {
		h[i] = w[i] - b[i];
	}
}

__global__ void wKernel(const configStruct config, const prec* __restrict__ h,
	const prec* __restrict__ b, prec* w){

	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if (i < config.Lx*config.Ly) {
		w[i] = h[i] + b[i];
	}
}
