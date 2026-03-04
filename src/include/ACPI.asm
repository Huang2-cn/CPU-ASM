                ;查找RSDP
            mov edi,0xDFFE0    ;首次自增后为起始地址0E0000h
            mov ecx,2000h      ;搜索范围为0E0000h到0FFFFFh,共20000h字节，由于该标志16字节对齐，每次自增10
            cld                ;方向为正向
            search_rsdp:
                add edi,10h    ;该标志始终16字节对齐
                cmp dword [edi],'RSD '  ;比较当前指向内存是否是RSDP标志
                je found_rsdp
            loop search_rsdp
                
             %if serial_debug = 1
                pushad
                    serial_print SDB_NORSDP
                popad
             %endif
            jmp NO_ACPI
            found_rsdp:
                cmp dword [edi+4],'PTR ' ;确认是否是真的RSDP标志
            jne search_rsdp              ;不是则重新搜索
            mov [ACPI_RSDP_addr],edi     ;保存RDSP地址
             %if serial_debug = 1
                    pushad
                    
                    serial_print SDB_AADDR
                    mov eax,[ACPI_RSDP_addr]
                    mov esi,SDB_TEMP
                    call dword_hex
                    serial_print SDB_TEMP
                    
                    popad
             %endif
            NO_ACPI:
           
                