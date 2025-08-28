;英特尔CPU的专门区域
        Intel_CPU:              ;当检测到CPU是英特尔的时
        copystr Vendor_name,Intel_Corp
        Calc_Intel_Dis_Model:   ;计算Intel_Display_Model
            mov eax,1
            cpuid
            ror eax,8           ;获取Family
            and al,1111b        ;只要低4位
            cmp al,6d           ;若Family为6或F
            je Intel_Dis_model
            cmp al,0fh
            jne Intel_Dis_model_pass
            Intel_Dis_model:
                mov ax,[CPU_Dis_Model]
                mov al,[CPU_EXT_Model]
                mov [CPU_Dis_Model],ax
            ror eax,8           ;获取Family
            and al,1111b        ;只要低4位
            cmp al,0fh          ;若Family为F
            jne Intel_Dis_model_pass
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
            Intel_Dis_model_pass:
            
                ;比较确定代码名称，如Haswell，Skylake
                mov ax,[CPU_Dis_Family];将Family移入ax准备进行对比
                mov esi,Intel_Family_Table
                exam_Intel_code_name:
                    mov bx,[esi]     ;将表中的值移入bx
                    cmp ax,bx        ;确定是否和当前表值一致
                    je exam_Intel_model ;是则到表中鉴定
                    cmp bx,6h
                    je Intel_Unknown_code_name
                    add esi,6        ;否则加6指向下一个表项
                jmp exam_Intel_code_name
                
                exam_Intel_model:    ;鉴定model
                    add esi,2          ;esi自增以指向model表地址指针
                    mov esi,[esi]    ;将表地址指针存入esi
                    mov ax,[CPU_Dis_Model]
                    exam_Intel_model_s: ;循环确定最终code name
                        mov bx,[esi]
                        cmp bx,6h       ;确定表是否已完结
                        je Intel_Unknown_code_name   ;是则表明未知CPU CODE_NAME
                        cmp bx,ax       ;比较code name是否正确
                            je exam_Intel_fin   ;是则跳转
                            ;否则
                            exam_Intel_model_next:
                                inc esi
                                mov bl,[esi]
                                cmp bl,0        ;确定该字符串是否结束
                                jne exam_Intel_model_next   ;是则比较下一个
                                EIMN:
                                    inc esi
                                    mov bl,[esi]
                                    cmp bl,0        ;确定该字符串是否结束
                                jne EIMN
                                inc esi
                            jmp exam_Intel_model_s
                    exam_Intel_fin:
                        add esi,2
                        mov edi,CPU_CODE_NAME
                        EIF_Copy:
                            mov al,[esi]
                            stosb
                            inc esi
                        cmp al,0
                        jne EIF_Copy
                        mov edi,CPU_TECH
                        EIF_TECH:
                            mov al,[esi]
                            stosb
                            inc esi
                        cmp al,0
                        jne EIF_TECH
                    jmp exam_Intel_model_s
                    Intel_Unknown_code_name:
                    
                    
                    
                exam_Intel_function:
                    mov eax,1h
                    cpuid
                    mov eax,1b
                    mov edi,CPU_FUNCTION
                    mov esi,Intel_function_ECX
                    EIFUN_TEST_ECX:
                        mov bl,028h
                        test ecx,eax
                        jnz EITC_SUPPORT
                            mov bl,0f9h
                        EITC_SUPPORT:
                        mov [edi],bl
                        inc edi
                        push eax
                        EICO:
                            mov al,[esi]
                            stosb
                            inc esi
                            cmp al,0
                        jne EICO
                        pop eax
                        rol eax,1
                     JNC EIFUN_TEST_ECX
                     mov eax,1b
                     EIFUN_EDX:
                        mov bl,028h
                        test edx,eax
                        jnz EITD_SUPPORT
                            mov bl,0f9h
                        EITD_SUPPORT:
                        mov [edi],bl
                        inc edi
                        push eax
                        EIDO:
                            mov al,[esi]
                            stosb
                            inc esi
                            cmp al,0
                        jne EIDO
                        pop eax
                        rol eax,1
                     JNC EIFUN_EDX
                     test edx,10000b                ;再次确定是否支持RDTSC
                     jnz Support_tsc_code
                        mov [Support_TSC],byte 0         ;不支持TSC
                     Support_tsc_code:
                     
                ;获取倍频,务必放在最后
                mov [Reading_MSR],byte 1            ;修改标志，以告知UD处理程序防止因不支持MSR198h寄存器导致的报错
                mov ecx,198h
                rdmsr
                mov [Reading_MSR],byte 0
                mov [Multi_Freq],ah
                
                    %if serial_debug = 1
                        SDB_REG
                    %endif
                mov al,ah
                mov ah,0
                mov esi,Multiplier
                call hex2dec
        jmp Corp_Process_fin
            