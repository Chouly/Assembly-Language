assume cs:code,ds:data,ss:stack,es:table

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982'
	db '1983','1984','1985','1986','1987','1988','1989','1990'
	db '1991','1992','1993','1994','1995'
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635
	dw 8226,11542,14430,15257,17800
data ends

table segment
	db 21 dup('year sumn ne ?? ')
table ends

str_buf segment
	db 16 dup(0)
str_buf ends

stack segment
	dw 128h dup(0)
stack ends

code segment
start:	
		mov ax,stack
		mov ss,ax
		mov sp,128h		;set stack
		mov ax,data
		mov ds,ax		;set ds = data
		mov ax,table
		mov es,ax		;set es = table
		
		mov bx,0		;table
		mov bp,0
		mov di,0
		mov cx,21	
		
	s0:	push cx
		mov cx,2
		mov si,0
		
	s1:	mov ax,ds:[bp+0+si]
		mov es:[bx+0+si],ax
		mov ax,ds:[bp+84+si]
		mov es:[bx+5+si],ax
		add si,2
		loop s1
		
		mov ax,ds:[di+168]
		mov es:[bx+0ah],ax
		
		mov ax,ds:[bp+84]
		mov dx,ds:[bp+86]
		div word ptr ds:[di+168]
		mov es:[bx+0dh],ax
		
		add bx,16
		add bp,4
		add di,2
		pop cx
		loop s0
		
	;display table
		mov ax,table
		mov ds,ax
		mov si,0
		call disp_tab
		
		mov ax,4c00h
		int 21h
	
	;in para ds:si
	;out para:None
	disp_tab:
		mov bx,0		;table 指针
		mov cx,21
		mov dh,2		;row
		mov dl,0		;column
		mov al,2		;color
		mov ah,0
	
	disp1:
		push ax
		push cx
		mov cx,ax
		mov ax,4
		mov dl,2		;column 2
		mov si,0
		call disp_str
		pop cx
		pop ax
		
		call a_a_a_
		
		call b_b_b_
		
		push cx
		push ax
		push dx
		mov ax,[bx+0dh]
		mov dx,0
		push ds
		push ax
		mov ax,str_buf
		mov ds,ax
		pop ax
		mov si,0
		call dtoc
		pop ds
		pop dx
		pop ax
		pop cx
		
		push ds
		push ax
		mov ax,str_buf
		mov ds,ax
		pop ax
		push cx
		mov cx,ax
		mov dl,34		;column 2
		mov si,0
		call show_str
		pop cx
		pop ds
		
		add bx,16
		inc dh
		loop disp1
		ret
	
	;显示指定的ax个字符
	;in parameter: ax,dh,dl,cl,ds:si
	;out parameter:None
	;call method
	;set ds:si,dh,dl,cl
	;返回时不改变输入参数的值，是值传递的。
	disp_str:
			push ax
			push si
			push cx
			push es
			push dx
			push bp	
			
			push ax
			mov ax,0b800h
			mov es,ax
			mov al,160
			mul dh
			mov dh,0
			add dx,dx
			add ax,dx
			mov bp,ax
			mov dl,cl
			pop ax
			mov cx,ax
		disp_str_s:	
			jcxz disp_str_r
			mov al,[bx+si]
			push si
			add si,si
			mov byte ptr es:[bp+si],al
			mov byte ptr es:[bp+1+si],dl
			pop si
			inc si
			dec cx
			jmp short disp_str_s
		
		disp_str_r:
			pop bp
			pop dx
			pop es
			pop cx
			pop si
			pop ax
			ret
	
	;in para:ds:si,ax,dx
	;out para:ax,dx	
	;call method
	;set ds:si,dx,ax
	dtoc:	
			push si
			push bx
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
				pop si
				ret
	
	;double word div
	;in para:dx,ax,cx
	;out para:dx,ax,cx
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
	;in parameter: dh,dl,cl,ds:si
	;out parameter:None
	;call method
	;set ds:si,dh,dl,cl
	;返回时不改变输入参数的值，是值传递的。
	show_str:
			push bx
			push si
			push dx
			push cx
			push ax
			push es
			
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
			pop es
			pop ax
			pop cx
			pop dx
			pop si
			pop bx
			ret
			
	a_a_a_:
			push ax
			push dx
			mov ax,[bx+5]
			mov dx,[bx+7]
			push ds
			push ax
			mov ax,str_buf
			mov ds,ax
			pop ax
			mov si,0
			call dtoc
			pop ds
			pop dx
			pop ax
			
			push ds
			push ax
			mov ax,str_buf
			mov ds,ax
			pop ax
			push cx
			mov cx,ax
			mov dl,12		;column 2
			mov si,0
			call show_str
			pop cx
			pop ds
			ret
			
	b_b_b_:
			push cx
			push ax
			push dx
			mov ax,[bx+0ah]
			mov dx,0
			push ds
			push ax
			mov ax,str_buf
			mov ds,ax
			pop ax
			mov si,0
			call dtoc
			pop ds
			pop dx
			pop ax
			pop cx
			
			push ds
			push ax
			mov ax,str_buf
			mov ds,ax
			pop ax
			push cx
			mov cx,ax
			mov dl,23		;column 2
			mov si,0
			call show_str
			pop cx
			pop ds
			ret
					
code ends

end start