assume cs:code,ds:data

data segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends


stack segment
	dw 16 dup(0)
stack ends


code segment

	begin:	mov ax,data
			mov ds,ax
			mov si,0
			mov ax,stack
			mov ss,ax
			mov sp,32
			
			mov dh,13		;row
			mov dl,2		;column
			mov cl,1		;color
			call show_str
			
			call letterc
			
			mov dh,15		;row
			mov dl,2		;column
			mov cl,4		;color
			call show_str
			
			mov ax,4c00h
			int 21h
	
	letterc	:
			push si
			push ax
		
		s:	mov al,[si]
			cmp al,0
			je r
			cmp al,'a'
			jb l
			cmp al,'z'
			jg l 
			and al,11011111b
			mov [si],al
		
		l:
			inc si
			jmp short s
		
		r:	pop ax
			pop si
			ret
			
			
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
end begin