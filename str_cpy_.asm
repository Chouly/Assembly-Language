assume cs:code,ds:data,ss:stack

data segment
    db "Please check the common environment!",0
data ends

stack segment
    dw 20h dup(0)
stack ends

string segment
    db 40h dup(0)
string ends

code segment
    main:
        mov ax,stack
        mov ss,ax
        mov sp,40h

        mov ax,data
        mov ds,ax
        mov si,0
        mov ax,string
        mov es,ax
        mov di,0
        mov cx,36
        cld
        rep movsb

        mov ax,4c00h
        int 21h

code ends
end main