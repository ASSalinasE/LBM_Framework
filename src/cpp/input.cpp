#include <string>
#include <stdio.h>
#include <iostream>
#include <math.h>
#include "include/input.h"
#include "../include/structs.h"
#include "../include/macros.h"

void readInput(configStruct *config, mainStruct *main) {
	FILE *fp;
	fp = fopen(config->inputFile.c_str(), "r");
	std::cout << "Reading input from " << config->inputFile << std::endl;

	double dxTemp;
	fscanf(fp, "%d %d %lf\n", &(config->Lx), &(config->Ly), &dxTemp);
	config->dx = (prec)dxTemp;
	config->e = config->dx/config->dt;
	config->gridSize = int(ceil((prec)config->Lx * config->Ly / config->blockSize));

	main->b = new prec[config->Lx*config->Ly];
	main->w = new prec[config->Lx*config->Ly];
	double wTemp, bTemp;
	for (int i = 0; i < config->Lx*config->Ly; i++){
		fscanf(fp, "%lf %lf\n", &bTemp, &wTemp);
		main->w[i] = wTemp;
		main->b[i] = bTemp;
	}
	fclose(fp);
}
