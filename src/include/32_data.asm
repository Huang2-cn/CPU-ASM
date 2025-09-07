section .text
stopped_msg:        db  "Halted.", 0ah,0dh,0
GP_MSG:             db  "ERROR: Interrupt #GP OCCURED!",0ah,0dh,0
UD_MSG:             db  "ERROR: Interrupt #UD OCCURED!",0ah,0dh,0
DF_MSG:             db  "ERROR: Interrupt #DF OCCURED!",0ah,0dh,0
ER_MSG:             db  "CPU-ASM cannot continue,please contact developer in hh1911391294@163.com or submit issue on Github.", 0ah, 0dh
                    db  "And provide the following message:", 0ah,0dh
                    db  "CS Register:0x"
ER_CS:              db  "?","?","?","?",0ah,0dh
                    db  "EIP Register:0x"
ER_EIP:             db  "?","?","?","?","?","?","?","?",0ah,0dh
                    db  0

V16BPP:             db  0                               ;标志是否是16BPP模式
DMOD:               dw  0
                    
CPU_INFO:           db  0,"CPU infomation",0ah,0dh,0 
Function_INFO:      db  0,"Function infomation",0ah,0dh,0     
Clock_INFO:         db  0,"Clock infomation",0ah,0dh,0                    
CPUVendor_Info:     db  "Vendor: "
Vendor_name:        db  8 dup (0)
CPU_Specification:  db  "Specification: "
Specification_name: db  "CPU NOT SUPPORT THIS DETECTION."
                    db  18 dup(0)
CPU_Family_Info:    db  "Family: "
CPU_Family:         db  0
                    db  "  Model: "
CPU_Model:          db  0
                    db  "  Stepping:  "
CPU_Stepping:       db  0
                    db  "  EXT. Model: "
CPU_EXT_Model:      db  0
                    db  "  EXT. Family: "
CPU_EXT_Family:     dw  0
                    db  "  Display Model: "
CPU_Dis_Model:      dw  0
                    db  "  Display Family: "
CPU_Dis_Family:     dw  0
                    db  0

CPU_CODE_NAME_Info: db  "Code name: "
CPU_CODE_NAME:      db  "Unknown Code name."
                    db  16 dup (0)    
                    
CPU_TECH_Info:      db  "       Technology: "
CPU_TECH:           db  16 dup (0)    
CPU_Freq_Info:      db  'Frequency: ',0
Freq:               db  'NaN',0,0,0
MHz:                db  'MHz.       ',0
Multiplier_Info:    db  'Multiplier: '
Multiplier:         db  'NaN',0,0,0
BCLK_Info:          db  'Bus Clock: ',0
BCLK:               db  'NaN',0,0,0,0
Support_TSC:        db  1
Support_MSR:        db  1
Reading_MSR:        db  0
                    
                    
                    
Intel:              db  "GenuineIntel",0   
Intel_Corp:         db  "Intel",0
AMD:                db  "AuthenticAMD",0   
AMD_Corp:           db  "AMD",0
allow_output:       db  0       ;允许输出信息，0为允许
window_lenth:       dd  0
line_start:         dd  21
line_lenth:         dd  0
video_screen_width: dd  0
video_screen_height dd  0
print_Y:            dd  0
print_X:            dd  0
pixel_color:        db  0
video_base_addr:    dd  0
video_endian_addr:  dd  0


CPU_Freq:           dw  0  
Multi_Freq:         db  0
BUS_Freq:           dw  0

            
%include "Intel_data.asm"
%include "AMD_data.asm"
%if serial_debug = 1
    ;如启用了串口调试的数据
    SDB_INFO:       db   "Serial Port DEBUG is Enabled.", 0ah,0dh
    SDB_VADDR:      db   "Video address Base:"
    SDB_VAD_VALUE:  db   8 dup (0),0ah,0dh
    SDB_CDM:        db   "Current Display Mode:"
    SDB_CDM_VALUE:  db   4 dup (0),0ah,0dh,0
    SDB_UD:         db   "#UD",0
    SDB_GP:         db   "#GP",0
    SDB_DF:         db   "#DF",0
    SDB_KEYBORAD:   db   "KEYBORAD",0
    SDB_SERIAL:     db   "SERIAL",0
    SDB_LPT:        db   "LPT",0
    SDB_TMR:        db   "TIMER",0
    SDB_FLOPPY:     db   "FLOPPY",0
    SDB_UNKNOWN:    db   "UNKNOWN",0
    SDB_TEST:       db   "TEST",0
    SDB_MOUSE:      db   "MOUSE",0
    SDB_INT:        db   "Interrupt ",0
    SDB_OCC:        db   " Occurred.", 0ah,0dh,0
    SDB_EAX:        db   "EAX: "
    SDB_EAX_VALUE:  db   8 dup(0),0ah,0dh
    SDB_EBX:        db   "EBX: "
    SDB_EBX_VALUE:  db   8 dup(0),0ah,0dh
    SDB_ECX:        db   "ECX: "
    SDB_ECX_VALUE:  db   8 dup(0),0ah,0dh
    SDB_EDX:        db   "EDX: "
    SDB_16BPP:      db   "In 16 BPP Video Mode!"
    SDB_EDX_VALUE:  db   8 dup(0),0ah,0dh,0
    DIV0:           db   "DIV 0!!!",0
%endif
            