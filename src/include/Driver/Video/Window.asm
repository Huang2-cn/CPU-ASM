;根据链表确定窗口顺序，越靠近链表末尾越靠前
;输出时，遍历链表，从后到前渲染
;窗口创建时，遍历链表内存区域，寻找closed=1的表项，若存在则覆盖，不存在则在最后创建新表项，遍历表，将最后一个表项指向其
;窗口关闭时，closed=1，上一个表项指向下一个表项
;窗口移至最前时，上一个表项指向下一个表项，最后一个表项指向其，其下一个表项为0
create_win:         ;创建一个窗口,esi指向窗口属性
    pushad
        mov edi,video_buffer
        check_win_chain:     
            cmp [edi],word 0ABCDh               ;检查是否是有效表项
                jne create_chain                ;不是则在当前位置创建表
            cmp [edi+win_chain.closed],byte 1   ;检查是否是已关闭的窗口
                je create_chain                 ;是则在当前位置创建表
            add edi,win_chain.endian-win_chain.valid    ;否则寻找下一表项  
                jmp check_win_chain
        create_chain:
            mov [edi],word 0ABCDh
            mov [edi+win_chain.closed], byte 0
            mov [edi+win_chain.visible], byte 1
            mov ecx,[esi+win_attr.x] 
            mov [edi+win_chain.x] ,ecx
            mov ecx,[esi+win_attr.y]
            mov [edi+win_chain.y] ,ecx
            mov [win_chain.attr] ,edx
            
    popad
ret