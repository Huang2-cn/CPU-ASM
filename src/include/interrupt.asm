section .text
    set_idt_gate:                       ;设置中断描述符，eax为中断向量号，edx为中断目标代码地址
                                        ;中断向量号*8即为该描述符的地址                    
        push ebx                        ;保存寄存器的值
        push edx
        push eax
            mov ebx,idt                 ;将IDT的基址加载到ebx寄存器中
            lea ebx,[ebx+eax*8]         ;计算中断向量号在IDT中的偏移地址
            mov word [ebx],dx           ;中断处理程序的低16位地址
            shr edx,16                  ;将地址的高16位移到低16位
            mov word [ebx+6],dx         ;中断处理程序的高16位地址
            mov word [ebx+2],cs         ;段选择子
            mov word [ebx+4],1000111000000000b  ;属性：存在,特权级0,中断门,32位
        pop eax
        pop edx
        pop ebx                         ;恢复寄存器的值
     ret
     
     
        LIDTGATE:
            mov eax,0
            mov edx,INT_NOTHING
            LIDTG_LOOP:
                call set_idt_gate
                inc eax
                cmp eax,255
            jna LIDTG_LOOP
            
            
            
            mov eax,0h
            mov edx,INT_DIV0
            
            call set_idt_gate
            mov eax,3h
            mov edx,debug_int3
            call set_idt_gate
            
            mov eax,06h                     ;#UD中断
            mov edx,INT_UD
            call set_idt_gate
            
            mov eax,08h                     ;#DF中断
            mov edx,INT_DF
            call set_idt_gate
            
            mov eax,0dh                     ;#GP中断
            mov edx,INT_GP
            call set_idt_gate
            
            mov eax,20h                     ;时钟中断
            mov edx,INT_TIMER
            call set_idt_gate
            
            mov eax,21h                     ;键盘中断
            mov edx,INT_KEYBOARD
            call set_idt_gate
            
            mov eax,23h                     ;串口2中断
            mov edx,INT_SERIAL
            call set_idt_gate
            
            mov eax,24h                     ;串口1中断
            mov edx,INT_SERIAL
            call set_idt_gate
            
            mov eax,25h                     ;并口2中断
            mov edx,INT_LPT
            call set_idt_gate
            
            mov eax,26h                     ;软驱中断
            mov edx,INT_FLOPPY
            call set_idt_gate
            
            mov eax,27h                     ;并口1中断
            mov edx,INT_LPT
            call set_idt_gate
            
            mov eax,2ch                     ;鼠标中断
            mov edx,INT_MOUSE_TEMP          ;处理第一次鼠标初始化结束后的FA信号的中断，在该中断例程内会载入新的描述符
            call set_idt_gate
        ret

        INT_DIV0:
            %if serial_debug = 1
                serial_print DIV0
            %endif
        iretd
        INT_TIMER:
            pushad
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_TMR
                serial_print SDB_OCC
            %endif
            
            out 20h,al          ;主控制
            popad
            sti
        iretd
        debug_int3:
        jmp $

        INT_UD:
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_UD
                serial_print SDB_OCC
            %endif
            mov ax,[Reading_MSR]
            cmp ax,0
            jne testing_MSR
            mov al,0E1h                     ;显示蓝屏
            call dword [clean_screen]
            pop ebx
            mov eax,ebx
            ror eax,24d
            call hex2ascii
            mov [ER_EIP],al
            mov [ER_EIP+1],ah
            mov eax,ebx
            ror eax,16d
            call hex2ascii
            mov [ER_EIP+2],al
            mov [ER_EIP+3],ah
            mov eax,ebx
            ror eax,8d
            call hex2ascii
            mov [ER_EIP+4],al
            mov [ER_EIP+5],ah
            mov eax,ebx
            call hex2ascii
            mov [ER_EIP+6],al
            mov [ER_EIP+7],ah
            
            pop bx
            mov al,bh
            call hex2ascii
            mov [ER_CS],al
            mov [ER_CS+1],ah
            mov al,bl
            call hex2ascii
            mov [ER_CS+2],al
            mov [ER_CS+3],ah
            prints 0ffh,0E1h,UD_MSG
            prints 0ffh,0E1h,ER_MSG
            JMP $
        
        testing_MSR:
                ;如果是在测试MSR
                mov [Reading_MSR],byte 0
                mov [Multiplier],dword 4E614E00h   ;NaN
                mov [Support_MSR],byte 0
                add eax,12d
                jmp Corp_Process_fin
                pop eax
                mov eax,Corp_Process_fin           ;iret到这里
                push eax
                
            iretd
        
        INT_GP:             ;通用保护异常处理程序
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_GP
                serial_print SDB_OCC
            %endif        
            SUB ESP,4h
            mov ax,[Reading_MSR]
            cmp ax,0
            jne testing_MSR
            mov al,0E1h                     ;显示蓝屏
            call dword [clean_screen]
            pop ebx
            mov eax,ebx
            ror eax,24d
            call hex2ascii
            mov [ER_EIP],al
            mov [ER_EIP+1],ah
            mov eax,ebx
            ror eax,16d
            call hex2ascii
            mov [ER_EIP+2],al
            mov [ER_EIP+3],ah
            mov eax,ebx
            ror eax,8d
            call hex2ascii
            mov [ER_EIP+4],al
            mov [ER_EIP+5],ah
            mov eax,ebx
            call hex2ascii
            mov [ER_EIP+6],al
            mov [ER_EIP+7],ah
            
            pop bx
            mov al,bh
            call hex2ascii
            mov [ER_CS],al
            mov [ER_CS+1],ah
            mov al,bl
            call hex2ascii
            mov [ER_CS+2],al
            mov [ER_CS+3],ah
            prints 0ffh,0E1h,GP_MSG
            prints 0ffh,0E1h,ER_MSG
            JMP $
            
            
            
        INT_DF:             ;双重错误处理程序
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_DF
                serial_print SDB_OCC
            %endif        
            SUB ESP,4h
            mov al,0E1h                     ;显示蓝屏
            call dword [clean_screen]
            pop ebx
            mov eax,ebx
            ror eax,24d
            call hex2ascii
            mov [ER_EIP],al
            mov [ER_EIP+1],ah
            mov eax,ebx
            ror eax,16d
            call hex2ascii
            mov [ER_EIP+2],al
            mov [ER_EIP+3],ah
            mov eax,ebx
            ror eax,8d
            call hex2ascii
            mov [ER_EIP+4],al
            mov [ER_EIP+5],ah
            mov eax,ebx
            call hex2ascii
            mov [ER_EIP+6],al
            mov [ER_EIP+7],ah
            
            pop bx
            mov al,bh
            call hex2ascii
            mov [ER_CS],al
            mov [ER_CS+1],ah
            mov al,bl
            call hex2ascii
            mov [ER_CS+2],al
            mov [ER_CS+3],ah
            prints 0ffh,0E1h,DF_MSG
            prints 0ffh,0E1h,ER_MSG
            JMP $         
            
            
        INT_MOUSE_TEMP:
            pushad
            xor eax,eax
            in al,60h
            mov eax,2ch                ;鼠标中断
            mov edx,INT_MOUSE          ;正式描述符
            call set_idt_gate
            jmp EOI
            
        INT_MOUSE:          ;鼠标中断
            pushad
            xor eax,eax
            xor ebx,ebx
            in al,60h
            cmp al,0fah     ;忽略就绪信号
            je MOUSE_IRET

        MOUSE_IRET:
             %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_MOUSE
                serial_print SDB_OCC
            %endif        
            mov al,01100100b    ;OCW2，循环优先级，手动指定IRQ最低优先级(IRQ4)，EOI
            out 0a0h,al         ;从8259A的控制端口
            mov al,01100010b    ;OCW2，循环优先级，手动指定IRQ最低优先级(IRQ2)，EOI
            out 20h,al          ;主8259A的控制端口
            popad
            sti
        iretd
        INT_KEYBOARD:
            pushad
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_KEYBORAD
                serial_print SDB_OCC
            %endif     
            in al,60h   
            
            mov al,61h          ;OCW2，循环优先级，手动指定IRQ最低优先级（IRQ1），EOI
            out 20h,al          ;主控制
            popad
            sti
        iretd
        keyboard_count  dd 0
        INT_NOP_ECODE:
            cli
            
            add esp,4
            PUSHAD
        jmp EOI
        INT_SERIAL:
            cli
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_SERIAL
                serial_print SDB_OCC
            %endif     
            pushad
        jmp EOI
        INT_LPT:
            cli
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_LPT
                serial_print SDB_OCC
            %endif     
            pushad
        jmp EOI     
        INT_FLOPPY:
            cli
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_FLOPPY
                serial_print SDB_OCC
            %endif     
            pushad
        jmp EOI           
        INT_NOTHING:
            cli
            pushad
        EOI:
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_UNKNOWN
                serial_print SDB_OCC
            %endif     
            
            mov al,20h          ;OCW2，EOI
            out 0a0h,al         ;从控制
            nop
            out 20h,al          ;主控制
            popad
            sti
        iretd
        INT_TEST:
            cli
            pushad
            %if serial_debug = 1
                serial_print SDB_INT
                serial_print SDB_TEST
                serial_print SDB_OCC
            %endif     
            
            mov al,20h          ;OCW2，EOI
            out 0a0h,al         ;从控制
            nop
            out 20h,al          ;主控制
            popad
            sti
        iretd
        