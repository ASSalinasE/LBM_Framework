#include <cuda_runtime.h>
#include "include/BC.cuh"
#include "include/utils.cuh"
#include "../include/macros.h"

__device__ void OBC(prec* localf, const prec* __restrict__ f, int i, int j, int Lx, int Ly){
	localf[j] = f[IDXcm(i, j, Lx, Ly)];
}

__device__ void BBBC(prec* localf, int j){
	int op[] = {3,4,1,2,7,8,5,6};
	localf[j] = localf[op[j-1]];
}

__device__ void SBC(prec* localf, int j, unsigned char b1, unsigned char b2){
	int op[] = {3,4,1,2,7,8,5,6};
	if(j < 5)
		localf[j] = localf[op[j-1]];
	else{
		int right[] = {5,6,7,4};
		int left[]  = {7,4,5,6};
		int index   = j-5;
		if (((b1>>(j-1) == b1>>(right[index])) && (b2>>(j-1) == b2>>(right[index]))) && 
			((b1>>(j-1) != b1>>(left[index] )) || (b2>>(j-1) != b2>>(left[index] ))))
			localf[j] = localf[left[index]+1];
		else if (((b1>>(j-1) == b1>>(left[index] )) && (b2>>(j-1) == b2>>(left[index] ))) && 
				 ((b1>>(j-1) != b1>>(right[index])) || (b2>>(j-1) != b2>>(right[index]))))
			localf[j] = localf[right[index]+1];
		else
			localf[j] = localf[op[j-1]];
	}
}

__device__ void PBC(prec* localf, const prec* __restrict__ f, int i, int j, 
					int Lx, int Ly, int* ex, int* ey){
	int y = i/Lx;
	int x = i - y * Lx;
	int xop = (Lx + x - ex[j])%Lx;
	int yop = (Ly + y - ey[j])%Ly;
	int iop = xop + yop * Lx;
	localf[j] = f[IDXcm(iop, j, Lx, Ly)];
}