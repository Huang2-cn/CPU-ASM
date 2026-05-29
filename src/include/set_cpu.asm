
            mov eax,0
            cpuid
            mov [CPUVendor],ebx
            mov [CPUVendor+4],edx
            mov [CPUVendor+8],ecx
            
            mov eax,80000002h
            cpuid
            mov [Specification_name],eax
            cmp eax,0
            je CPU_NOT_SUPPORT_EXTENDED_CPUID
            mov [Specification_name+4],ebx
            mov [Specification_name+8],ecx
            mov [Specification_name+12],edx
            mov eax,80000003h
            cpuid
            mov [Specification_name+16],eax
            mov [Specification_name+20],ebx
            mov [Specification_name+24],ecx
            mov [Specification_name+28],edx
            mov eax,80000004h
            cpuid
            mov [Specification_name+32],eax
            mov [Specification_name+36],ebx
            mov [Specification_name+40],ecx
            mov [Specification_name+44],edx
            CPU_NOT_SUPPORT_EXTENDED_CPUID:
            
            
            


            
            
            
            mov eax,1
            cpuid
            push eax
            call hex2ascii
            mov [CPU_Stepping],ah
            mov [CPU_Model],al
            xchg ah,al
            mov al,30h
            mov [CPU_Dis_Model],ax
            pop eax
            push eax
            ror eax,8
            mov bl,al
            call hex2ascii
            mov [CPU_Family],ah
            mov al,30h
            mov [CPU_Dis_Family],ax
            pop eax
            push eax
            ror eax,16
            call hex2ascii
            mov [CPU_EXT_Model],ah
            pop eax
            push eax
            ror eax,20
            call hex2ascii
            mov [CPU_EXT_Family],ax
            
            pop eax
            push eax
            
            
            cmpstr CPUVendor,Intel,Intel_CPU
            cmpstr CPUVendor,AMD,AMD_CPU
            
            
    Corp_Process_fin:
            %if serial_debug = 1
                serial_print CPUVendor_Info
            %endif
    
    ;call dis_window_basic_info
    ;call dis_window_function_info
    ;call dis_window_clock_info

    beeping:
    %if enable_beep = 1
        sound #g3,1,0
        sound d4,1,1
        sound d4,1,2
        sound d4,1,3
        sound c4,1,2
        sound b3,1,1
        sound c4,1,0
        sound d4,1,3
        sound d4,1,2
        sound g3,1,0
    %endif
        call Win_Initialize
    dis_freq:   
        sti
        call ref_scr
        call refresh_freq
    jmp dis_freq
            