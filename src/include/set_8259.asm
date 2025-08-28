section .text
    set_8259:
            call LIDTGATE       ;加载中断门
            mov al,00010001b    ;ICW1,边沿触发，级联，存在ICW4
            out 20h,al          ;送入主8259A的控制字寄存器
            nop
            out 0a0h,al         ;送入从8259A的控制字寄存器
            mov al,20h          ;主8259A的ICW2，主8259A初始中断向量号为20h（低三位为0，同时指IRQ0）
            out 21h,al          ;送入主8259A的数据端口
            mov al,28h          ;从8259A的ICW2，从8259A初始中断向量号为28h（低三位为0，同时指IRQ8）
            out 0a1h,al         ;送入从8259A的数据端口
            mov al,00000100b    ;主8259A的ICW3，表明从8259A在它的IRQ2
            out 21h,al          ;送入主8259A的数据端口
            mov al,2h           ;从8259A的ICW3，表明是IRQ2
            out 0a1h,al         ;送入从8259A的数据端口
            mov al,00000001b    ;ICW4,x86,手动结束中断，（无效位），非缓冲模式，全嵌套
            out 21h,al          ;送入主8259A的数据端口
            nop
            out 0a1h,al         ;从8259A的数据端口
            mov al,0            ;OCW1,不屏蔽任何管脚
            out 21h,al          ;主8259A的数据端口
            nop
            out 0a1h,al         ;从数据
 
            lidt [idtr]         ;加载IDT表
            xor ebx,ebx         ;ebx清零
            
            
            
            