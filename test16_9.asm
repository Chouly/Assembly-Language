assume cs:code,ds:data,ss:stack
stack segment
    db 128 dup(0)
stack ends

data segment
    db 128 dup(0)
data ends

code segment
    start:
        mov ax,stack
        mov ss,ax
        mov sp,128
        mov ax,data 
        mov ds,ax

        mov ah,1
        mov al,3
        int 7ch
        
        mov ax,4c00h
        int 21h

code ends
end start