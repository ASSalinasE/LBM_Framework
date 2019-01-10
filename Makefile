#
# Folder structure
#

BIN     := ./bin/
SRC     := ./src/
DEST    := ./obj/

EXE = LBM

#
# Executables
#

CC     = gcc
CP     = g++
NVCC   = nvcc
RM     = rm
MKDIR  = mkdir

#
# Macros
#

PREC ?= 64

#
# C/C++ flags
#

CFLAGS    = -Wall -DPREC=$(PREC)
CPPFLAGS  = -Wall -DPREC=$(PREC)

#
# CUDA flags
#

NVARCH	= sm_35 \
 -gencode=arch=compute_35,code=sm_35 \
 -gencode=arch=compute_37,code=sm_37 \
 -gencode=arch=compute_60,code=sm_60 \
 -gencode=arch=compute_70,code=sm_70 \
 -gencode=arch=compute_70,code=compute_70
NVFLAGS = -g -arch=$(NVARCH) -DPREC=$(PREC)

#
# Files to compile: 
#

MAIN   = main.cu
CODC   = 
CODCPP = input.cpp config.cpp output.cpp utils.cpp
CODCU  = LBM.cu setup.cu LBMkernels.cu BC.cu SWE.cu utils.cu

#
# Formating the folder structure for compiling/linking/cleaning.
#

FC     = 
FCPP   = cpp/
FCU    = cu/

#
# Preparing variables for automated prerequisites
#

OBJC   = $(patsubst %.c,$(DEST)$(FC)%.o,$(CODC))
OBJCPP = $(patsubst %.cpp,$(DEST)$(FCPP)%.o,$(CODCPP))
OBJCU  = $(patsubst %.cu,$(DEST)$(FCU)%.o,$(CODCU))

SRCMAIN = $(patsubst %,$(SRC)%,$(MAIN))
OBJMAIN = $(patsubst $(SRC)%.cu,$(DEST)%.o,$(SRCMAIN))

#
# The MAGIC
#

all:  $(BIN)$(EXE)
 
$(BIN)$(EXE): $(OBJC) $(OBJCPP) $(OBJCU) $(OBJMAIN) | $(BIN)
	$(NVCC) $(NVFLAGS) $^ -o $@

$(OBJMAIN): $(SRCMAIN) 
	$(NVCC) $(NVFLAGS) -dc $? -o $@

$(OBJCPP): $(DEST)%.o : $(SRC)%.cpp | $(DEST)
	$(CP) $(CPPFLAGS) -c $? -o $@

$(OBJCU): $(DEST)%.o : $(SRC)%.cu 
	$(NVCC) $(NVFLAGS) -dc $? -o $@

$(OBJC): $(DEST)%.o : $(SRC)%.c 
	$(CC) $(CFLAGS) -c $? -o $@

$(DEST): 
	$(MKDIR) -p $(DEST)
	$(MKDIR) -p $(DEST)$(FCPP)
	$(MKDIR) -p $(DEST)$(FCU)

$(BIN):
	$(MKDIR) -p $(BIN)

#
# Makefile for cleaning
# 

clean:
	$(RM) -rf $(DEST)*.o
	$(RM) -rf $(DEST)$(FC)*.o
	$(RM) -rf $(DEST)$(FCPP)*.o
	$(RM) -rf $(DEST)$(FCU)*.o

distclean: clean
	$(RM) -rf $(BIN)*
