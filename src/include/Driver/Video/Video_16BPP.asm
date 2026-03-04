load_driver_16BPP:
pushad
    cli
    push ds
    push es
    push ss
    push gs
    push fs
    push si
    jmp gdt_code_16-gdt_start:set_video_16bpp
    set_video_16bpp:
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
        jmp 100h:sv_16bpp-main_32
        sv_16bpp:
            xor eax,eax
            mov es,ax           
            mov ds,ax
            mov fs,ax
            mov gs,ax
            mov ss,ax
            mov ax,90h         ;存储VESA信息的段基址
            mov es,ax
            lidt [real_mode_idtr]   ;前面保存了实模式的IDT
                                    
            mov ax,4f02h ;设置显示模式
            mov bx,4116h
            int 10h
            mov ax,4f01h
            mov cx,4116h
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
            shl eax,1
            add ebx,eax
            mov [video_endian_addr],ebx
            
            mov ax,4f03h ;检测当前显示模式
            int 10h
            

            lgdt [gdt_reg]
            mov eax,cr0         ;返回32位保护模式
            or eax,1
            mov cr0,eax
            jmp gdt_code-gdt_start:sv16bpp_return32
        [bits 32]
        sv16bpp_return32:
            lidt [idtr]
        pop si
        pop fs
        pop gs
        pop ss
        pop ds
        pop es
    sti
    cmp bx,4116h            ;确定是否成功设置
        jne set_video_16bpp_failure
    mov ebx,[video_phy_addr]
    cmp ebx,0
        je set_video_16bpp_failure
        
    mov [br],dword br_16BPP
    mov [video_addr],dword video_addr_16BPP
    mov [draw_pixel],dword draw_pixel_16BPP
    mov [rectangle],dword rectangle_16BPP
    mov [clean_screen],dword clean_screen_16BPP
    mov [print],dword print_16BPP      
        %if serial_debug = 1
                serial_print SDB_16BPP
        %endif
    popad
ret    
    set_video_16bpp_failure:
    popad
    mov eax,1           ;返回失败
ret

    br_16BPP:                     ;换行
        mov edx,[print_Y]
        mov ecx,[line_start]
        add edx,10h
        mov [print_X],ecx
        mov [print_Y],edx
    ret
    
    
    video_addr_16BPP:       ;计算显存地址子程序，ecx=x轴，edx=y轴，完成后edx=地址
          push eax
          push ebx
          mov eax,edx
          xor ebx,ebx
          mov bx,[screen_width]
          mul ebx
          mov edx,eax  
          add edx,ecx       ;加上x轴
          mov eax,[video_base_addr]
          shl edx,1         ;乘以2
          add edx,eax       ;显存基地址
          pop ebx
          pop eax
    ret
    
    
    
    draw_pixel_16BPP:                 ;画像素,将[pixel_color]内存处对应的颜色画在(ecx,edx)，已完成16位色适配
        push edx
        push eax
        xor eax,eax
        mov al,[pixel_color]
        call dword [video_addr]
              shl eax,1             ;ax乘二获得颜色偏移
              add eax,palette_data_16bpp
              mov ax,[eax]
              mov [edx],ax
        pop eax
        pop edx
    ret
    
    
    
        rectangle_16BPP:              ;画矩形！al颜色，ecx起始x轴，edx起始y轴，ebx长度，ebp宽度,已完成16位色适配
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
                shl ecx,1               ;偏移须乘二
                and eax,11111111b       ;只保留AL
                shl eax,1               ;eax乘二获得颜色偏移
                add eax,palette_data_16bpp
                mov ax,[eax]    
        rectangle_line_16bpp:
            mov edx,ebp          ;将宽度放入edx
            dec ebx              ;高度减一
            jz rectangle_16bpp_ret     ;归零则返回
            rectangle_line_loop_16bpp:
                stosw            ;写入显存
                dec edx          ;写入了一个像素
                jnz rectangle_line_loop_16bpp
                add edi,ecx
            jmp rectangle_line_16bpp
        rectangle_16bpp_ret:
        popad
     ret    
     
     
        
    clean_screen_16BPP:           ;清屏，al为清屏颜色,已完成32位色适配
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
            mov edi,[video_base_addr]
                and eax,11111111b       ;只保留AL
                shl eax,1               ;eax乘二获得颜色偏移
                add eax,palette_data_16bpp
                mov ax,[eax]    
                push ax
                shl eax,16
                pop ax
            cls_16BPP_loop:
                stosd
                cmp edi,[video_endian_addr]
            jbe cls_16BPP_loop
            cls_16BPP_ret:
        pop ecx
        pop edi
        pop eax
    ret
    
    
    print_16BPP:              ;字符带背景显示，al为颜色,ah为背景颜色,bl为ascii，ecx为左上角x轴，edx为左上角y轴,bl为ASCII，结束后除ecx为右上角Y轴全都不变,已完成16位色适配
        pushad            ;全部入栈
            mov edx,[print_Y]
            cmp bl,0ah
            je next_line_16BPP
            cmp bl,0dh
            je enter_key_16BPP
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
            cl_16bpp:  ;如果是16位色模式
                and eax,11111111b       ;只保留AL
                shl eax,1               ;eax乘二获得颜色偏移
                add eax,palette_data_16bpp
                mov ax,[eax]    
                shl ebp,1     ;显存偏移乘2
            char_loop_16bpp:
                cmp bl,0      ;是0则该行无内容,前往下一行
                jne char_print_16bpp ;否则前往进行输出
                    pop edi   ;当前高度
                    add edi,ebp
                    push edi
                    cmp bh,10h  ;16则证明已完成当前字
                    je char_16BPP_ret
                    inc bh      ;否则增加行指示
                    mov bl,[esi];下一行字模
                    inc esi      
                char_print_16bpp:
                shl bl,1
                jnc char_pass_16bpp
                    mov [edi],ax
                char_pass_16bpp:
                    inc edi
                    inc edi
                    jmp char_loop_16bpp
            char_16BPP_ret:
            pop edx
            add ecx,08h
            mov [print_X],ecx
            popad
       ret    
            next_line_16BPP:
                    add edx,10h
                    mov [print_Y],edx
                jmp char_control_ret_16BPP
                enter_key_16BPP:
                    mov ecx,[line_start]
                    mov [print_X],ecx
                char_control_ret_16BPP:
                    popad
                ret