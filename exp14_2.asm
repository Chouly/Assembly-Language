assume cs:code
code segment
    mov ax,1234
    shl ax,1
    mov bx,ax
    mov cl,2
    shl ax,cl
    add ax,bx

    mov ax,4c00h
    int 21h
code ends
end