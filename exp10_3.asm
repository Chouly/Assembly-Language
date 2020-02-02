assume cs:code

stack segment
	dw 30 dup(0)
stack ends

data segment
	db 10 dup(0)
data ends

code segment
	start:	mov bx,data
			mov ds,bx
			mov bx,stack
			mov ss,bx
			mov sp,60
			
			mov ax,12666
			mov si,0
			call dtoc
			
			mov dh,8
			mov dl,3
			mov cl,2
			call show_str
			
			mov ax,4c00h
			int 21h
			
	dtoc:	push dx
			push cx
			mov cx,0
			push cx
			
	dtoc_s:	mov dx,0
			mov cx,10
			div cx
			pop cx
			push dx
			inc cx
			push cx
			mov cx,ax
			jcxz dtoc_r
			jmp short dtoc_s
			
	dtoc_r:	pop cx
		
	dtoc_s1:pop ax
			add al,30h
			mov [si],al
			inc si
			loop dtoc_s1
			
			mov byte ptr [si],0
			pop cx
			pop dx
			ret
			
show_str:	push ax
			push es
			push dx
			push si
			
			mov si,0
			mov ax,0b800h
			mov es,ax
			mov al,160
			mul dh
			mov dh,0
			add dx,dx
			add ax,dx
			mov bx,ax
			mov dl,cl
		
		s:	mov ch,0
			mov cl,[si]
			jcxz r
			mov al,[si]
			push si
			add si,si
			mov byte ptr es:[bx+si],al
			mov byte ptr es:[bx+1+si],dl
			pop si
			inc si
			jmp short s
		
		r:	pop si
			pop dx
			pop es
			pop ax
			ret

code ends

end start
			
			