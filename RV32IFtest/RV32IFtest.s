# RV32IFtest.s
# Venus-compatible floating-point test for RV32IF Archer Project

.data
val1:         .float 3.5
val2:         .float 2.0
val3:         .float 7.0
stored:       .word 0            # For testing FSW/FLW
nan_val:      .word 0x7fc00000    # NaN
pinf_val:     .word 0x7f800000    # +Infinity
ninf_val:     .word 0xff800000    # -Infinity
poszero_val:  .word 0x00000000    # +0.0
negzero_val:  .word 0x80000000    # -0.0

.text
.globl main

main:
    # Load normal float values
    la a0, val1
    flw f1, 0(a0)        # f1 = 3.5

    la a1, val2
    flw f2, 0(a1)        # f2 = 2.0

    la a2, val3
    flw f3, 0(a2)        # f3 = 7.0

    # required floating-point operations
    fadd.s f4, f1, f2    # f4 = 3.5 + 2.0 = 5.5
    fsub.s f5, f1, f2    # f5 = 3.5 - 2.0 = 1.5
    fmul.s f6, f1, f2    # f6 = 3.5 * 2.0 = 7.0
    fmin.s f7, f1, f2    # f7 = min(3.5, 2.0) = 2.0
    fmax.s f8, f1, f2    # f8 = max(3.5, 2.0) = 3.5

    feq.s a2, f1, f3     # a2 = (3.5 == 7.0) = 0
    flt.s a3, f1, f3     # a3 = (3.5 < 7.0) = 1
    fle.s a4, f3, f3     # a4 = (7.0 <= 7.0) = 1

    la a1, stored
    fsw f4, 0(a1)        # Store 5.5
    flw f19, 0(a1)       # Load back into f19

    # SPECIAL VALUES: NaN, ±Inf, ±0.0
    la a0, nan_val
    flw f9, 0(a0)

    la a0, pinf_val
    flw f10, 0(a0)

    la a0, ninf_val
    flw f11, 0(a0)

    la a0, poszero_val
    flw f12, 0(a0)

    la a0, negzero_val
    flw f13, 0(a0)

    feq.s a5, f9, f9      # a5 should be 0
    flt.s a6, f9, f1      # a6 = 0 expected
    fle.s a7, f9, f1      # a7 = 0 expected

    fmin.s f16, f10, f11   # f16 = min(+inf, -inf) = -inf
    fmax.s f17, f10, f11   # f17 = max(+inf, -inf) = +inf

    feq.s a1, f12, f13     # a1 = (+0.0 == -0.0) = 1
    flt.s a2, f13, f12     # a2 = (-0.0 < +0.0) = 0
    fle.s a3, f13, f12     # a3 = (-0.0 <= +0.0) = 1

    # Exit program
    li a7, 10
    ecall
