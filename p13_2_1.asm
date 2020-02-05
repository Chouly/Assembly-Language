assume cs:code,ds:data,ss:stack

data segment
	db 20h dup(0)
data ends

stack segment
	dw 20h dup(0)
stack ends

code segment
	start:
		mov ax,cs
		mov si,offset square
		mov ax,0
		mov es,ax
		mov di,2a0h
		mov cx,offset square_end - offset square
		cld
		rep movsb
		
		mov ax,0
		mov es,ax
		mov word ptr es:[4*7ch],2a0h
		mov word ptr es:[4*74h+2],0
		
		mov ax,4c00h
		int 21h
		
	square:
		mul ax
		iret
	square_end:
		nop
		
code ends
end start

		