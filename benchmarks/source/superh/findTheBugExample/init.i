# 1 "init.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "init.S"
# 1 "asm.h" 1
# 2 "init.S" 2

 .global _vec_stub_begin
 .global _vec_stub_end
 .global _sleep
 .global _atexit
 .global _malloc

 .align 2
start:

 AND #0, r0
 LDC r0, sr


 MOV.L app_stack_addr, r15
 MOV.L start_addr, r0
 JSR @r0
 NOP


 mov #1, r4
 trapa #34





 .align 4
_vec_stub_begin:

 MOV.L savestack_addr, r0
 ADD #36, r0
 STS.L pr, @-r0


 BSR saveregs
 NOP


 MOV.L intr_stack_addr, r15
 MOV.L hdlr_addr, r0
 JSR @r0
 NOP


 BSR restoreregs
 NOP


 MOV.L savestack_addr, r0
 ADD #32, r0
 LDS.L @r0+, pr


 RTE
 NOP







saveregs:

 MOV.L savestack_addr, r0


 ADD #32, r0


 MOV.L r15, @-r0
 MOV.L r14, @-r0
 MOV.L r13, @-r0
 MOV.L r12, @-r0
 MOV.L r11, @-r0
 MOV.L r10, @-r0
 MOV.L r9, @-r0
 MOV.L r8, @-r0

 RTS
 NOP





restoreregs:

 MOV.L savestack_addr, r0


 MOV.L @r0+, r8
 MOV.L @r0+, r9
 MOV.L @r0+, r10
 MOV.L @r0+, r11
 MOV.L @r0+, r12
 MOV.L @r0+, r13
 MOV.L @r0+, r14
 MOV.L @r0+, r15

 RTS
 NOP

 .align 4
 hdlr_addr:
 .long _intr_hdlr

 .align 4
 savestack_addr:
 .long _REGSAVESTACK

 .align 4
 intr_stack_addr:
 .long (0x8000000 + (1 << 16))
_vec_stub_end:



_sleep:
 SLEEP
 RTS
 NOP


 .align 2

app_stack_addr:
 .long (0x8000000 + (1 << 15))

 .align 2
start_addr:
 .long _main
