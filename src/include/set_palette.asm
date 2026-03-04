section .text
colorful_palette:       ;想打世界计划了🤤🤤🤤
                        ;奏宝🤤🤤🤤，我的奏宝🤤🤤🤤
    mov esi,palette_data;此标号在palette_data.asm
    xor ax,ax           ;ah=当前设置的调色板，al作为输出IO端口的缓存
    mov dx,3c8h     ;dac寄存器
    out dx,al       ;从零号开始
        
    set_palette_loop:

        mov dx,3c9h     ;dac数据寄存器
        mov al,[esi]    ;设置红色值
        out dx,al
        
        inc esi
        mov al,[esi]    ;设置绿色值
        out dx,al       ;表达了绿色值的思乡之情
        
        inc esi
        mov al,[esi]    ;设置蓝色值
        out dx,al
        cmp ah,255d
        jae finish_set_palette   ;如果ah溢出（也就是ah自增之前=255），则正好设置完了
        inc esi
        inc ah          ;下一个调色板
 
    jmp set_palette_loop
finish_set_palette:
ret


