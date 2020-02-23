assume cs:code,ds:data,ss:stack
stack segment
    dw 20h dup(0)
stack ends

data segment 
    db '../../.. ..:..:..','$'
data ends

code segment

data_time:  db 0,3,6,9,12,15
timer:      db 9,8,7,4,2,0

    start:
        mov ax,data
        mov ds,ax
        mov ax,cs
        mov es,ax
        mov si,offset timer
        mov di,0
        mov cx,6
    lp: mov al,es:[si]
        out 70h,al
        in al,71h
        mov ah,al
        push cx
        mov cl,4
        shr ah,cl
        pop cx
        and al,0fh
        add ah,30h
        add al,30h
        mov bh,0
        mov bl,es:[si-6]
        mov di,bx
        mov [di],ah
        mov [di+1],al
        add si,1
        loop lp

        mov ah,2
        mov bh,0
        mov dh,12
        mov dl,35
        mov bl,2
        int 10h
        mov dx,0
        mov ah,9
        int 21h

        mov ax,4c00h
        int 21h
code ends
end start
    