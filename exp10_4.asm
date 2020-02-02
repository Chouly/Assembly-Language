assume cs:code

data segment
	db 16 dup(0)
data ends

stack segment
	dw 20h dup(0)
stack ends

code segment
	start:	mov ax,data
			mov ds,ax
			mov si,0
			mov ax,stack
			mov ss,ax
			mov sp,20h
			
			mov dx,13h
			mov ax,53eah	;1266666
			call dtoc
			
			mov dh,8		;row 8
			mov dl,3		;column 2
			mov cl,2		;color green
			call show_str
			
			mov ax,4c00h
			int 21h

	dtoc:	push bx
			push cx
			mov bx,0
			
		dtoc_s:	mov cx,10
				call divdw
				push cx
				inc bx
				mov cx,dx
				or cx,ax
				jcxz dtoc_r
				jmp short dtoc_s
		
		dtoc_r:	mov cx,bx
		dtoc_rs:pop ax
				add ax,30h
				mov [si],al
				inc si
				loop dtoc_rs
				mov byte ptr [si],0
				pop cx
				pop bx
				ret
	
	;double word div			
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
	
	;show a string
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