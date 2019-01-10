#include <string>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sys/types.h> 
#include <sys/stat.h>
#include "include/utils.h"
#include "../include/macros.h"

int dirExists(const char *path) {
	struct stat info;

	if (stat(path, &info) != 0)
		return 0;
	else if (info.st_mode & S_IFDIR)
		return 1;
	else
		return 0;
}


prec parseArgumentPrec(char* arg, std::string name){
	std::stringstream parser;
	prec value;
	parser << arg;
	parser >> value;
	if(parser.fail()){
		std::cerr << "Invalid value " << parser << " for argument " << name << std::endl;
		exit(EXIT_FAILURE);
	}
	return value;
}

int parseArgumentInt(char* arg, std::string name){
	std::stringstream parser;
	int value;
	parser << arg;
	parser >> value;
	if(parser.fail()){
		std::cerr << "Invalid value " << parser << " for argument " << name << std::endl;
		exit(EXIT_FAILURE);
	}
	return value;
}

void verifyDir(std::string dirType, std::string path){
	if(!dirExists(path.c_str())){
		std::cerr << dirType << " directory " << path << " doesn't exist" << std::endl;
		exit(EXIT_FAILURE);
	}
}

void verifyFile(std::string fileType, std::string filename){	
	FILE *fp;
	if ((fp = fopen(filename.c_str(), "r")) == NULL) {
		std::cerr << fileType << " file " + filename + " doesn't exist" << std::endl;
		exit(EXIT_FAILURE);
	}
	fclose(fp);
}

void showUsage(std::string type, std::string name){
	std::string message;
	message = "Usage:\n\t" + name + " [-h] [-i input_path] [-o output_path] [-ts time_steps] "
			  + "[-dt delta_time] [-do delta_out] [-t tau] [-bs block_size] test\n"  
			  + "Options: \n"  
			  + "\t-h,--help\n"
			  + "\t\tShow this help message\n"
			  + "\t-i, --input-path\n"
			  + "\t\tPath of input file. The default is ./\n" 
			  + "\t-o, --output-path\n"
			  + "\t\tPath of output directory. The default is ./\n"
			  + "\t-ts, --time-steps\n"
			  + "\t\tNumber of time steps to be simulated. The default is 1000\n"
			  + "\t-dt, --delta-time\n"
			  + "\t\tTime in seconds represented by one time step. The default is 0.01\n"
			  + "\t-do, --delta-out\n"
			  + "\t\tNumber of time steps between generation of output files. If 0, output files will only be generated at t=0 and t=time_steps. The default is 0\n"
			  + "\t-t, --tau\n"
			  + "\t\tValue of relaxation time. The default is 0.8\n"
			  + "\t-bs, --block-size\n"
			  + "\t\tNumber of threads per CUDA block. The default is 256";
	if (type == "o")
		std::cout << message << std::endl;
	else if (type == "e")
		std::cerr << message << std::endl;
	exit(EXIT_FAILURE);
}
