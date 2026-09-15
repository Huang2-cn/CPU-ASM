compile_info:
db "Compiled on:"
db "2026/8/23",20h
db "at 02:31  VER "
db "3.0.434",0ah,0dh
db "Copyright (c) Huang2.cn"
%if serial_debug = 1
db "[DEBUG VERSION]"
%endif
db 0
VERSION db "Ver 3.0.434",0