assume cs:code,ss:stack
stack segment
    db 128 dup(0)
stack ends

code segment
    start:
        mov ax,stack
        mov ss,ax
        mov sp,128

        mov ax,0
        mov ds,ax
        push ds:[9*4]
        pop ds:[200h]
        push ds:[9*4+2]
        pop ds:[202h]

        mov ax,cs
        mov ds,ax
        mov si,offset int9
        mov ax,0
        mov es,ax
        mov di,204h
        mov cx,offset int9end - offset int9
        cld
        rep movsb

        mov ax,0
        mov es,ax

        push bx
        pushf
        pop ax
        mov bx,ax
        and ah,11111100b
        push ax
        popf
        mov word ptr es:[9*4],204h
        mov word ptr es:[9*4+2],0
        push bx
        popf
        pop bx

        mov ax,4c00h
        int 21h

    int9:
        push ax
        push bx
        push cx
        push es

        in al,60h
        pushf
        call dword ptr cs:[200h]

        cmp al,3bh
        jne int9ret
        mov ax,0b800h
        mov es,ax
        mov bx,1
        mov cx,2000
    int9_s:
        inc byte ptr es:[bx]
        add bx,2
        loop int9_s
    int9ret:
        pop es
        pop cx
        pop bx
        pop ax
        iret
    int9end:
        nop

code ends
end start