assume cs:code

stack segment
	dw 16 dup(0)
stack ends

code segment
	start:	mov ax,stack
			mov ss,ax
			mov sp,20h
			
			mov ax,4240h
			mov dx,000fh
			mov cx,0ah
			call divdw
			
			mov ax,4c00h
			int 21h
			
	divdw:	push bp
			mov bp,sp
			push ax
			mov ax,dx
			mov dx,0
			div cx
			push ax
			mov ax,[bp-2]
			div cx
			mov cx,dx
			pop dx
			mov sp,bp
			pop bp
			ret

code ends

end start
