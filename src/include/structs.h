#ifndef STRUCTS_H
	#define STRUCTS_H

	#include <string>
	#include "macros.h"

	typedef struct configStruct {
		std::string test;
		std::string inputPath;
		std::string outputPath;
		std::string inputFile;
		std::string outputDir;
		int timeMax;
		int dtOut;
		int blockSize;
		int gridSize;
		int Lx;
		int Ly;
		prec dx;
		prec dt;
		prec e;
		prec tau;
	} configStruct;

	typedef struct mainStruct {
		int* componentClass;
		prec* b;
		prec* w;
	} mainHStruct;

	typedef struct cudaStruct {
		prec* h;
		prec* f1;
		prec* f2;
		unsigned char* binary1;
		unsigned char* binary2;
	} cudaStruct;

#endif
