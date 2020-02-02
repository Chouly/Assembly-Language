assume cs:code,ds:data

data segment
	dd 12345678h,2,3,4
data ends

code segment 
	start:	mov ax,4c00h
			int 21h
code ends

end start