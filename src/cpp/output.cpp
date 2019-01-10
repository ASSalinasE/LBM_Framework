#include <sstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iomanip>
#include <iostream>
#include <sys/stat.h>
#include "include/output.h"
#include "include/utils.h"
#include "../include/structs.h"
#include "../include/macros.h"

void createOutputDir(configStruct *config){
	std::string outputDir = config->outputPath + config->test;
	std::string outputdirTemp = outputDir;
	int c = 1;
	std::string cStr = "";
	while (dirExists(outputdirTemp.c_str())) {
		cStr = static_cast<std::ostringstream*>(&(std::ostringstream() << c))->str();
		outputdirTemp = outputDir + "_" + cStr;
		c++;
	}
	config->outputDir = outputdirTemp + "/";
	mkdir(config->outputDir.c_str(), 0733);
	std::cout << "Created output directory " << config->outputDir << std::endl;
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