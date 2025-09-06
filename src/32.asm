section .text
global main_32
%include "define.asm"
[org 1000h]
main_32:
    [bits 16]
    enter_32:
        mov ax,90h         ;存储VESA信息的段基址
        mov es,ax
        mov ax,0
        mov ds,ax
        mov [BOOTDISK],dl
        mov ax,4f01h
        mov cx,105h
        mov di,0h            ;偏移
        int 10h             ;通过VesaBIOS中断获取显示模式相关信息
            mov ebx,[video_phy_addr]
            mov [video_base_addr],ebx
            xor eax,eax
            xor edx,edx
            mov ax,[screen_width]           ;屏幕宽度
            mov dx,[screen_height]          ;屏幕高度
            mov [video_screen_height],edx
            mov [video_screen_width],eax
            mul edx
            mov ebx,[video_base_addr]
            add ebx,eax
            mov [video_endian_addr],ebx
        lgdt [gdt_reg]
        mov ax,4f02h ;设置显示模式
        mov bx,105h
        int 10h
        mov eax,cr0
        or eax,1                                ;设置PE位
        mov cr0,eax
        jmp gdt_code-gdt_start:entered_32       ;跳转到32位代码并设置cs段选择子
        ;以下是32位部分 
        [bits 32]
        %include "32_sub.asm"   ;常规子程序  
    entered_32:   
            mov ax,gdt_data-gdt_start
            mov ss,ax
            mov ds,ax
            mov es,ax
            mov fs,ax
            mov gs,ax
            mov esp,800h       ;防止覆盖
            xor ebx,ebx
            xor eax,eax
            xor ecx,ecx
            xor edx,edx
            xor esi,esi
            xor edi,edi
            ;即将分配内存的初始化为0
            mov esi,EMPTY_MEM
                initialize_MEM:
                    mov [esi],DWORD 0
                    cmp esi,EMPTY_MEM_END
                    jae initialize_MEM_Finished
                    add esi,4
                    jmp initialize_MEM
                initialize_MEM_Finished:
            %include "set_palette.asm"
            %include "set_8259.asm"
            
            call test_keyboard
            mov al,60h
            out 64h,al          ;表示接下来会发送一个数据字节
            call test_keyboard
            mov al,47h
            out 60h,al          ;启用鼠标
            call test_keyboard
            mov al,0d4h
            out 64h,al          ;告知下一个字节应发送到鼠标
            call test_keyboard
            mov al,0f4h
            out 60h,al          ;激活鼠标电路
            
            ;启用串口
            mov dx,serial_port+3
                                ;LCR寄存器
            mov al,80h          ;最高位置1，波特率
            out dx,al
            
            mov dx,serial_port  ;波特率分频器低8位
            mov al,0ch          ;波特率9600
            out dx,al
            
            mov dx,serial_port+1
                                ;低八位
            xor al,al
            out dx,al
            ;波特率分频器值=1843200/(目标波特率*16)
            
            mov dx,serial_port+3
                                ;八位,无校验位，1终止位
            mov al,11b
            out dx,al
            
            mov dx,serial_port+2
                                ;FIFO控制
            mov al,0C7h
            out dx,al
            
            mov dx,serial_port+4
                                ;DTR,RTS
            mov al,1011b
            out dx,al
                %if serial_debug = 1
                    serial_print SDB_INFO
                %endif
            
            sti                 ;启用中断
            mov al,0f0h
            call clean_screen 
            %include "set_cpu.asm"
            jmp $
        endian:
            print_nocheck 0ffh,0fh,stopped_msg
        stop:
            hlt
        jmp stop
        

;中断处理程序==========================================================
%include "interrupt.asm"
section .data
;数据部分=============================================================================
%include "palette_data.asm"  ;調色板初始化用的數據
%include "32_data.asm"
;字模====================================================
chars:
;ASCII字模
%include "ASCII.asm"
;中文字模
%include "chinese.asm"
;各种描述符
%include "discribe_table.asm"
align 4
DB 'ENDC'               ;结束标志，用于16位加载器
;以下都将是待分配的内存空间，不需要加载,由程序进行初始化
%include 'EMPTY_DATA.asm'