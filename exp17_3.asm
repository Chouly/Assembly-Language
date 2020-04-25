;编写一个接受字符串输入的子程序
;实现最基本的3个功能
;1、在输入的同时需要显示这个字符串
;2、输入回车字符后，字符串结束
;3、能够删除已经输入的字符
;子程序参数说明
;(dh)、(dl)=字符串在屏幕上显示的行和列的位置
;ds:si指向字符串的存储空间，字符串以0位结尾符
;

assume cs:code,ss:stack,ds:data
stack segment
    db 128 dup(0)
stack ends

data segment
    db 2048 dup(0)
data ends

code segment 
    main:
        mov ax,stack
        mov ss,ax
        mov sp,128

        mov ax,data
        mov ds,ax
        mov si,0
        mov dh,12   ;行号
        mov dl,3    ;列号

        call input_str

        mov ax,4c00h
        int 21h

    input_str:
        push ax
        push bx
        push cx
        push dx
        push si

    input:
        mov ah,2    ;置光标
        mov bh,0    ;第0页
        ;mov dh,12  ;行号
        ;mov dl,3   ;列号
        int 10h

        mov ah,0    ;等待输入
        int 16h 

        ;判断输入
        ;输入可显示字符后直接显示在屏幕上,否则判断功能
        cmp ah,01h
        je Esc_
        cmp ah,0eh
        je Backspace
        cmp ah,0fh
        je Tab
        cmp ah,1ch
        je Enter

        ;存入内存中
        mov byte ptr [si],al
        inc si
        ;在光标处显示已输入字符
        mov ah,9
        ;mov al,'a'
        mov bl,2
        mov bh,0
        mov cx,1
        int 10h

        add dl,1
        cmp dl,80
        jne input
        mov dl,0
        add dh,1
        jmp short input

    Tab:
        ;存入内存中
        push cx
        mov cx,4
    Tab_loop:
        mov byte ptr [si],al
        inc si
        jcxz Tab_loop
        pop cx
        ;在光标处显示已输入字符
        mov ah,9
        ;mov al,20h
        mov bl,2
        mov bh,0
        mov cx,4
        int 10h
        mov cx,4
    Tab_adj:
        add dl,1
        cmp dl,80
        jne Tab_adj_loop
        mov dl,0
        add dh,1
    Tab_adj_loop:
        loop Tab_adj
        jmp short input
    Backspace:
        ;退格，撤销上一次输入
        cmp dl,0
        je adj
        sub dl,1
        jmp short adj_
    adj:
        mov dl,79
        sub dh,1
    adj_:
        mov ah,2    ;置光标
        mov bh,0    ;第0页
        int 10h
        mov ah,9
        mov al,20h
        mov bl,2
        mov bh,0
        mov cx,1
        int 10h
        jmp near ptr input
    Esc_:
        jmp short Enter
    Enter:
        mov byte ptr [si],0
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret

code ends
end main
