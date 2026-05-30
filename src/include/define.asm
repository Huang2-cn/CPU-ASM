%include "Driver\Video\Video_define.asm"     ;视频内存位置定义
%include "pitch.asm"            ;蜂鸣器曲调定义

enable_beep equ 0        ;启用蜂鸣器,1=启用
serial_debug equ 1       ;串口调试,1=启用
serial_port equ 3f8h     ;串口调试端口，3F8=COM1

%if serial_debug = 1
    %warning "NOW IS A DEBUG VERSION, PLEASE DO NOT RELEASE!!!"
    %warning "NOW IS A DEBUG VERSION, PLEASE DO NOT RELEASE!!!"
    %warning "NOW IS A DEBUG VERSION, PLEASE DO NOT RELEASE!!!"
%endif

%macro serial_print 1   ;格式:serial_print 字符串地址
    mov esi,%1
    call serial_out
%endmacro

%macro SDB_REG 0
    pushad
    mov esi,SDB_EAX_VALUE
    call dword_hex
    mov eax,ebx
    mov esi,SDB_EBX_VALUE
    call dword_hex
    mov eax,ecx
    mov esi,SDB_ECX_VALUE
    call dword_hex
    mov eax,edx
    mov esi,SDB_EDX_VALUE
    call dword_hex
    serial_print SDB_EAX
    popad
%endmacro

%macro draw_window 5 ;显示窗口框架 draw_window 起始X,起始Y,长,宽,标题指针
    pushad
        xor ebx,ebx
        xor ecx,ecx
        xor edx,edx
        xor ebp,ebp
        mov al,0e0h
        mov cx,%1
        dec cx
        mov dx,%2
        dec dx
        mov bx,%3
        add bx,2
        mov bp,%4
        add bp,2
        call dword [rectangle]              ;主体外框架
        mov al,0ffh
        mov cx,%1
        mov dx,%2
        mov bx,%3
        mov bp,%4
        call dword [rectangle] 
        mov eax,%4         
        mov [window_lenth],eax
        sub eax,4
        mov [line_lenth],eax
        mov al,010h
        mov cx,%1
        add cx,4
        mov dx,%2
        add dx,4
        mov bx,12
        mov bp,12
        call dword [rectangle]      ;绘制LOGO
        mov al,0f8h
        mov cx,%1
        add cx,6
        mov dx,%2
        add dx,6
        mov bx,8
        mov bp,8
        call dword [rectangle]
        mov al,010h
        mov cx,%1
        add cx,8
        mov dx,%2
        add dx,13
        mov bx,1
        mov bp,4
        call dword [rectangle]
        mov bx,%1
        add ebx,20
        mov [print_X],ebx
        mov bx,%2
        mov [print_Y],ebx
        mov bx,%1
        add ebx,2
        mov [line_start],ebx
        printc 0FFh,%5
        mov al,07h
        mov cx,%1
        mov dx,%2
        add dx,18
        mov bx,1
        mov bp,%4
        call dword [rectangle]
    popad
%endmacro

%macro cmpstr 3      ;格式:cmpstr 字符串1,字符串2,相等跳转的标号
    pushad
    mov esi,%1
    mov edi,%2
    %%compare:
        mov ah,[esi]
        mov al,[edi]
        inc esi
        inc edi
        cmp ah,al
        jne %%not_equal
        cmp ah,0    ;判断字符串是否结束
        jne %%compare
                    ;已结束
            popad
            jmp %3  ;执行调用定义的命令    
    %%not_equal:
    popad
%endmacro

%macro copystr 2     ;格式:copystr 目标指针,源字符串指针
    pushad
    mov edi,%1
    mov esi,%2
    .copy:
        mov al,[esi]
        stosb
        inc esi
        cmp al,0
    jne .copy
    popad
%endmacro

%macro put_cn 4     ;格式:put_cn 颜色,字模,左上角X,左上角Y
    mov al,%1
    mov esi,%2
    mov ecx,%3
    mov edx,%4
    call print_cn
%endmacro
;一个字符需要09h*10h
%macro put_char 5   ;格式:put_char 颜色,背景,ASCII,左上角X,左上角Y
    mov al,%1
    mov ah,%2
    mov bl,%3
    mov ecx,%4
    mov edx,%5
    call print_back
%endmacro


%macro phex 5       ;格式:phex 32位数据,颜色,背景,左上角X,左上角Y
    mov esi,%1
    mov al,%2
    mov ah,%3
    mov ecx,%4
    mov edx,%5
    call print_hex
%endmacro

%macro prints 3       ;格式:prints 前景色,背景色,字符串地址
    mov al,%1
    mov ah,%2
    mov esi,%3
    call printstr_back
%endmacro

%macro printc 2       ;格式:printc 背景色,字符串地址(第一Byte为前景色)
    mov ah,%1
    mov esi,%2
    mov al,[esi]
    inc esi
    call printstr_back
%endmacro

%macro print_nocheck 3       ;格式:prints 前景色,背景色,字符串地址(忽略是否允许输出)
    mov al,%1
    mov ah,%2
    mov esi,%3
    call pstr_nocheck
%endmacro

%macro fill_rectangle 5     ;格式:fill_rectangle 颜色,起始x,起始y,长度,宽度
    mov al,%1
    mov ecx,%2
    mov edx,%3
    mov ebx,%4
    mov ebp,%5
    call dword [rectangle]
%endmacro

%macro pixel 3              ;格式:pixel 颜色,x,y
    mov cl,%1
    mov [pixel_color],cl
    mov ecx,%2
    mov edx,%3
    call draw_pixel
%endmacro

%macro draw_line 5          ;格式:darw_line 颜色,起始x,起始y,结束x,结束y
    mov bl,%1
    mov [pixel_color],bl
    mov ebx,%2
    mov ecx,%3
    mov edx,%4
    mov ebp,%5
    call line
%endmacro

%macro cnt 3    ;code name table,用法:cnt "dis_model","code_name","Technology"
    dw %1
    db %2,0
    db %3,0
%endmacro