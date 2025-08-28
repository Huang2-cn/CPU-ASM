section .text
global main
[bits 16]
[org 0]
main:
    nop
    nop
    nop
    mov ax,cs        ;把cs寄存器的值拿出来
    add ax,10        ;加上10
    mov ss,ax        ;再给栈段寄存器,就不怕覆盖数据了
    mov sp,0ffffh    ;初始化栈指针
    call getip
        getip:       ;变相获得ip寄存器的值
            pop di   ;放到di里(反正di我也不怎么用)
            mov ax,$-main    ;减去getip之前的机器码长度    
            inc di
            sub di,ax
    mov ax,cs
    mov ds,ax           ;初始化数据段寄存器
    mov ax,0b800h
    mov es,ax
    mov si,0
    mov bx,information
    call pstr
    
        ;加载32位代码过程   
        cli         ;屏蔽外部中断
            mov ax,100h
            mov es,ax
            mov si,start_32_bit
            add si,di
            xor di,di
            move_code:
                mov eax,[si]
                cmp eax,'ENDC'              ;比较是否是结束标志
                jne c_move
                    jmp 100h:0000h
            c_move:
                add si,4
                stosd
            jmp move_code
         information:   db  'Boot Succeed,If pause in this screen too long,your graphic may not support VESA 2.0 mode!',0
    pstr:
        add bx,di
        mov al,ds:[bx]
        cmp al,0
        jne pstr_next
            ret
        pstr_next:
        call pchar
        inc bx
    jmp pstr
    pchar:
        mov es:[si],al
        inc si
        mov es:[si],byte 10001010b
        inc si
    ret
;16位代码与数据部分结束     
start_32_bit: