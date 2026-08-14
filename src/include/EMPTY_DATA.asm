EMPTY_MEM:
BOOTDISK:           db  0
failure:            db  0
NUL:                dq  0
                    db  0
CPU_Type:           db  0
Freq_X:             dd  0
Freq_Y:             dd  0 
BCLK_X:             dd  0
TSC:                dd  0
TSC_HIGH:           dd  0
TSC_COUNT:          db  0
BCLK_Y:             dd  0
CPUVendor:          dd  0,0,0
                    db  0
        align 8,db 0                     ;将IDT对其到8字节以提升CPU访问效率
    idt:
        db 2048 dup(0)              ;初始化中断描述符表空间
    temp:           db  128 dup (0)   
    win_chain_buffer:
        db   MAX_WINDOW*win_chain.size dup(0) 
CPU_FUNCTION:       db 1024 dup (0)
    PMI_ADDR:       dd 0
    PMI_LEN:        db 0
    PMI:
STACK:              db 16384 dup(0)
MEM_AVAILABLE:      dd 0
EMPTY_MEM_END:          ;后面的内存均可自由分配