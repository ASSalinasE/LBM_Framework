#include <iomanip>
#include <stdio.h>
#include <iostream>
#include <time.h>
#include <cuda_runtime.h>
#include "include/structs.h"
#include "include/macros.h"
#include "cpp/include/input.h"
#include "cpp/include/config.h"
#include "cpp/include/output.h"
#include "cu/include/LBM.cuh"
#include "cu/include/utils.cuh"

int main(int argc, char* argv[]) {
	clock_t t1, t2; 
	t1 = clock();
	mainStruct host;
	mainStruct device;
	cudaStruct deviceOnly;
	configStruct config;

	setConfig(&config, argv, argc);
	createOutputDir(&config);
	readInput(&config, &host);
	writeConfig(config);
	writeOutput(config, 0, host.w);
	memoryInit(config, &deviceOnly, &device, host);

	std::cout << "Starting LBM loop" << std::endl;
	LBM(config, host, device, &deviceOnly);

	memoryFree(host, device, deviceOnly);

	t2 = clock();
	prec elapsedTime = 1000.0 * (prec)(t2 - t1) / CLOCKS_PER_SEC;
	std::cout << "Program successfully terminated\n"
			  << "Total execution time: " << elapsedTime << "[ms]" << std::endl;
	exit(EXIT_SUCCESS);
} 

