#include <iostream>
#include <iomanip>
#include <cuda_runtime.h>
#include "include/setup.cuh"
#include "include/LBMkernels.cuh"
#include "include/SWE.cuh"
#include "include/utils.cuh"
#include "../cpp/include/files.h"
#include "../include/structs.h"
#include "../include/macros.h"

void timeStep(configStruct config, mainStruct device, cudaStruct *deviceOnly, 
				 cudaEvent_t ct1, cudaEvent_t ct2, prec *msecs) {
	float dt;
	cudaEventRecord(ct1);
	LBMpull <<<config.gridSize,config.blockSize>>> (config, device.b, deviceOnly->binary1, 
								deviceOnly->binary2, deviceOnly->f1, deviceOnly->f2, deviceOnly->h);
	pointerSwap(deviceOnly);
	cudaEventRecord(ct2);
	cudaEventSynchronize(ct2);
	cudaEventElapsedTime(&dt, ct1, ct2);
	*msecs += dt;
}

void setup(configStruct config, mainStruct device, cudaStruct deviceOnly) {
	binaryKernel <<<config.gridSize,config.blockSize>>> (config, deviceOnly.binary1, deviceOnly.binary2);
	hKernel <<<config.gridSize,config.blockSize>>> (config, device.w, device.b, deviceOnly.h);
	fKernel <<<config.gridSize,config.blockSize>>> (config, deviceOnly.h, deviceOnly.f1);
}

void copyAndWriteResultData(configStruct config, mainStruct host, mainStruct device, cudaStruct deviceOnly, int t){
	wKernel <<<config.gridSize,config.blockSize>>> (config, deviceOnly.h, device.b, device.w);
	uint pBytes = config.Lx * config.Ly * sizeof(prec);
	cudaMemcpy(host.w, device.w, pBytes, cudaMemcpyDeviceToHost);
	writeOutput(config, t, host.w);
}

void LBM(configStruct config, mainStruct host, mainStruct device, cudaStruct *deviceOnly) {
	setup(config, device, *deviceOnly);

	int t = 0;
	cudaEvent_t ct1, ct2;
	cudaEventCreate(&ct1);
	cudaEventCreate(&ct2);
	prec msecs = 0;
	std::cerr << std::fixed << std::setprecision(1);
	while (t <= config.timeMax) {
		t++;
		timeStep(config, device, deviceOnly, ct1, ct2, &msecs);
		if (config.dtOut != 0 && t%config.dtOut == 0) {
			std::cout << "Time step: " << t << " (" << 100.0*t / config.timeMax << "%)" << std::endl;
			copyAndWriteResultData(config, host, device, *deviceOnly, t);
		}
	}
	if (config.dtOut == 0) 
		copyAndWriteResultData(config, host, device, *deviceOnly, t);
	std::cout << "Average time per time step: " << msecs / config.timeMax << "[ms]" << std::endl;
}

