.data
.type n, %object
.size n, 1
n: .xword 7
.text
.global main
.arch armv8-a+fp+simd
.type main, %function
.type fib, %function

fib:

   CBNZ X1, one
   ADD X2, X1, #1
   BR X30



one:
   SUB X7, X1, #1
   CBNZ X7, loop
   ADD X2, X7, #2
   BR X30

loop:

   SUB SP, SP, #32
   STUR X30, [SP, #24]
   STUR X1, [SP, #16]
   ADD SP, SP, #16
   SUB X1, X1, #1
   BL fib
   SUB SP, SP, #16
   STUR X2, [SP, #8]
   LDUR X1, [SP, #16]
   SUB X1, X1, #2
   BL fib
   LDUR X30, [SP, #24]
   LDUR X3, [SP, #8]
   ADD X2, X2, X3
   ADD SP, SP, #32
   BR X30

main:
   ADRP X5, n
   ADD X5, X5, :lo12:n
   LDUR X1, [X5, #0]
   BL fib
Exit:
