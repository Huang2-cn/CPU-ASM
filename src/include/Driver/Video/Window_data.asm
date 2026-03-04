window:
win_basic_info:
    istruc win_attr
        at win_attr.x,      dw 0ah
        at win_attr.y,      dw 0ah
        at win_attr.w,      dw 780h
        at win_attr.h,      dw 80h
        at win_attr.widget, dd wid_basic_info
        at win_attr.title,  dd CPU_INFO
    iend
    
    
    
wid_basic_info:

data_basic_info:
CPU_INFO:           db  "CPU infomation",0 