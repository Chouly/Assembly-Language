assume cs:code
code segment
    mov ax,0b800h
    mov es,ax
    mov di,1
    mov cx,2000
lp: mov byte ptr es:[di],00100000b
    add di,2
    loop lp
    

    mov ax,4c00h
    int 21h
code ends
end