#include <fstream>
#include <sstream>
#include <string>
#include <stdlib.h>
#include <stdio.h>
#include <iomanip>
#include <iostream>
#include <vector>
#include <math.h>
#include "include/files.h"
#include "../include/structs.h"

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
		fscanf(fp, "%lf %lf\n", &wTemp, &bTemp);
		main->w[i] = wTemp;
		main->b[i] = bTemp;
	}
	fclose(fp);
}

void writeConfig(configStruct config) {
	std::ofstream myfile;
	std::string filename = config.outputDir + "config.txt";
	myfile.open(filename.c_str(), std::ios_base::out);
	std::cout << "Writing configuration in " << filename << std::endl;
	myfile.precision(16);
	myfile.setf(std::ios::scientific);
	myfile << "TEST " << config.test << "\n" 
		   << "OUTPUT_DIR " << config.outputDir << "\n"  
		   << "INPUT_FILE " << config.inputFile << "\n" 
		   << "BLOCK_SIZE " << config.blockSize << "\n" 
		   << "GRID_SIZE " << config.gridSize << "\n" 
		   << "LX " << config.Lx << "\n" 
		   << "LY " << config.Ly << "\n" 
		   << "DX " << config.dx << "\n" 
		   << "DT " << config.dt << "\n"
		   << "TIME_STEPS " << config.timeMax << "\n"
		   << "D_OUTPUT " << config.dtOut << "\n"  
		   << "TAU " << config.tau 
		   << std::endl;
	myfile.close();
}	

void writeOutput(configStruct config, int t, prec* w) {
	FILE *fp;
	std::ostringstream numero; 
	numero << std::setw(5) << std::setfill('0') << std::right << (t);
	std::string filename = config.outputDir + "output_" + numero.str() + ".dat";
	if ((fp = fopen(filename.c_str(), "wb")) == NULL) {
		std::cerr << "Can't create output file " << filename << std::endl;
		exit(EXIT_FAILURE);
	}
	fwrite(&w[0], sizeof(prec), config.Lx*config.Ly, fp);
	fclose(fp);
}