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

        mov al,03fh
        call showbyte
        
        mov ax,4c00h
        int 21h

    ;以16进制显示数据
    ;用al传送要显示的数据
    showbyte:
        jmp short show 
        table db '0123456789ABCDEF'     ;字符表
    show:
        push ax
        push bx
        push cx
        push es
        push di
        mov ah,al
        mov cl,4
        shr ah,cl
        and al,00001111b

        mov bx,0b800h
        mov es,bx
        mov di,160*12+40*2
        mov bl,ah
        mov bh,0
        mov ah,table[bx]
        mov es:[di],ah
        add di,2
        mov bl,al
        mov bh,0
        mov al,table[bx]
        mov es:[di],al

        pop di
        pop es
        pop cx
        pop bx
        pop ax
        ret
code ends
end start
