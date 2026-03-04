pitch_C   equ 17243
pitch_#C  equ 16278
pitch_D   equ 15356
pitch_#D  equ 14489
pitch_E   equ 13668
pitch_F   equ 12913
pitch_#F  equ 12188
pitch_G   equ 11498
pitch_#G  equ 10857
pitch_A   equ 10251
pitch_#A  equ 9669
pitch_B   equ 9129

pitch_c   equ 8615
pitch_#c  equ 8133
pitch_d   equ 7673
pitch_#d  equ 7240
pitch_e   equ 6838
pitch_f   equ 6450
pitch_#f  equ 6088
pitch_g   equ 5748
pitch_#g  equ 5424
pitch_a   equ 5121
pitch_#a  equ 4833
pitch_b   equ 4561

pitch_c1  equ 4561
pitch_#c1 equ 4295
pitch_d1  equ 4064
pitch_#d1 equ 3835
pitch_e1  equ 3620
pitch_f1  equ 3417
pitch_#f1 equ 3225
pitch_g1  equ 3044
pitch_#g1 equ 2873
pitch_a1  equ 2712
pitch_#a1 equ 2559
pitch_b1  equ 2416

pitch_c2  equ 2280
pitch_#c2 equ 2152
pitch_d2  equ 2031
pitch_#d2 equ 1917
pitch_e2  equ 1809
pitch_f2  equ 1708
pitch_#f2 equ 1612
pitch_g2  equ 1521
pitch_#g2 equ 1436
pitch_a2  equ 1355
pitch_#a2 equ 1279
pitch_b2  equ 1207
			  
pitch_c3  equ 1140
pitch_#c3 equ 1076
pitch_d3  equ 1015
pitch_#d3 equ 958
pitch_e3  equ 904
pitch_f3  equ 854
pitch_#f3 equ 806
pitch_g3  equ 760
pitch_#g3 equ 718
pitch_a3  equ 677
pitch_#a3 equ 639
pitch_b3  equ 604
			  
pitch_c4  equ 570
pitch_#c4 equ 538
pitch_d4  equ 507
pitch_#d4 equ 508
pitch_e4  equ 452
pitch_f4  equ 427
pitch_#f4 equ 403
pitch_g4  equ 380
pitch_#g4 equ 359
pitch_a4  equ 339
pitch_#a4 equ 320
pitch_b4  equ 302

%macro set_pitch 1
	mov ax,%1
	out 42h,al
	mov al,ah
	out 42h,al
%endmacro

%macro sound 3 ;sound 音调 持续时长 间隔时长（相隔音符数）
    mov ax,pitch_%1
    out 42h,al
    mov al,ah
    out 42h,al
    mov ecx,%2
    call play
    call delay    
    call stop_play
    mov ecx,%3
    call delay
%endmacro

