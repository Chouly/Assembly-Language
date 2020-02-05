assume cs:code,ds:data,ss:stack

data segment
    db 16 dup(0)
data ends

stack segment
    dw 16 dup(0)
stack ends

code segment

    start:
        mov ax,1000h
        mov bl,1
        div bl

        mov ax,4c00h
        int 21h
code ends
end start