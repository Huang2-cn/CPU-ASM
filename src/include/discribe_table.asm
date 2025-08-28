section .text

gdt_start:
    dd 0                ; 空描述符
    dd 0
gdt_code:               ;代码段描述符
    dw 0FFFFh           ;段界限 4G
    dw 0                ;段基址
    db 0                ;段基址
    db 10011100b        ;存在,DPL为0(占两位)，非硬件系统段,可执行,可读,非依从代码段
    db 11001111b        ;粒度为4k,默认操作数大小为dword(32bit,用EIP寄存器),不是64位代码段,0(这一位随便),后面4位是段界限的19~16位
    db 0                ;段基址
gdt_code_temp:          ;临时代码段描述符
    dw 0FFFFh           ;段界限 4G
    dw 0                ;段基址
    db 2h               ;段基址
    db 10011100b        ;存在,DPL为0(占两位)，非硬件系统段,可执行,可读,非依从代码段
    db 11001111b        ;粒度为4k,默认操作数大小为dword(32bit,用EIP寄存器),不是64位代码段,0(这一位随便),后面4位是段界限的19~16位
    db 0                ;段基址
; 数据段描述符
gdt_data:
    dw 0FFFFh           ;段界限 4G
    dw 0                ;段基址 0
    db 0                ;段基址
    db 10010010b        ;存在,DPL为0(2bit),非硬件系统段,不可执行,可读,向上扩展(数据段)
    db 11001111b        ;粒度4k,dword,非64位,0,段界限
    db 0                ;段基址
gdt_code_16:            ;16位代码段描述符
    dw 0FFFFh           ;段界限 4G
    dw 0                ;段基址
    db 0                ;段基址
    db 10011100b        ;存在,DPL为0(占两位)，非硬件系统段,可执行,可读,非依从代码段
    db 10001111b        ;粒度为4k,默认操作数大小为word(16bit,用IP寄存器),不是64位代码段,0(这一位随便),后面4位是段界限的19~16位
    db 0                ;段基址
gdt_data_16:
    dw 0FFFFh           ;段界限 4G
    dw 0                ;段基址 0
    db 0                ;段基址
    db 10010010b        ;存在,DPL为0(2bit),非硬件系统段,不可执行,可读,向上扩展(数据段)
    db 10001111b        ;粒度4k,word,非64位,0,段界限
    db 0                ;段基址
gdt_end:
gdt_reg:
    dw gdt_end - gdt_start - 1 ; GDT长度
    dd gdt_start               ; GDT基址


idtr:
        idt_limit dw 2047           ;段界限
        idt_base  dd idt            ;段基址

        