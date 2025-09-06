section .text
%include "32_video.asm"     ;视频操作子程序
%include "display_CPU.asm"
%include "CPU_Intel.asm"
%include "CPU_AMD.asm"
    serial_out:                 ;串口输出字符串,esi指向字符串
        push dx
        push ax
        push esi
        mov al,[esi]
        SO_LOOP:
            mov dx,serial_port
            out dx,al           ;将AL放入缓冲区
            inc esi
            mov dx,serial_port+5
                test_serial_buffer: 
                                ;测试缓冲区是否已空
                    in al,dx    ;确认数据线是否空闲
                    test al,20h ;确定是否已空
                jz test_serial_buffer
                cmp al,0
            mov al,[esi]
            cmp al,0
        jne SO_LOOP
        pop esi
        pop ax
        pop dx
    ret
        
    hex2ascii:                  ;由直接的16进制值转为对应的ASCII(AL输入,AX输出)
        push bx
            mov bl,al
            and bl,00001111b
            add bl,30h
            cmp bl,3ah
            jnae h2a_low_below_a
                add bl,7
            h2a_low_below_a:
            mov ah,bl
            mov bl,al
            shr bl,4h
            add bl,30h
            cmp bl,3ah
            jnae h2a_high_below_a
                add bl,7
            h2a_high_below_a:
            mov al,bl
        pop bx
    ret
    
    hex2dec:            ;AX为hex值，esi指向输出位置(需要6字节)
        push edx
        push eax
        push ebx
        push edi
        mov edi,esi
        mov bx,0ah      ;10
            h2d:
                xor edx,edx
                div bx
                add dx,'0'
                mov [esi],dx
                inc esi
                cmp ax,0
            jne h2d
            dec esi
            h2d_reverse:
                mov ah,[esi]
                mov al,[edi]
                mov [edi],ah
                mov [esi],al
                mov eax,esi
                sub eax,edi
                inc edi
                dec esi
                cmp eax,1
            ja h2d_reverse
        pop edi
        pop ebx
        pop eax
        pop edx
    ret
    

        dword_hex:       ;16进制数转ASCII函数，数字存储于eax寄存器，esi指向目的内存(1QWORD)
                         ;累了，不想写循环了，虽然能让代码短很多，但是太累了，而且寄存器也不够，push来pop去的，很乱
                push ebx
                mov ebx,eax             ;使用ebx暂存
                shr ebx,1ch             ;移位1c位，拿到最高4位
                call ph_process         
                mov ebx,eax
                shr ebx,18h             ;移位18位，拿到24~28位
                call ph_process
                mov ebx,eax
                shr ebx,14h             ;同理
                call ph_process
                mov ebx,eax
                shr ebx,10h             
                call ph_process
                mov ebx,eax
                shr ebx,0ch
                call ph_process
                mov ebx,eax
                shr ebx,8h
                call ph_process
                mov ebx,eax
                shr ebx,4h
                call ph_process
                mov ebx,eax
                call ph_process
            ph_ret:
                pop ebx
       ret

            ph_process:
                and bl,00001111b        ;清除高4位
                add bl,30h              ;计算ascii
                cmp bl,3ah              ;确定是否需要输出字母
                jnae ph_p               ;jb命令实在是有辱斯文
                    add bl,7
                ph_p:                   ;以此缅怀世界上最好的语言（bushi
                    mov [esi],bl
                    inc esi
            ret


        test_keyboard:          ;确定键盘是否可接受数据，会循环到可接受数据时返回
        push ax
            test_keyboard_loop:
            in al,64h
            and al,10b
            cmp al,0
            jne test_keyboard_loop
                pop ax
        ret
        
        ;========================================================
        
        delay:                  ;延迟,ecx传入(单位50ms)
            pushad
            delay_loop:
                cmp ecx,0
        je delay_fin
                mov al,00110000b    ;方式0
                out 43h,al
                nop
                mov ax,59255d        ;50ms(
                out 40h,al
                mov al,ah
                nop
                out 40h,al
                delay_ms:
                    mov al,0e2h
                    out 43h,al
                    nop
                    in al,40h
                    test al,10000000b       ;测试OUT引脚
                jz delay_ms
                    dec ecx
            jmp delay_loop
            
        delay_fin:
        popad
        ret                     
        
        refresh_freq:
        pushad
        mov al,[Support_TSC]
        cmp al,0
        je unsupport_func
            rdtsc
            push edx
            push eax
            mov ecx,20d
            call delay
            xor eax,eax
            cpuid
            rdtsc
            mov ebx,1000000d
            div ebx    ;除以1000000得MHZ
            mov ecx,eax;暂存
            pop eax
            pop edx
            mov ebx,1000000d
            div ebx
            sub ecx,eax;得到最终值

            mov [CPU_Freq],cx
            mov ax,cx   ;我不认为CPU会超过65GHz
            mov esi,Freq
            call hex2dec
            mov eax,[print_X]
            push eax
            mov eax,[print_Y]
            push eax
            mov eax,[Freq_X]
            mov [print_X],eax
            mov eax,[Freq_Y]
            mov [print_Y],eax
            prints 0,0FFh,Freq
            prints 0,0FFh,MHz
            
        mov al,[Support_MSR]
        cmp al,0
        je unsupport_func
            xor edx,edx
            xor eax,eax
            xor bh,bh
            xor dx,dx
            mov ax,[CPU_Freq]
            mov bl,[Multi_Freq]
            div bx
            mov [BUS_Freq],ax
            mov esi,BCLK
            call hex2dec
            mov eax,[BCLK_X]
            mov [print_X],eax
            mov eax,[BCLK_Y]
            mov [print_Y],eax
            prints 0,0FFh,BCLK
            prints 0,0FFh,MHz
            
            
        unsupport_func:
            pop eax
            mov [print_Y],eax
            pop eax
            mov [print_X],eax
        popad
        ret