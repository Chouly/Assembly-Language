assume cs:code,ds:data

data segment
	db 'BaSiC'
	db 'MinTX'
data ends

code segment

start:	mov ax,data
		mov ds,ax
		
		mov bx,0
		mov cx,5
	s1:	mov al,0[bx]
		and al,11011111b
		mov 0[bx],al
		mov al,5[bx]
		or  al,00100000b
		mov 5[bx],al
		inc bx
		loop s1
		
		mov ax,4c00h
		int 21h

code ends

end start
