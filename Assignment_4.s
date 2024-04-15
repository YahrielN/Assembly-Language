.data
.type n, %object
.size n, 1
.type a, %object
.size a, 8
n:
  .xword 8
a:
  .float 17.0, 12.1, 3.2, 7.3, 31.4, 27.5, 5.6, 19.7

  .text
  .global main
  .global std_dev
  .global avg
  .arch armv8-a+fp+simd
  .type main, %function
  .type std_dev, %function
  .type avg, %function


avg:
   SUB X7, X7, X7
   FSUB S4, S4, S3
loop1:
   LDUR S3, [X0, #0]
   FADD S4, S4, S3
   ADD X0, X0, #4
   ADD X7, X7, #1
   CMP X7, X1
   B.LT loop1

   SCVTF S5, X1
   FDIV S1, S4, S5
   SUB X0, X0, #32
   BR X30

std_dev:
    SUB X7, X7, X7
    FSUB S4, S4, S4

loop2:
   LDUR S3, [X0, #0]
   FSUB S6, S3, S1
   FMUL S7, S6, S6
   FADD S4, S4, S7

   ADD X0, X0, #4
   ADD X7, X7, #1
   CMP X7, X1
   B.LT loop2

   SCVTF S5, X1
   FDIV S8, S4, S5
   FSQRT S2, S8
   BR X30

main:
   ADRP X5, n
   ADD X5, X5, :lo12:n
   LDUR X1, [X5, #0]
   ADRP X0, a
   ADD X0, X0, :lo12:a

   BL avg
   BL std_dev
exit:
