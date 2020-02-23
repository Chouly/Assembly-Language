assume cs:code,ss:stack,ds:data
stack segment
    db 128 dup(0)
stack ends

data segment
    dw 0,0
data ends

code segment
    start:
        mov ax,stack
        mov ss,ax
        mov sp,128

        mov ax,data
        mov ds,ax

        mov ax,0
        mov es,ax

        push es:[9*4]
        pop ds:[0]
        push es:[9*4+2]
        pop ds:[2]
        
        cli
        mov word ptr es:[9*4],offset int9
        mov word ptr es:[9*4+2],cs
        sti

        mov ax,0b800h
        mov es,ax
    s0: mov ah,'a'
    sl: mov es:[160*12+40*2],ah
        ;mov byte ptr es:[160*12+40*2+1],2
        call delay
        inc ah
        cmp ah,'z'
        jna sl
        ;jmp short s0

        mov ax,0
        mov es,ax

        cli
        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4+2]
        sti

        mov ax,4c00h
        int 21h

    delay:
        push ax
        push dx
        mov dx,6h
        mov ax,0
    s2: sub ax,1
        sbb dx,0
        cmp ax,0
        jne s2
        cmp dx,0
        jne s2
        pop dx
        pop ax
        ret

    int9:
        push ax
        push es
        in al,60h

        pushf
        call dword ptr ds:[0]

        cmp al,1
        jne int9_ret
        mov ax,0b800h
        mov es,ax
        inc byte ptr es:[160*12+40*2+1]
    int9_ret:
        pop es
        pop ax
        iret
code ends
end start