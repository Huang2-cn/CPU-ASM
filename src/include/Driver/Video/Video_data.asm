window_lenth:       dd  0           ;用于窗口绘制
line_start:         dd  21
line_lenth:         dd  0
video_screen_width: dd  0
video_screen_height dd  0
print_Y:            dd  0
print_X:            dd  0
pixel_color:        db  0
video_base_addr:    dd  0
video_endian_addr:  dd  0
background:         db  0f0h

video_addr:         dd  vfun_err
draw_pixel:         dd  vfun_err
rectangle:          dd  vfun_err
clean_screen:       dd  vfun_err
print:              dd  vfun_err
br:                 dd  vfun_err
sel_bank:           dd  vfun_err
%include "\Driver\Video\Window_data.asm"