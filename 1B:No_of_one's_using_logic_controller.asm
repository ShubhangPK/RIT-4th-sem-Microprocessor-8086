assume cs:code,ds:data

data segment
    pa equ 20a0h
    pb equ 20a1h
    pc equ 20a2h
    cr equ 20a3h
    
    msg db "No of ones : "
    ones db ?,"$"
data ends

code segment
    start:
    mov ax,data
    mov ds,ax
    
    mov dx,cr     	;load control register address on to dx register 	
    mov al,82h    	;82=1000 0010 Configeration details for simple input/output with port B as input and rest(A&C) as output
    out dx,al     	;output the control information to control register so it can do the requierd preparations to accept our input and output
    
    mov dx pb	    	;Load port B's address on to dx register
    in al,dx	    	;Take input from port B
    
    mov cx,0008	  	;As we will be dealing with a byte,Load CX with 8
    mov ah,00	    	;Initailize ah to 0,indicating we have seen 0 number of ones.
    
    next_bit:
		ror al,1		  ;Rotating right will bring the right most bit to Carry flag
		jnc skip_inc		  ;If Carry bit is not set,it implies that specific bit is 0, not 1.So we dont increment and directly jump to skip_inc
		inc ah			  ;If the Carry bit is set,we will not jump to skip_inc and will end up at this line,where we increment ah
		skip_inc:
			loop next_bit		;Loop will decrement CX,check if its 0,if not it will jump to where ever its mentioned to,here it will jump to next_bit
    
    mov dx,pa	    ;We load output port(A)'s address on to dx register
    mov al,ah	    ;We copy AH(which contains number of ones) to al
    out dx,al	    ;We output al to port A.
	
	
    mov bl,ah		  ;We make a copy of ah to b1.This is done to print the number of one's on to screen later.
    add ah,30h 		  ;to get ascii representation of the Number to be displayed
    mov ones,ah		  ;We copy ah to ones,which is in memory.	
    
    lea dx,msg		  ;We load DX with the starting address of MSG
    mov ah,9		  ;This number 9,signifies we are selecting a function which prints everything untill it sees $ sign which is pointed by DX register
    int 21h		  ;We call an interrupt , which signifies we are calling the function we previously selected.
    
    mov ah,4ch		;4ch signifies we are selecting a function that we terminate the program when called
    int 21h		;We call an interrupt , which signifies we are calling the function we previously selected.
    code ends
end start
    
    
    
    
