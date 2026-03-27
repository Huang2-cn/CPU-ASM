 vesa_data_base   equ 900h
        ;VesaBIOS中断调用返回的数据缓冲区
        ;用上的时候再打注释吧(参照Vesa手册30~31面
        modeaattrib     equ  vesa_data_base
        winaattrib      equ  vesa_data_base + 2
        winbattrib      equ  vesa_data_base + 3
        wingranularity  equ  vesa_data_base + 4
        winsize         equ  vesa_data_base + 6
        winaseg         equ  vesa_data_base + 8
        winbseg         equ  vesa_data_base + 0ah
        winfuncptr      equ  vesa_data_base + 0ch
        byteperscanlin  equ  vesa_data_base + 10h
        
        screen_width    equ  vesa_data_base + 12h  ;屏幕宽度
        screen_height   equ  vesa_data_base + 14h  ;屏幕高度
        char_width      equ  vesa_data_base + 16h
        char_height     equ  vesa_data_base + 17h
        numofplane      equ  vesa_data_base + 18h
        pixel_bits      equ  vesa_data_base + 19h  ;每像素的位数
        numofbank       equ  vesa_data_base + 1ah
        mem_model       equ  vesa_data_base + 1bh
        bank_size       equ  vesa_data_base + 1ch
        numofimgpage    equ  vesa_data_base + 1dh   
                           ;保留一字节
                        
        redmasksize     equ  vesa_data_base + 1fh
        redfieldpos     equ  vesa_data_base + 20h
        greenmasksize   equ  vesa_data_base + 21h
        greenfieldpos   equ  vesa_data_base + 22h
        bluemasksize    equ  vesa_data_base + 23h
        bluefieldpos    equ  vesa_data_base + 24h
        rsvmasksize     equ  vesa_data_base + 25h
        rsvfieldpos     equ  vesa_data_base + 26h
        directcolorinf  equ  vesa_data_base + 27h
        
        
        video_phy_addr  equ  vesa_data_base + 28h      ;显存基地址
                            ;保留3字节
                        
        linbyteperscanline      equ  vesa_data_base + 32h
        bnknumofimgpages        equ  vesa_data_base + 34h
        linnumofimgpages        equ  vesa_data_base + 35h
        linredmasksize          equ  vesa_data_base + 36h
        linredfieldpos          equ  vesa_data_base + 37h
        lingreenmasksize        equ  vesa_data_base + 38h
        lingreenfieldpos        equ  vesa_data_base + 39h
        linbluemasksize         equ  vesa_data_base + 3ah
        linbluefieldpos         equ  vesa_data_base + 3bh
        linrsvdmasksize         equ  vesa_data_base + 3ch
        linrsvefieldpos         equ  vesa_data_base + 3dh
        maxpixelclock           equ  vesa_data_base + 3eh
%define MAX_WINDOW 64
%define win_chain_buffer    1000000h
%define video_buffer        2000000h
struc win_attr                      ;窗口属性
    .valid       resw    1
    .x           resw    1           ;窗口默认左上角X,若为0ffffh则出现在默认位置
    .y           resw    1           ;窗口默认左上角Y
    .w           resw    1           ;宽度
    .h           resw    1           ;高度
    .widget      resd    1           ;指向窗口控件列表
    .title       resd    1           ;指向窗口标题
endstruc

struc wid_str                       ;窗口控件:字符串
    .type        resb    1           ;请务必保证为1,这标志这是个字符串!
    .color       resb    1           ;字符串的前景色
    .back        resb    1           ;字符串的背景色
    .tran        resb    1           ;是否透明，若为真，背景色不生效
    .x           resw    1           ;控件左上角相对于窗口左上角的x位置
    .y           resw    1           ;同上,y
    ;不定义大小,由字符串长度及内容自动计算
    .index       resd    1           ;字符串内容的指针
    .next_wid    resd    1           ;下一个控件(0则无)
endstruc
        
struc win_chain
    .type        resw    1           ;类型,FD00:哑节点,FD01:普通窗口
    .closed      resb    1           ;是否已关闭
    .visible     resb    1           ;是否可视(最小化)，暂时未使用
    .x           resw    1           ;左上角相对于屏幕的位置,x
    .y           resw    1           ;同上,y
    .attr        resd    1           ;应指向窗口属性结构体
    .pre_win     resd    1           ;指向上一个窗口
    .next_win    resd    1           ;指向下一个窗口
    .endian:
endstruc