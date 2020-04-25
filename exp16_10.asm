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

        mov ax,cs
        mov ds,ax
        mov ax,0
        mov es,ax
        mov si,offset setscreen
        mov di,200h
        mov cx,offset setscreen_end - offset setscreen
        cld
        rep movsb

        cli
        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*+2],0
        sti
        
        mov ax,4c00h
        int 21h

    setscreen:
        jmp short setscreen_start
    fun:   
        dw offset sub1-offset setscreen,offset sub2-offset setscreen,offset sub3-offset setscreen,offset sub4-offset setscreen
    setscreen_start:
        push ax
        push bx
        mov bl,ah
        mov bh,0
        cmp bx,3
        jg setscreen_ret
        add bx,bx
        add bx,offset fun - offset setscreen
        add bx,200h
        mov bx,cs:[bx]
        add bx,200h

        call bx
    setscreen_ret:
        pop bx
        pop ax
        iret

    ;清屏
    sub1: 
        push ax
        push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000
    sub1_loop:
        mov byte ptr es:[bx],20h
        add bx,2
        loop sub1_loop

        pop es
        pop cx
        pop bx
        pop ax
        ret
    
    ;设置前景色
    sub2:
        push ax
        push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
    sub2_loop:
        and byte ptr es:[bx],11111000b
        or es:[bx],al
        add bx,2
        loop sub2_loop

        pop es
        pop cx
        pop bx
        pop ax
        ret

    ;设置背景色
    sub3:
        push ax
        push bx
        push cx
        push es

        mov cl,4
        shl al,cl
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
    sub3_loop:
        and byte ptr es:[bx],10001111b
        or es:[bx],al
        add bx,2
        loop sub3_loop

        pop es
        pop cx
        pop bx
        pop ax
        ret
    
    ;向上滚动一行
    sub4:
        push ax
        push bx
        push cx
        push si
        push di
        push ds
        push es

        mov bx,0b800h
        mov ds,bx
        mov es,bx
        mov si,160
        mov di,0
        mov cx,2000-80
        cld
        rep movsw

        mov cx,80
    sub4_loop:
        mov byte ptr es:[si],20h
        add si,2
        loop sub4_loop

        pop es
        pop ds
        pop di
        pop si
        pop cx
        pop bx
        pop ax
        ret
    setscreen_end:
        nop

code ends
end start
