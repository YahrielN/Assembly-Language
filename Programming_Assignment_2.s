.data
.type a, %object
.type i, %object
.type n, %object
.size a, 8
.size n, 1

n: .xword 8
a: .xword 79, 55, 94, 48, 19, 13, 45, 21

.text
.global main
.global smallest
.global largest
.global swap
.arch armv8-a+fp+simd
.type smallest, %function
.type largest, %function
.type swap, %function
.type main, %function

swap:
   LSL X9, X3, #3
   ADD X9, X9, X0
   LSL X10, X4, #3
   ADD X10, X10, X0
   LDUR X11, [X9, #0]
   LDUR X12, [X10, #0]
   STUR X11, [X10, #0]
   STUR X12, [X9, #0]

   BR X30

smallest:

   MOV X9, X1 //copy i into X9
   MOV X10, X2  //copy n into X10
   LSL X11, X9, #3
   ADD X11, X11, X0
   LDUR X12, [X11, #0]
   MOV X3, X9 //copy i into x3

loopsmall:

   CMP X9, X10 //check if i < n
   B.GE return
   LDUR X13, [X11, #0]
   CMP X12, X13  //check if a new smallest int was found
   B.LE skipsmall  //mallest int not found
   MOV X12, X13  //new smallest in X12
   MOV X3, X9  //new smallest in X3

skipsmall:
   ADD X9, X9, #1  //i+1
   ADD X11, X11 , #8
   B loopsmall  //go back to loopsmall

return:
  BR X30 //go to main

largest:

  MOV X9, X1
  MOV X10, X2
  LSL X11, X9, #3  //X11 = i+8
  ADD X11, X11, X0
  LDUR X12, [X11, #0]
  MOV X3, X9  //copy i into X3

looplarge:

  CMP X9, X10
  B.GE return1
  LDUR X13, [X11, #0]
  CMP X12, X13  //check if a new large int was found
  B.GE skiplarge  //largest not found
  MOV X12, X13  //new largest in x12
  MOV X3, X9  //new largest in x3

skiplarge:
  ADD X9, X9, #1 //I+1
  ADD X11, X11, #8
  B looplarge

return1:
   BR X30

main:
   ADRP X0, a //load the array address to X0
   ADD X0, X0, :lo12:a
   ADRP X2, n //Load address of n to X1
   ADD X2, X2, :lo12:n
   SUB X1, X1, X1
   LDUR X2, [X2, #0] //load from memory of n[0] into X4


loop:

  CMP X1, X2  //check if i<n
  B.GE exit  //if i>n then end program
  BL smallest

  MOV X4, X1  //copy i into X4
  BL swap

  BL  largest
  SUB X4, X2, #1  //X4 = n-1
  BL swap

  ADD X1, X1, #1  //i = i + 1
  SUB X2, X2, #1  //n=n-1
  B loop


exit:



