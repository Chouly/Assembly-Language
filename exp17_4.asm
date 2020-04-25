assume cs:code,ss:stack
stack segment
    db 128 dup(0)
stack ends

code segment 
    start:
        mov ax,0b800h
        mov es,ax
        mov bx,0

        mov al,8    ;sector
        mov ch,0
        mov cl,1
        mov dh,0
        mov dl,81h
        mov ah,2    ;read disk
        int 13h

        mov ax,4c00h
        int 21h

code ends
end start