;根据链表确定窗口顺序，越靠近链表末尾越靠前
;输出时，遍历链表，从后到前渲染
;窗口创建时，遍历链表内存区域，寻找closed=1的表项，若存在则覆盖，不存在则在最后创建新表项，遍历表，将最后一个表项指向其
;窗口关闭时，closed=1，上一个表项指向下一个表项
;窗口移至最前时，上一个表项指向下一个表项，最后一个表项指向其，其下一个表项为0
win_Initialize:
    pushad
        mov edi,win_chain_buffer
        mov esi,root_win
        mov ecx,win_chain.endian
        WI_RW:
            mov al,[esi]
            stosb
        loop WI_RW 
        mov esi,win_basic_info
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
            mov [edi+win_chain.x] ,cx
            mov cx,[esi+win_attr.y]
            mov [edi+win_chain.y] ,cx
            mov [edi+win_chain.attr] ,esi
            mov [edi+win_chain.next_win] ,dword 0
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