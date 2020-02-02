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

stack segment
	dw 8 dup(0)
stack ends

code segment
start:	mov ax,data
		mov ds,ax
		mov ax,stack
		mov ss,ax
		mov sp,10h
		mov ax,table
		mov es,ax
		
		mov bx,0
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
		
		mov ax,4c00h
		int 21h
		
code ends

end start