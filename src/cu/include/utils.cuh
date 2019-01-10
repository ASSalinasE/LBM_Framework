#ifndef UTILS_CUH
	#define UTILS_CUH

	#include "../../include/structs.h"

	__device__ int IDX(int, int, int, int*, int*); 

	void pointerSwap(cudaStruct*);

	__device__ int IDXcm(int, int, int, int);

	void memoryFree(mainStruct, mainStruct, cudaStruct);

	void memoryInit(configStruct, cudaStruct*, mainStruct*, mainStruct);

#endif
