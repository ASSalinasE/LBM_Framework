#include <fstream>
#include <string>
#include <stdio.h>
#include <iostream>
#include <iomanip>
#include "include/config.h"
#include "include/utils.h"
#include "../include/structs.h"
#include "../include/macros.h"

void setConfig(configStruct *config, char* argv[], int argc){
	if (argv == NULL || argc < 2){
		std::cerr << "At least one argument is expected" << std::endl;
		showUsage("e", argv[0]);
	}
	std::string arg;
	config->test = argv[argc-1];
	config->inputPath = "./";
	config->outputPath = "./";
	config->timeMax = 1000;
	config->dtOut = 0;
	config->blockSize = 256;
	config->dt = 2.0;
	config->tau = 0.8;
	if (config->test == "-h" || config->test == "--help")
		showUsage("o", argv[0]);		
	for (int i = 1; i < argc-2; i++){
		arg = argv[i];
		if (arg == "-h" || arg == "--help")
			showUsage("o", argv[0]);
		else if (arg == "-i" || arg == "--input-path")
			config->inputPath = argv[i+1];
		else if (arg == "-o" || arg == "--output-path")
			config->outputPath = argv[i+1];
		else if (arg == "-ts" || arg == "--time-steps")
			config->timeMax = parseArgumentInt(argv[i+1], arg);
		else if (arg == "-do" || arg == "--delta-out")
			config->dtOut = parseArgumentInt(argv[i+1], arg);
		else if (arg == "-bs" || arg == "--block-size")
			config->blockSize = parseArgumentInt(argv[i+1], arg);
		else if (arg == "-dt" || arg == "--delta-time")
			config->dt = parseArgumentPrec(argv[i+1], arg);
		else if (arg == "-t" || arg == "--tau")
			config->tau = parseArgumentPrec(argv[i+1], arg);
	}
	config->inputFile = config->inputPath + config->test + ".txt";
	verifyDir("Input", config->inputPath);
	verifyDir("Output", config->outputPath);
	verifyFile("Input", config->inputFile);
}

void writeConfig(configStruct config){
	std::ofstream myfile;
	std::string filename = config.outputDir + "config.txt";
	myfile.open(filename.c_str(), std::ios_base::out);
	std::cout << "Writing configuration in " << filename << std::endl;
	myfile.precision(16);
	myfile.setf(std::ios::scientific);
	myfile << "TEST       " << config.test << "\n" 
		   << "OUTPUT_DIR " << config.outputDir << "\n"  
		   << "INPUT_FILE " << config.inputFile << "\n" 
		   << "BLOCK_SIZE " << config.blockSize << "\n" 
		   << "GRID_SIZE  " << config.gridSize << "\n" 
		   << "LX         " << config.Lx << "\n" 
		   << "LY         " << config.Ly << "\n" 
		   << "DX         " << config.dx << "\n" 
		   << "DT         " << config.dt << "\n"
		   << "TIME_STEPS " << config.timeMax << "\n"
		   << "D_OUTPUT   " << config.dtOut << "\n"  
		   << "TAU        " << config.tau 
		   << std::endl;
	myfile.close();
}	