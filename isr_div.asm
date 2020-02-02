assume cs:code,ds:data,ss:stack

data segment
    db 20h dup(0)
data ends

stack segment
    dw 60h dup(0)
stack ends

code segment
    main:
        ;do0安装程序
        mov ax,cs
        mov ds,ax
        mov si,offset do0
        mov ax,0
        mov es,ax
        mov di,200h
        mov cx,offset do0_end - offset do0
        cld
        rep movsb
        ;设置中断向量表
        mov ax,0
        mov es,ax
        mov ax,200h
        mov es:[0*4],ax
        mov ax,0
        mov es:[0*4+2],ax

        mov ax,4c00h
        int 21h

    do0:
        jmp short do0_main
        do0_message:
        db "divide error! overflow!",0
        do0_main:
        mov ax,0
        push ax
        mov ax,200h + offset do0_message - offset do0
        push ax
        mov ax,12
        push ax
        mov ax,29
        push ax
        mov ax,4
        push ax
        call show_str

        mov ax,4c00h
        int 21h
        ;show_str
        ;功能：向显示屏输出字符串，遇到0结束。
        ;输入参数：字符串的首地址，由ds和si确定，显示的行号dh，列号dl，颜色cl。
        ;输出参数：无。
        ;备注：采用栈来传递参数,调用函数后不改变所有寄存器的值。
        ;函数名：show_str
        ;调用方式：设置ds:si,dh,dl,cl
        ;mov ax,data
        ;push ax
        ;mov ax,0
        ;push ax
        ;mov ax,12
        ;push ax
        ;mov ax,6
        ;push ax
        ;mov ax,2
        ;push ax
        ;call show_str
        show_str:
            push ds
            push si
            push dx
            push cx
            push es
            push di
            push bx
            push bp
            mov bp,sp
            mov cx,[bp+18]
            mov ax,[bp+20]
            mov dl,al
            add dl,dl
            mov ax,[bp+22]
            mov dh,al
            mov ax,[bp+24]
            mov si,ax
            mov ax,[bp+26]
            mov ds,ax
            mov ax,0b800h
            mov es,ax
            mov di,0
            mov ax,160
            mul dh
            mov dh,0
            add ax,dx
            mov bx,ax
            mov dl,cl
        show_str_loop:
            mov al,[si]
            mov ch,0
            mov cl,al
            jcxz show_str_ret
            mov es:[bx+di],al
            mov es:[bx+di+1],dl
            inc si
            inc di
            inc di
            jmp short show_str_loop
        show_str_ret:
            pop bp
            pop bx
            pop di
            pop es
            pop cx
            pop dx
            pop si
            pop ds
            ret 10
    do0_end:
        nop
code ends
end main