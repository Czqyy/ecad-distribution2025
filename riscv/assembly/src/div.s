.macro DEBUG_PRINT reg
csrw 0x800, \reg
.endm
	
.text
.global div              # Export the symbol 'div' so we can call it from other files
.type div, @function
div:
    addi sp, sp, -32     # Allocate stack space

    # store any callee-saved register you might overwrite
    sw   ra, 28(sp)      # Function calls would overwrite
    sw   s0, 24(sp)      # If t0-t6 is not enough, can use s0-s11 if I save and restore them
    # ...

    # do your work
    # example of printing inputs a0 and a1
    DEBUG_PRINT a0
    DEBUG_PRINT a1
    
    # Division by 0
    beqz a1, division_zero   
    li   t0, 0	# Q := 0
    li   t1, 0	# R := 0
    li   t2, 31 # i := n-1

loop:
    blt  t2, x0, end_loop
    slli t1, t1, 1
    
    # R(0) := N(i)
    srl  t3, a0, t2	# Extract ith bit of N
    andi t4, t3, 1
    andi t1, t1, -2	# Clear LSB of R and set to ith bit of N
    or   t1, t1, t4

    # Check if R >= D
    blt  t1, a1, else
    
    # R := R - D
    sub  t1, t1, a1
    
    # Q(i) := 1
    li   t5, 1
    sll  t5, t5, t2
    or   t0, t0, t5

else:
    nop    

    addi t2, t2, -1
    j    loop

end_loop:
    mv   a0, t0
    mv   a1, t1    
    j 	 end

division_zero:
    mv   a0, x0    
    j    end

end:
    # load every register you stored above
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    # ...
    addi sp, sp, 32      # Free up stack space
    ret

