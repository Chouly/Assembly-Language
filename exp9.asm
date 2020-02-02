assume cs:code,ds:data,ss:stack

data segment
	db 'welcome to masm!'
	db 00000010b,00100100b,01110001b
data ends

stack segment
	dw 8 dup(0)
stack ends

code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,16
		mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax
		
		mov bx,1760
		mov dx,0
		mov cx,3

s0:		mov si,0
		mov di,0
		push cx
		mov cx,16

s1:		mov al,[si]
		mov es:[bx+64+di],al
		push si
		mov si,dx
		mov al,[si+16]
		mov es:[bx+65+di],al
		pop si
		inc si
		add di,2
		loop s1
		
		inc dx
		add bx,160
		pop cx
		loop s0
		
		mov ax,4c00h
		int 21h
		
code ends

end start
		