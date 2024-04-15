	.data
	.type	a, %object
	.type	i, %object
	.type	n, %object
	.size	a, 6
	.size   n, 1
n:
	.xword 6
a:
	.xword	35, 47, 12, 9 , 18, 26       // 64-bit values


	.text
	.global	main
	.global find_smallest
	.global find_largest
	.global find_sum
	.arch armv8-a+fp+simd
	.type find_smallest, %function
	.type find_largest, %function
	.type find_sum, %function
	.type	main, %function

find_sum:
	// X0 contains address of a; X1 contains n,
	//X14 will contain sum returned
        //(add your code here)
        LDUR X2, [X0,#0]		// Loads element A[0] int X2
		ADD X14, X14, X2		// X2 + X2 = X2; 0 + 42 = 42

		ADD X3, X3, #1			// increments X3 = i = i + 1
		ADD X0, X0, #8			// Next element address shifts by 8; X0 = A[1]
		SUB X5, X4, X3			// X1 - X3 = X5; n - i = difference to check
		CBNZ X5, find_sum		// checks if i < n then sends to loop,other words checks if the difference is not zero

		BR X30					// return function



find_largest:
	// X0 contains address of a; X1 contains n,
	//X13 will contain largest value returned
	// X11 will contain the index of largest value returned
     	LDUR X2, [X0,#0]		// Loads element A[0] int X2
	    CMP X2, X13				// Is X2 bigger than X13
		BGE setGreater			// If X2 is greater than X11 it will branch to setGreater

backL:
		ADD X3, X3, #1			// increments X3 = i = i + 1
		ADD X0, X0, #8			// Next element address shifts by 8; X0 = A[1]
		SUB X5, X4, X3			// X1 - X3 = X5; n - i = difference to check
		CBNZ X5, find_largest	// checks if i < n then sends to loop,other words checks if the difference is not zero


		BR X30					// return function


 setGreater:
 		 MOV X13, X2				// if X2 > X3 stores X2 into X11
 		 MOV X11, X3				// stores index of i into X11
	     B backL


find_smallest:
	// X0 contains address of a; X1 contains n,
	//X2 will contain smallest value returned
	// X3 will contain the index of smallest value returned
        LDUR X2, [X0,#0]		// Loads element A[0] int X2
	    CMP X2, X12				// Is X2 smaller than X12
		BLT setSmallest
backS:
		ADD X3, X3, #1			// increments X3 = i = i + 1
		ADD X0, X0, #8			// Next element address shifts by 8; X0 = A[1]
		SUB X5, X4, X3			// X1 - X3 = X5; n - i = difference to check
		CBNZ X5, find_smallest	// checks if i < n then sends to loop,other words checks if the difference is not zero


		BR X30					// return function
setSmallest:
	MOV X12, X2
	MOV X10, X3
	B backS					// return function

main:
	ADRP X0, a           	// Load the array address to X0
	ADD X0, X0, :lo12:a
	ADRP X1, n           	// address of n
	ADD X1, X1, :lo12:n
	LDUR X4, [X1, #0]		// loads from memory element of "n[0]" into X4; n = 6

// Initialization
	SUB X14, X14, X14        	// int sum = 0;
	SUB X13, X13, X13        	// int largest = 0;
	ADD X12, X12, #100        	// int smallest = 100 at first like a flt_max;
	SUB X11, X11, X11        	// int largest index initialization;
	SUB X10, X10, X10        	// int smallest index initialization;
	SUB X3, X3, X3				// int i = 0;

	LDUR X13, [X0, #0]		// Loads element A[i] into X11 this will be Greatest
	LDUR X12, [X0, #0]		// Loads element A[i] into X12 this will be Smallest




     // Functions
	BL find_smallest			// call find_smallest


	SUB X3, X3, X3				// i counter resets to i = 0;
	SUB X0, X0, X0
	ADRP X0, a           	// Load the array address to X0
	ADD X0, X0, :lo12:a


	BL find_largest 	// call find_largest


	SUB X3, X3, X3				// i counter resets to  i = 0;
	SUB X0, X0, X0
	ADRP X0, a           	// Load the array address to X0
	ADD X0, X0, :lo12:a



	BL find_sum		// call find_sum

exit:

