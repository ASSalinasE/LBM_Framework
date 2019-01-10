#include <cuda_runtime.h>
#include "include/utils.cuh"
#include "../include/structs.h"
#include "../include/macros.h"

__device__ int IDX(int i, int j, int Lx, int* ex, int* ey){
	return i - ex[j-1] - ey[j-1] * Lx;
}

__device__ int IDXcm(int i, int j, int Lx, int Ly){
	return i + j * Lx * Ly;
}

void pointerSwap(cudaStruct *deviceOnly){
	prec *tempPtr = deviceOnly->f1;
	deviceOnly->f1 = deviceOnly->f2;
	deviceOnly->f2 = tempPtr;
}

void memoryFree(mainStruct host, mainStruct device, cudaStruct deviceOnly){
	delete[] host.b;
	delete[] host.w;

	cudaFree(device.b);
	cudaFree(device.w);
	
	cudaFree(deviceOnly.h);
	cudaFree(deviceOnly.f1);
	cudaFree(deviceOnly.f2);
	cudaFree(deviceOnly.binary1);
	cudaFree(deviceOnly.binary2);
}

void memoryInit(configStruct config, cudaStruct *deviceOnly,
		 		mainStruct *device, mainStruct host){
	uint pBytes = config.Lx * config.Ly * sizeof(prec);
	uint iBytes = config.Lx * config.Ly * sizeof(int);
	uint uBytes = config.Lx * config.Ly * sizeof(unsigned char);

	cudaMalloc((void**)&(device->w), pBytes); 
	cudaMalloc((void**)&(device->b), pBytes);

	cudaMemcpy(device->w, host.w, pBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(device->b, host.b, pBytes, cudaMemcpyHostToDevice);

	cudaMalloc((void**)&(deviceOnly->h), pBytes);
	cudaMalloc((void**)&(deviceOnly->f1), 9 * pBytes);
	cudaMalloc((void**)&(deviceOnly->f2), 9 * pBytes);
	cudaMalloc((void**)&(deviceOnly->binary1), uBytes);
	cudaMalloc((void**)&(deviceOnly->binary2), uBytes);
}

