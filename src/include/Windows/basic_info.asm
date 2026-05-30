win_basic_info:
    istruc win_attr
        at win_attr.x,          dw 0ah
        at win_attr.y,          dw 0ah
        at win_attr.w,          dw 780d
        at win_attr.h,          dw 80d
        at win_attr.widget,     dd wid_basic_info_vendor
        at win_attr.title,      dd CPU_INFO
    iend

wid_basic_info_vendor:
    istruc wid_str
        at wid_str.type,        db 1
        at wid_str.back,        db 0ffh
        at wid_str.x,           dw 4
        at wid_str.y,           dw 4
        at wid_str.index,       dd CPUVendor_Info
        at wid_str.next_wid,    dd wid_basic_info_Specification
    iend
    
    
wid_basic_info_Specification:
    istruc wid_str
        at wid_str.type,        db 1
        at wid_str.back,        db 0ffh
        at wid_str.x,           dw 172
        at wid_str.y,           dw 4
        at wid_str.index,       dd CPU_Specification
        at wid_str.next_wid,    dd wid_basic_info_Family
    iend
    
wid_basic_info_Family:
    istruc wid_str
        at wid_str.type,        db 1
        at wid_str.back,        db 0ffh
        at wid_str.x,           dw 4
        at wid_str.y,           dw 20
        at wid_str.index,       dd CPU_Family_Info
        at wid_str.next_wid,    dd wid_basic_info_CNAME
    iend
    
    
    
wid_basic_info_CNAME:
    istruc wid_str
        at wid_str.type,        db 1
        at wid_str.back,        db 0ffh
        at wid_str.x,           dw 172
        at wid_str.y,           dw 36
        at wid_str.index,       dd CPU_CODE_NAME_Info
        at wid_str.next_wid,    dd 0 
    iend
data_basic_info:                    ;数据
CPU_INFO:           db  0,"CPU infomation",0 
CPUVendor_Info:     db  0,"Vendor: "
Vendor_name:        db  8 dup (0)
CPU_Specification:  db  0,"Specification: "
Specification_name: db  "CPU NOT SUPPORT THIS DETECTION."
                    db  18 dup(0)
CPU_Family_Info:    db  0,"Family: "
CPU_Family:         db  0
                    db  "  Model: "
CPU_Model:          db  0
                    db  "  EXT. Family: "
CPU_EXT_Family:     dw  0
                    db  "  EXT. Model: "
CPU_EXT_Model:      db  0
                    db  "  Display Model: "
CPU_Dis_Model:      dw  0
                    db  "  Display Family: "
CPU_Dis_Family:     dw  0
                    db  0ah,0dh
                    db  "Stepping:  "
CPU_Stepping:       db  0
                    db  0

CPU_CODE_NAME_Info: db  0,"Code name: "
CPU_CODE_NAME:      db  "Unknown Code name."
                    db  16 dup (0)