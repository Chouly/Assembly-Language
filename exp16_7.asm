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

        mov dx,0
        mov ax,120
        call showsin
        
        mov ax,4c00h
        int 21h

    ;显示sin(x)的值
    ;用ax传送角度值，单位是度，ax=0,30,60,90,120,150,180
    showsin:
        jmp short sin 
        table dw ag0,ag30,ag60,ag90,ag120,ag150,ag180
        ag0 db '0',0
        ag30 db '0.5',0
        ag60 db '0.866',0
        ag90 db '1',0
        ag120 db '0.866',0
        ag150 db '0.5',0
        ag180 db '0',0
    
    sin:
        push ax
        push bx
        push cx
        push si
        push di
        push es

        mov cx,30
        div cx
        mov bx,ax
        add bx,bx
        mov si,table[bx]
        mov ax,0b800h
        mov es,ax
        mov di,160*12+40*2
    sinloop:
        mov cl,cs:[si]
        cmp cl,0
        je sinret
        mov es:[di],cl
        add di,2
        inc si
        jmp short sinloop
    sinret:
        pop es
        pop di
        pop si
        pop cx
        pop bx
        pop ax
        ret
    
code ends
end start