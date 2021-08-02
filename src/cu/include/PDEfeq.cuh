#ifndef PDEFEQ_CUH
	#define PDEFEQ_CUH

	#include "../../include/macros.h"

	__device__ void calculateFeqHE(prec*, prec*, prec);

	__device__ void calculateFeqWE(prec*, prec*, prec);

	__device__ void calculateFeqNSE(prec*, prec*, prec);

#endif
