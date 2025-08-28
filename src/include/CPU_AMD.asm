;AMD CPU的专门区域
        AMD_CPU:
        copystr Vendor_name,AMD_Corp
        Calc_AMD_Dis_Model:   ;计算AMD_Display_Family
            mov eax,1
            cpuid
            mov ebx,eax
            ror ebx,20          ;获取Ext.Family
            ror eax,8           ;获取Family
            and al,1111b        ;只要低4位
            push ax
            cmp al,0fh          ;若Family低于F
            jb AMD_Dis_Fam      ;则不用计算
                ;若要计算
                add al,bl       ;Family = Base.Family[3:0]+Ext.Fam[7:0]
            AMD_Dis_Fam:
            call hex2ascii
            mov [CPU_Dis_Family],ax
            
            mov eax,1
            cpuid
            mov ebx,eax
            ror ebx,16          ;获取Ext.Model
            ror eax,4           ;获取Model
            and al,1111b        
            and bl,1111b        ;只要低4位
            
            pop cx
            cmp ah,0fh          ;若Family低于F
            jb AMD_Dis_Mod      ;则不用计算
                ;若要计算
                shl bl,4
                add al,bl       ;Model = Base.Model[3:0]+Ext.Model[3:0]<<4
            AMD_Dis_Mod:
            call hex2ascii
            mov [CPU_Dis_Model],ax
            
            
                mov ax,[CPU_Dis_Family];将Family移入ax准备进行对比
                mov esi,AMD_Family_Table
            exam_AMD_model:    ;鉴定model
                    add esi,2          ;esi自增以指向model表地址指针
                    mov esi,[esi]    ;将表地址指针存入esi
                    mov ax,[CPU_Dis_Model]
                    exam_AMD_model_s: ;循环确定最终code name
                        mov bx,[esi]
                        cmp bx,6h       ;确定表是否已完结
                        je AMD_Unknown_code_name   ;是则表明未知CPU CODE_NAME
                        cmp bx,ax       ;比较code name是否正确
                            je exam_AMD_fin   ;是则跳转
                            ;否则
                            exam_AMD_model_next:
                                inc esi
                                mov bl,[esi]
                                cmp bl,0        ;确定该字符串是否结束
                                jne exam_AMD_model_next   ;是则比较下一个
                                EAMN:
                                    inc esi
                                    mov bl,[esi]
                                    cmp bl,0        ;确定该字符串是否结束
                                jne EAMN
                                inc esi
                            jmp exam_AMD_model_s
                    exam_AMD_fin:
                        add esi,2
                        mov edi,CPU_CODE_NAME
                        EAF_Copy:
                            mov al,[esi]
                            stosb
                            inc esi
                        cmp al,0
                        jne EAF_Copy
                        mov edi,CPU_TECH
                        EAF_TECH:
                            mov al,[esi]
                            stosb
                            inc esi
                        cmp al,0
                        jne EAF_TECH
                    jmp exam_AMD_model_s
                    AMD_Unknown_code_name:
                    
                AMD_Exam_FUNC:
                    
                
                
                                        
                ;获取倍频,务必放在最后
                mov [Reading_MSR],byte 1            ;修改标志，以告知UD处理程序防止因不支持MSR C0010064h寄存器导致的报错
                mov ecx,0C0010071h
                rdmsr
                
                    %if serial_debug = 1
                        SDB_REG
                    %endif
                mov cl,ah                           ;(CPUFid)
                add al,16
                shr cl,6                            ;(CPUDid)
                inc cl                              ;*2
                xor ah,ah
                mov bx,2
                shl bl,cl                           ;当前倍频 = (CpuFid + 16) / (2^(CpuDid + 1)
                div bl
                mov [Reading_MSR],byte 0
                mov [Multi_Freq],al
                mov esi,Multiplier
                call hex2dec
        jmp Corp_Process_fin