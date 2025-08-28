    dis_window_basic_info:
        pushad
            draw_window 0ah,0ah,80,1004,CPU_INFO
            prints 0h,0FFh,CPUVendor_Info
            mov [print_X],Dword 0b5h
            prints 0h,0FFh,CPU_Specification
            call br
            prints 0,0FFh,CPU_Family_Info
            call br
            prints 0,0FFh,CPU_CODE_NAME_Info
            prints 0,0FFh,CPU_TECH_Info
        popad
    ret
    
    dis_window_function_info:
        pushad
            draw_window 0ah,106,120,1004,Function_INFO
            
            mov ecx,64
            mov esi,CPU_FUNCTION
            Print_Function:
                printc 0FFh,esi
                inc esi
            loop Print_Function
        popad
    ret
    
    dis_window_clock_info:
        pushad
            draw_window 0ah,242,100,256,Clock_INFO
            
            prints 0,0FFh,CPU_Freq_Info
            mov eax,[print_X]
            mov [Freq_X],eax
            mov eax,[print_Y]
            mov [Freq_Y],eax
            call br
            prints 0,0FFh,Multiplier_Info
            call br
            prints 0,0FFh,BCLK_Info
            mov eax,[print_X]
            mov [BCLK_X],eax
            mov eax,[print_Y]
            mov [BCLK_Y],eax
        popad
    ret
    
    
    hid_window_basic_info:
        pushad
            fill_rectangle 0f0h,0,0ah,240,[video_screen_width]
        popad
    ret