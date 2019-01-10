#ifndef SETUP_CUH
	#define SETUP_CUH

	#include "../../include/structs.h"

	__global__ void binaryKernel(const configStruct, unsigned char*, unsigned char*); 

	__global__ void fKernel(const configStruct, const prec* __restrict__, prec*);

#endif
