section .text



vfun_err:
    jmp $
    
    
%include "Driver\Video\Video_800_256.asm"
%include "Driver\Video\Video_1024_256.asm"
%include "Driver\Video\Video_16BPP.asm"
%include "set_palette.asm"
%include "Driver\Video\Window.asm"


;===================================================== 


ref_vram:
pushad
    
popad
ret            
                                


        printstr_back:           ;字符串显示函数，仅支持ASCII，esi指向字符串，al前景色，ah背景色，ecx左上角x，edx左上角y，除ecx=最后的字符位置右上角x其他均不变
            push ebx
            xor ebx,ebx
            pstr_back_loop:
                mov bl,[esi]
                cmp bl,0
                    je pstr_ret
                call dword [print]
                inc esi
            jmp pstr_back_loop
        pstr_ret:
        pop ebx
        ret