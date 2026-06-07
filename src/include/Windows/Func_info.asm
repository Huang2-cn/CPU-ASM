win_func_info:
    istruc win_attr
        at win_attr.x,          dw 0ah
        at win_attr.y,          dw 120d
        at win_attr.w,          dw 620d
        at win_attr.h,          dw 90d
        at win_attr.widget,     dd 0
        at win_attr.title,      dd Function_INFO
    iend
wid_func_info_vendor:
    istruc wid_str
        at wid_str.type,        db 1
        at wid_str.back,        db 0ffh
        at wid_str.x,           dw 4
        at wid_str.y,           dw 4
        at wid_str.index,       dd CPUVendor_Info
        at wid_str.next_wid,    dd 0
    iend
    
    
    
    
    

Function_INFO:      db  0,"Function infomation",0ah,0dh,0  