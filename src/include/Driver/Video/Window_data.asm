window:
root_win:
    istruc win_chain
        at win_chain.type,      dw 0FD00h   ;哑节点
        at win_chain.closed,    db 0ffh     ;不可关闭
        at win_chain.visible,   db 0        ;不可见
        at win_chain.x,         dw 0        
        at win_chain.y,         dw 0
        at win_chain.attr,      dd 0        ;没有属性
        at win_chain.pre_win,   dd 0        ;标志前面没有窗口了
        at win_chain.next_win,  dd 0
        at win_chain.dirty,     db 1        ;默认需要重绘
    iend
    
%include "\Windows\basic_info.asm"

