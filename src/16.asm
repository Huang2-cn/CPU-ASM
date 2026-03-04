section .text
global main
[bits 16]
[org 0]
main:
    nop              ;给NTFS磕三个头
    nop              ;第二个
    nop              ;第三个
    mov ax,cs        ;把cs寄存器的值拿出来
    add ax,10        ;加上10
    mov ss,ax        ;再给栈段寄存器
    mov sp,0ffffh    ;初始化栈指针
    call getip
        getip:       ;变相获得ip寄存器的值
            pop di   ;放到di里(作为全局偏移量保证兼容性)
            mov ax,$-main    ;减去getip之前的机器码长度    
            inc di
            sub di,ax
    mov ax,cs
    mov ds,ax           ;初始化数据段寄存器
    MOV AH,00h
    MOV AL,03h          ; 80x25 16色文本模式
    INT 10H
    mov ax,0b800h
    mov es,ax
    mov si,0
    mov bx,information
    mov cl,10001010b
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
         information:   db  'Boot Succeed,Loading 32-Bit mode.' ,0
    pstr:
        add bx,di
    pstr_loop:
        mov al,ds:[bx]
        cmp al,0
        jne pstr_next
            ret
        pstr_next:
        call pchar
        inc bx
    jmp pstr_loop
    pchar:
        mov es:[si],al
        inc si
        mov es:[si],cl
        inc si
    ret
;16位代码与数据部分结束     
start_32_bit: