assume cs:codesg,ds:data,ss:stack

stack segment
    db 128 dup(0)
stack ends

data segment
    db 128 dup(0)
data ends

codesg segment
    start:
        mov bx,data
        mov ds,bx
        mov bx,stack
        mov ss,bx
        mov sp,128

    looop:
        mov ah,0
        int 16h
        cmp al,'r'
        je show_in_red
        cmp al,'g'
        je show_in_green
        cmp al,'b'
        je show_in_blue
        cmp al,'q'
        je return
        cmp al,'Q'
        je return
        jmp short looop
    
    show_in_red:
        mov dl,4
        jmp short show
    show_in_green:
        mov dl,2
        jmp short show
    show_in_blue:
        mov dl,1
        jmp short show
    show:
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
    show_loop:
        mov byte ptr es:[bx],dl
        add bx,2
        loop show_loop

        jmp short looop
    return:
        mov ax,4c00h
        int 21h

codesg ends
end start
