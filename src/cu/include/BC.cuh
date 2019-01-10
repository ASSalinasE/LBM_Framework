#ifndef BC_CUH
	#define BC_CUH

	#include "../../include/macros.h"

	__device__ void OBC(prec*, const prec* __restrict__, int, int, int, int);

	__device__ void BBBC(prec*, int);

	__device__ void SBC(prec*, int, unsigned char, unsigned char);

	__device__ void PBC(prec*, const prec* __restrict__, int, int, int, int, int*, int*);

#endif
