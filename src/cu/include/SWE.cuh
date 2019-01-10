#ifndef SWE_CUH
	#define SWE_CUH

	#include "../../include/structs.h"
	#include "../../include/macros.h"

	__device__ void calculateFeqSWE(prec*, prec*, prec);

	__device__ void calculateForcingSWE(prec*, prec*, const prec* __restrict__, prec, 
										int, int, int*, int*); 

	__global__ void hKernel(const configStruct, const prec* __restrict__, 
						 	const prec* __restrict__, prec*);

	__global__ void wKernel(const configStruct, const prec* __restrict__,
							const prec* __restrict__, prec*);

#endif
