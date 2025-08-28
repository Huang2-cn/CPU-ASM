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