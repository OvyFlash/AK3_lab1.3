.syntax unified
.cpu cortex-m4
.thumb

// The character # can be used for immediates (numbers) 
// or if it stands at the first position of a line 
// the whole line is counted as a comment.
#define a #4
#define b #6
#define c #4

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector

vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #0: "

.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
    
    // r0-r12 general purpose registers
    mov r0, a
    mov r1, b
    mov r2, c
    // bl - move to calc and save return address to LR
    bl calc
    mov r5, r0
    
    ldr r0, =final
    bl dbgput
    mov r0, r5
    bl dbgput_num
    
end:
    b end

calc:
	push { r3, r4, lr }
	// adds r0 and r1. Result in r5
	add r4, r0, r1 //add a + b
	mov r3, #2 // 2
	// unsigned div
	sdiv r4, r4, r3 //(a+b)/2
	
	mov r0, r2 // mov r0, c (because bne compares r0)
	bl factorial
	add r0, r0, r4
	pop { r3, r4, pc }

factorial:
	push { r4 }
	mov r4, 1
	
.loop:
	mul r4, r4, r0
	// sub and change flags
	// N - result greater or equal to 0
	// Z - result is zero
	// C - carry (did not fit)
	// V - Overflow
	subs r0, r0, #1
	// if r0 is not zero jump to func
	bne .loop
	mov r0, r4
	pop { r4 }
	// go to link register
	bx lr
    
    
    
    

