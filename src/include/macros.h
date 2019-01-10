#ifndef MACROS_H
	#define MACROS_H

	#ifndef PREC  
		#define PREC 64
	#endif

	#ifndef PDE  
		#define PDE 1
	#endif

	#ifndef BC1 
		#define BC1 1
	#endif

	#ifndef BC2  
		#define BC2 0
	#endif

	#if PREC==64
		typedef double prec;
	#else
		typedef float prec;
	#endif

#endif
