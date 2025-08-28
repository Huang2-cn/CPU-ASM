section .text
    video_addr:             ;计算显存地址子程序，ecx=x轴，edx=y轴，完成后edx=地址
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
    draw_pixel:                 ;画像素,将[pixel_color]内存处对应的颜色画在(ecx,edx)
        push edx
        push ax
        mov al,[pixel_color]
        call video_addr
        mov [edx],al
        pop ax
        pop edx
    ret
        

;===================================================== 

    rectangle:              ;画矩形！al颜色，ecx起始x轴，edx起始y轴，ebx长度，ebp宽度
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
        call video_addr
        mov edi,edx
        xor ecx,ecx
        xor edx,edx
        mov cx,[screen_width]
        sub ecx,ebp              ;每次换行需增加的偏移
        inc ebx                  ;循环会减回来
        
        rectangle_line:
            mov edx,ebp          ;将宽度放入edx
            dec ebx              ;高度减一
            jz rectangle_ret     ;归零则返回
            rectangle_line_loop:
                stosb            ;写入显存
                dec edx          ;写入了一个像素
                jnz rectangle_line_loop
                add edi,ecx
            jmp rectangle_line
        rectangle_ret:
        popad
     ret    
                                
                                
                                
        clean_screen:           ;清屏，al为清屏颜色
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
            cls_loop:
                stosd
                cmp edi,[video_endian_addr]
            jbe cls_loop
            pop ecx
            pop edi
            pop eax
        ret
        br:                     ;换行
            mov edx,[print_Y]
            mov ecx,[line_start]
            add edx,10h
            mov [print_X],ecx
            mov [print_Y],edx
        ret
        
        
        print_cn:               ;中文显示，al为颜色，ecx为左上角x轴，edx为左上角y轴,esi指向数据，结束后除ecx为右上角Y轴全都不变
              pushad            ;全部入栈
              dec edx           ;循环里会加回来
              mov ah,0
              xor ebx,ebx
              call video_addr
              push edx
              xor ebp,ebp
              mov bp,[screen_width]
              pcn_loop:
                cmp bx,0
                jne pcn_print
                    pop edi
                    add edi,ebp
                    push edi
                    cmp ah,16d
                    je pcn_ret
                    inc ah
                    mov bx,[esi]
                    add esi,2      
                pcn_print:
                shl bx,1
                jnc pcn_pass
                    mov [edi],al
                pcn_pass:
                    inc edi
                    jmp pcn_loop
            pcn_ret:
            pop edx
            popad
            add ecx,11h
       ret
       
       print_cn_32:            ;大中文显示函数(32*32)，al为颜色，ecx为左上角x轴，edx为左上角y轴,esi指向字模，结束后除ecx为右上角Y轴全都不变
              pushad            ;全部入栈
              dec edx           ;循环里会加回来
              mov ah,0
              xor ebx,ebx
              call video_addr
              push edx
              xor ebp,ebp
              mov bp,[screen_width]
              pcn_32_loop:
                cmp ebx,0
                jne pcn_32_print
                    pop edi
                    add edi,ebp
                    push edi
                    cmp ah,32d
                    je pcn_32_ret
                    inc ah
                    mov ebx,[esi]
                    add esi,4      
                pcn_32_print:
                shl ebx,1
                jnc pcn_32_pass
                    mov [edi],al
                pcn_32_pass:
                    inc edi
                    jmp pcn_32_loop
            pcn_32_ret:
            pop edx
            popad
            add ecx,34h
       ret
       

       print:                 ;字符显示函数，al为颜色，ecx为左上角x轴，edx为左上角y轴,bl为ASCII，结束后除ecx为右上角Y轴全都不变
              pushad            ;全部入栈
              mov ecx,[print_X]
              mov edx,[print_Y]
              and ebx,11111111b ;除bl外全部爬！
              sub ebx,20h
              shl ebx,4         ;乘以16，得到字模偏移
              lea esi,chars
              add esi,ebx
              dec edx           ;循环里会加回来
              mov ah,0
              xor ebx,ebx
              call video_addr
              push edx
              xor ebp,ebp
              mov bp,[screen_width]
              char_loop:
                cmp bl,0
                jne char_print
                    pop edi
                    add edi,ebp
                    push edi
                    cmp ah,10h
                    je char_ret
                    inc ah
                    mov bl,[esi]
                    inc esi      
                char_print:
                shl bl,1
                jnc char_pass
                    mov [edi],al
                char_pass:
                    inc edi
                    jmp char_loop
            char_ret:
            pop edx
            add ecx,08h
            mov [print_X],ecx
            popad
       ret
            
              
        printstr:           ;字符串显示函数，仅支持ASCII，esi指向字符串，al前景色，ecx左上角x，edx左上角y，除ecx=最后的字符位置右上角x其他均不变
            push ebx
            xor ebx,ebx
            pstr_loop:
                mov bl,[esi]
                cmp bl,0
                je pstr_ret
                call print
                inc esi
            jmp pstr_loop
            pstr_ret:
            pop ebx
       ret
       next_line:
            add edx,10h
            mov [print_Y],edx
       jmp char_control_ret
       enter_key:
            mov ecx,[line_start]
            mov [print_X],ecx
       char_control_ret:
            popad
       ret
       print_back:              ;字符带背景显示，al为颜色,ah为背景颜色,bl为ascii，ecx为左上角x轴，edx为左上角y轴,bl为ASCII，结束后除ecx为右上角Y轴全都不变
              pushad            ;全部入栈
              mov edx,[print_Y]
              cmp bl,0ah
              je next_line
              cmp bl,0dh
              je enter_key
              mov ecx,[print_X]
              sub bl,20h
              and ebx,11111111b ;除bl外全部爬！
              shl ebx,4         ;乘以16，得到字模偏移
              lea esi,chars
              add esi,ebx
              dec edx           ;循环里会加回来
              xor ebx,ebx
              call video_addr
              push edx
              xor ebp,ebp
              mov bp,[screen_width]
              clean_back:       ;清除背景
                mov edi,edx
                push bx
                xor bx,bx
                clb_next:
                    inc bh
                    cmp bh,10h
                    ja clb_finish
                    xor bl,bl
                    add edi,ebp
                clean_back_loop:
                    mov [edi],ah
                    inc edi
                    inc bl
                    cmp bl,9h
                    jne clean_back_loop
                    sub edi,9h
                jmp clb_next
                clb_finish:
                    pop bx
                    mov ah,0
                jmp char_loop        
            
            printstr_back:           ;字符串显示函数，仅支持ASCII，esi指向字符串，al前景色，ah背景色，ecx左上角x，edx左上角y，除ecx=最后的字符位置右上角x其他均不变
                cmp byte [allow_output],0
                jne not_allow_output   ;检查是否允许输出
            pstr_nocheck:
                push ebx
                xor ebx,ebx
                pstr_back_loop:
                    mov bl,[esi]
                    cmp bl,0
                        je pstr_ret
                    call print_back
                    inc esi
            jmp pstr_back_loop
                not_allow_output:           ;不允许输出
            ret