#ifndef UTILS_HH
	#define UTILS_HH

	#include <string>
	#include "../../include/macros.h"

	int dirExists(const char*);

	prec parseArgumentPrec(char*, std::string);

	int parseArgumentInt(char*, std::string);

	void verifyDir(std::string, std::string);

	void verifyFile(std::string, std::string);

	void showUsage(std::string, std::string);

#endif