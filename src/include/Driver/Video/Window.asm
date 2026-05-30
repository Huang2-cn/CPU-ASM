;根据链表确定窗口顺序，越靠近链表末尾越靠前
;输出时，遍历链表，从后到前渲染脏窗口
;窗口创建时，遍历链表内存区域，寻找closed=1的表项，若存在则覆盖，不存在则在最后创建新表项，遍历表，将最后一个表项指向其
;窗口关闭时，closed=1，上一个表项指向下一个表项
;窗口移至最前时，上一个表项指向下一个表项，最后一个表项指向其，其下一个表项为0
ref_scr:
    pushad
        mov esi,win_chain_buffer
        drw_win:                    ;绘制窗口
            cmp [esi+win_chain.type], word 0FD00h        ;判断是否是根表项
            jne drw_win_pass_root
                cmp [esi+win_chain.dirty], byte 1       ;判断桌面是否需要重绘 
                jne drw_win_pass_root
                    mov al,[background]
                    call [clean_screen]
                    mov [esi+win_chain.dirty], byte 0
                    %if serial_debug = 1
                        serial_print SDB_REF_DESK
                    %endif    
            drw_win_pass_root:
            cmp [esi+win_chain.type], word 0FD01h        ;判断是否是有效表项
            jne next_win                                ;否则下一表项
            cmp [esi+win_chain.closed], byte 1           ;判断是否已关闭
            je ref_scr_err
            cmp [esi+win_chain.dirty], byte 1           ;判断窗口是否需要重绘 
            jne next_win                                
            %if serial_debug = 1
                push eax
                push esi
                    mov eax,esi
                    mov esi,SDB_WIN_POS
                    call dword_hex
                    serial_print SDB_REF_WIN
                pop esi
                pop eax
            %endif    
            mov edi,[esi+win_chain.attr]
            draw_window [edi+win_attr.x],[edi+win_attr.y],[edi+win_attr.h],[edi+win_attr.w],[edi+win_attr.title]
                                                        ;绘制框架
                     
            mov ebp,[edi+win_attr.widget]               ;控件绘制(没寄存器用了捏)
            push esi                                   
            draw_widget:
                cmp [ebp],byte 1
                jne draw_widget_not_str
                    ;字符串
                    xor eax,eax
                    mov ax,[ebp+wid_str.x]
                    add ax,[edi+win_attr.x]
                    mov [print_X],eax
                    mov [line_start],eax
                    mov ax,[ebp+wid_str.y]
                    add ax,[edi+win_attr.y]
                    add ax,10h
                    mov [print_Y],eax
                    mov eax,[ebp+wid_str.index]
                    mov ah,[ebp+wid_str.back]
                    mov esi,[ebp+wid_str.index]
                    mov al,[esi]
                    inc esi
                    call printstr_back
                    mov ebp,[ebp+wid_str.next_wid]
            cmp ebp,0
            jne draw_widget
            jmp draw_widget_finish
            draw_widget_not_str:
        
            
            
            draw_widget_finish:
            pop esi    
            mov [esi+win_chain.dirty], byte 0           ;干净了
            %if serial_debug = 1
                    serial_print SDB_SUC
            %endif  
        
        next_win:
            mov esi,[esi+win_chain.next_win]
            cmp esi,0
        jne drw_win
    popad
ret
ref_scr_err:            ;遇到错误
    %if serial_debug = 1
        serial_print SDB_FAIL
    %endif
jmp next_win

    
Win_Initialize:
    pushad
        mov edi,win_chain_buffer
        mov esi,root_win
        mov ecx,win_chain.endian-win_chain.type
        WI_RW:
            mov al,[esi]
            stosb                   ;把哑节点复制到缓冲区
            inc esi
        loop WI_RW 
        mov esi,win_basic_info      ;创建basic_info窗口
        call create_win
    popad
ret
create_win:         ;创建一个窗口,esi指向窗口属性
    pushad
        mov edi,win_chain_buffer
        check_win_chain:     
            cmp [edi+1],byte 0FDh               ;检查是否是有效表项
                jne create_chain                ;不是则在当前位置创建表
            cmp [edi+win_chain.closed],byte 1   ;检查是否是已关闭的窗口
                je create_chain                 ;是则在当前位置创建表
            add edi,win_chain.endian            ;否则寻找下一表项  
                jmp check_win_chain

        create_chain:
            mov [edi],word 0FD01h
            mov [edi+win_chain.closed], byte 0
            mov [edi+win_chain.visible], byte 1
            mov cx,[esi+win_attr.x] 
            mov [edi+win_chain.x], cx
            mov cx,[esi+win_attr.y]
            mov [edi+win_chain.y], cx
            mov [edi+win_chain.attr], esi
            mov [edi+win_chain.next_win], dword 0
            mov [edi+win_chain.dirty], byte 1           ;新窗口都是脏的
            mov ebx,win_chain_buffer
            cc_find_final:
                cmp [ebx+win_chain.next_win], dword 0       ;确定是否是最后一个表项
                je ccff_found                                        
                mov ebx,[ebx+win_chain.next_win]            ;不是则跳到下一个表项
            jmp cc_find_final
            ccff_found:
                mov [edi+win_chain.pre_win] ,ebx                                 ;将其的上一个窗口正确指向
                mov [ebx+win_chain.next_win], edi             ;将上一个窗口的下一个窗口指向其
    popad
ret