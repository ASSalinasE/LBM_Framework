#ifndef LBMKERNELS_CUH
	#define LBMKERNELS_CUH

	#include "../../include/structs.h"
	#include "../../include/macros.h"

	__global__ void LBMpull(const configStruct,	const prec* __restrict__, const unsigned char* 
						    __restrict__, const unsigned char* __restrict__, const prec* __restrict__, 
						    prec*, prec*);

#endif
