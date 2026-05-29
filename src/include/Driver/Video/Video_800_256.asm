load_driver_800_256:
pushad
    cli
    push ds
    push es
    push ss
    push gs
    push fs
    push si
    jmp gdt_code_16-gdt_start:set_video_800_256
    set_video_800_256:
    [bits 16]
        mov ax,gdt_data_16-gdt_start
        mov ds,ax
        mov es,ax
        mov fs,ax
        mov gs,ax
        mov ss,ax
        mov eax,cr0         ;临时回16位实模式
        and al,11111110b
        mov cr0,eax
        jmp 100h:sv_800_256-main_32
        sv_800_256:
            xor eax,eax     
            mov ds,ax
            mov fs,ax
            mov gs,ax
            mov ss,ax        
            mov ax,90h         ;存储VESA信息的段基址
            mov es,ax
            lidt [real_mode_idtr]   ;前面保存了实模式的IDT
             
            mov ax,4f02h ;设置显示模式
            mov bx,103h
            int 10h
            mov ax,4f01h
            mov cx,103h
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
            mov ax,4f0ah
            mov bx,0
            xor edi,edi
            int 10h         ;获取VESA保护模式代码入口
            xor eax,eax
            mov ax,es
            shl eax,4   ;段基址左移4位
            add eax,edi
            mov [PMI_ADDR],eax
            mov [PMI_LEN],cx
            mov ax,4f03h ;检测当前显示模式
            int 10h
            ;务必保持bx不被破坏,用于检测是否调用成功

            lgdt [gdt_reg]
            mov eax,cr0         ;返回32位保护模式
            or eax,1
            mov cr0,eax
            jmp gdt_code-gdt_start:sv800_256_return32
        [bits 32]
        sv800_256_return32:
            lidt [idtr]
        pop si
        pop fs
        pop gs
        pop ss
        pop ds
        pop es
    sti
    cmp bx,103h            ;确定是否成功设置
        jne set_video_800_256_failure
    mov ebx,[video_phy_addr]
    cmp ebx,0
        je set_video_800_256_failure
    call colorful_palette
    
    
        
    
    mov [br],dword br_800
    mov [video_addr],dword video_addr_800_256
    mov [draw_pixel],dword draw_pixel_800_256
    mov [rectangle],dword rectangle_800_256
    mov [clean_screen],dword clean_screen_800_256
    mov [print],dword print_800_256                
        %if serial_debug = 1
                mov esi,SDB_TEMP
                call dword_hex 
                serial_print SDB_800_256C
                serial_print SDB_TEMP
        %endif
    popad
    mov eax,0           ;返回成功
ret
    set_video_800_256_failure:
    popad
    mov eax,1           ;返回失败
ret



    br_800:                     ;换行
        mov edx,[print_Y]
        mov ecx,[line_start]
        add edx,10h
        mov [print_X],ecx
        mov [print_Y],edx
    ret




    video_addr_800_256:
          push eax
          push ebx
          mov eax,edx
          xor ebx,ebx
          mov bx,[screen_width]
          mul ebx
          mov edx,eax  
          add edx,ecx       ;加上x轴
          mov eax,[video_base_addr]
          add edx,eax  ;显存基地址
          pop ebx
          pop eax
    ret
    
    
    
    
    draw_pixel_800_256:                 ;画像素,将[pixel_color]内存处对应的颜色画在(ecx,edx)
        push edx
        push eax
        xor eax,eax
        mov al,[pixel_color]
        call dword [video_addr]
            mov [edx],al
        dp_800_pass:
        pop eax
        pop edx
    ret
    
    
   
        rectangle_800_256:          ;画矩形！al颜色，ecx起始x轴，edx起始y轴，ebx长度，ebp宽度,已完成16位色适配
                                ;有个关于这个的宏在define.asm里面!!!
                                ;(ECX,EDX)
        pushad                  ;    ↓
                                ;    ┏━━━━━━━━━━━━━━━┓┰
                                ;    ┃               ┃┃
                                ;    ┃               ┃EBX
                                ;    ┃               ┃┃
                                ;    ┗━━━━━━━━━━━━━━━┛┸
                                ;    ├───── EBP ─────┤
                                ;不用等宽字体的活该的说
        call dword [video_addr]
        mov edi,edx
        xor ecx,ecx
        xor edx,edx
        mov cx,[screen_width]
        sub ecx,ebp              ;每次换行需增加的偏移
        inc ebx                  ;循环会减回来
        rectangle_800_line:
            mov edx,ebp          ;将宽度放入edx
            dec ebx              ;高度减一
            jz rectangle_800_ret     ;归零则返回
            rectangle_800_line_loop:
                stosb            ;写入显存
                dec edx          ;写入了一个像素
                jnz rectangle_800_line_loop
                add edi,ecx
            jmp rectangle_800_line
        rectangle_800_ret:
        popad
     ret    
     
     
     
     
     
     clean_screen_800_256:           ;清屏，al为清屏颜色
            push eax
            push edi
            push ecx
            mov ecx,[line_start]
            mov [print_X],ecx
            mov dword [print_Y],0
            mov ah,al
            mov di,ax
            shl eax,10h
            mov ax,di
            xor ecx,ecx
            mov dx,0
            mov cx,8           ;全部填充要7个窗口
            write_vmem_800_256:
                mov bx,0
                call dword [sel_bank]       ;选择显存窗口
                mov bx,1
                call dword [sel_bank]       ;选择显存窗口
                inc dx
                mov edi,0A0000h
                fill_bank_800_256:
                    stosd
                    cmp edi,0B0000h
                jnae fill_bank_800_256
            loop write_vmem_800_256
            cls_800_256_ret:
            pop ecx
            pop edi
            pop eax
        ret
        
        
        
    print_800_256:              ;字符带背景显示,al为前景颜色,ah为背景颜色,bl为ASCII
        pushad           ;全部入栈
            mov edx,[print_Y]
            cmp bl,0ah
            je next_line_800_256
            cmp bl,0dh
            je enter_key_800_256
            mov ecx,[print_X]
                pushad              ;清除背景
                mov al,ah
                mov ebx,10h
                mov ebp,9h
                call dword [rectangle]     ;用矩形填充
                popad
            sub bl,20h
            and ebx,11111111b ;除bl外全部爬！
            shl ebx,4         ;乘以16，得到字模偏移
            lea esi,chars
            add esi,ebx
            dec edx           ;循环里会加回来
            xor ebx,ebx
            call dword [video_addr]
            push edx
            xor ebp,ebp
            mov bp,[screen_width]
            char_800_256_loop:
                cmp bl,0      ;是0则该行无内容,前往下一行
                jne char_800_256_print ;否则前往进行输出
                    pop edi   ;当前高度
                    add edi,ebp
                    push edi
                    cmp bh,10h  ;16则证明已完成当前字
                    je char_800_256_ret
                    inc bh      ;否则增加行指示
                    mov bl,[esi];下一行字模
                    inc esi      
                char_800_256_print:
                shl bl,1
                jnc char_800_256_pass
                    mov [edi],al
                char_800_256_pass:
                    inc edi
                    jmp char_800_256_loop
            char_800_256_ret:
            pop edx
            add ecx,08h
            mov [print_X],ecx
            popad
       ret
                    
                          
                next_line_800_256:
                    add edx,10h
                    mov [print_Y],edx
                jmp char_800_256_control_ret
                enter_key_800_256:
                    mov ecx,[line_start]
                    mov [print_X],ecx
                char_800_256_control_ret:
                    popad
                ret