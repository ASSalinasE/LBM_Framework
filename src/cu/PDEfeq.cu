#include <cuda_runtime.h>
#include "include/PDEfeq.cuh"
#include "../include/macros.h"

__device__ void calculateFeqHE(prec* feq, prec* localMacroscopic, prec e){	
	prec factor = 1.0 / 9;	
	prec localT = localMacroscopic[0];

	feq[0] = localT * factor * 4;
	feq[1] = localT * factor;
	feq[2] = localT * factor;
	feq[3] = localT * factor;
	feq[4] = localT * factor;
	feq[5] = localT * factor * 0.25;
	feq[6] = localT * factor * 0.25;
	feq[7] = localT * factor * 0.25;
	feq[8] = localT * factor * 0.25;
}

__device__ void calculateFeqWE(prec* feq, prec* localMacroscopic, prec e){
  
}

__device__ void calculateFeqNSE(prec* feq, prec* localMacroscopic, prec e){
  prec factor = 1.0 / 9;	
	prec localrho = localMacroscopic[0];
	prec localux = localMacroscopic[1];
	prec localuy = localMacroscopic[2];
  
	prec usq = 1.5 * (localux * localux + localuy * localuy);
	prec ux3 = 3.0 * localux;
	prec uy3 = 3.0 * localuy;
	prec uxuy5 = ux3 + uy3;
	prec uxuy6 = uy3 - ux3;

	feq[0] = localrho * factor * 4 *    (1                                      - usq);
	feq[1] = localrho * factor *        (1 +   ux3 +     4.5 * ux3*ux3 * factor - usq);
	feq[2] = localrho * factor *        (1 +   uy3 +     4.5 * uy3*uy3 * factor - usq);
	feq[3] = localrho * factor *        (1 -   ux3 +     4.5 * ux3*ux3 * factor - usq);
	feq[4] = localrho * factor *        (1 -   uy3 +     4.5 * uy3*uy3 * factor - usq);
	feq[5] = localrho * factor * 0.25 * (1 + uxuy5 + 4.5 * uxuy5*uxuy5 * factor - usq);
	feq[6] = localrho * factor * 0.25 * (1 + uxuy6 + 4.5 * uxuy6*uxuy6 * factor - usq);
	feq[7] = localrho * factor * 0.25 * (1 - uxuy5 + 4.5 * uxuy5*uxuy5 * factor - usq);
	feq[8] = localrho * factor * 0.25 * (1 - uxuy6 + 4.5 * uxuy6*uxuy6 * factor - usq);
}
