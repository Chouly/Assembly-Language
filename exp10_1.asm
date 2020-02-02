assume cs:code
data segment
	db "Welcome to masm!asdfdsf",0
data ends

stack segment
	dw 16 dup(0)
stack ends

code segment
start:	
		mov ax,stack
		mov ss,ax
		mov sp,32
		
		mov dh,13		;row
		mov dl,32		;column
		mov cl,1		;color
		mov ax,data
		mov ds,ax
		mov si,0
		call show_str
		
		mov ax,4c00h
		int 21h

show_str:	push ax
			push es
			push dx
			push si
			
			mov ax,0b800h
			mov es,ax
			mov al,160
			mul dh
			mov dh,0
			add dx,dx
			add ax,dx
			mov bx,ax
			mov dl,cl
		
	show_str_s:	
			mov ch,0
			mov cl,[si]
			jcxz show_str_r
			mov al,[si]
			push si
			add si,si
			mov byte ptr es:[bx+si],al
			mov byte ptr es:[bx+1+si],dl
			pop si
			inc si
			jmp short show_str_s
		
	show_str_r:	
			pop si
			pop dx
			pop es
			pop ax
			ret

code ends

end start