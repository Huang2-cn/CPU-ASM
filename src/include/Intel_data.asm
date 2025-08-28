    ;CPU指令集
    ;ECX寄存器的
    Intel_function_ECX:
        db 'SSE 3   ',0,'PCLMULDQ ',0,'DTES64 ',0,'MONITOR/MWAIT ',0,'DS-CPL              ',0,'VT-X  ',0,'SMX     ',0,'EST  ',0,'TM2     ',0,'SSSE 3  ',0ah,0dh,0
        db 'CNXT_ID ',0,'SDBG     ',0,'FMA    ',0,'CMPXCHG16B    ',0,'xTPR Update Control ',0,'PDCM ',0,' ',0,'PCID    ',0,'DCA  ',0,'SSE 4.1 ',0,'SSE 4.2', 0ah,0dh,0
        db 'x2APIC  ',0,'MOVBE    ',0,'POPCNT ',0,'TSC-Deadline  ',0,'AES                 ',0,'XSAVE ',0,'OSXSAVE ',0,'AVX  ',0,'F16C    ',0,'RDRAND',0,0ah,0dh,0
    Intel_function_EDX:    ;EDX的
        db 'FPU     ',0,'VME      ',0,'DE     ',0,'PSE           ',0,'TSC                 ',0,'MSR   ',0,'PAE     ',0,'MCE  ',0,'CX8     ',0,'APIC',0,0ah,0dh,0
        db 'SEP     ',0,'MTRR     ',0,'PGE    ',0,'MCA           ',0,'CMOV                ',0,'PAT   ',0,'PSE-36  ',0,'PSN  ',0,'CLFSH  ',0,' ',0,'DS',0ah,0dh,0
        db 'ACPI    ',0,'MMX      ',0,'FXSR   ',0,'SSE           ',0,'SSE 2               ',0,'SS    ',0,'HTT     ',0,'TM  ',0,' ',0,'PBE',0
                   ;Family表
    Intel_Family_Table: 
                    dw "04"                  ;标记
                    dd Intel_Family_4_Table ;指向子表
                    dw "05"
                    dd Intel_Family_5_Table
                    dw "06"
                    dd Intel_Family_6_Table
                    dw "0B"
                    dd Intel_Family_B_Table
                    dw "0F"
                    dd Intel_Family_F_Table
                    dw "13"
                    dd Intel_Family_13_Table
                    dw 6h
    
    
                   
    ;Model表
    Intel_Family_4_Table:
                    dw "09"                  ;标记
                    db "Intel 486.",0     ;对应Code name
                    db "Unknown.",0
                    dw "08"
                    db "Intel 486DX4.",0
                    db "600 nm.",0
                    dw "07"
                    db "Intel 486.",0
                    db "Unknown.",0
                    dw "05"
                    db "Intel 486.",0
                    db "Unknown.",0
                    dw "04"
                    db "Intel 486SL.",0
                    db "800 nm.",0
                    dw "03"
                    db "Intel 486DX2.",0
                    db "800 nm.",0
                    dw "02"
                    db "Intel 486SX.",0
                    db "800 nm.",0
                    dw "01"
                    db "Intel 486DX.",0
                    db "1000 nm.",0
                    dw "00"
                    db "Emulated Intel 486.",0
                    db "Emulated.",0
                    dw 6h                 ;标志此表结束
                    
                    
    Intel_Family_5_Table:
                    dw '0A'
                    db 'Quark D1000(Lakemont)',0
                    db '32 nm.',0
                    dw '09'
                    db 'Quark X1000(Lakemont)',0
                    db '32 nm.',0
                    dw '08'
                    db 'Pentium P55C (Mobile)',0
                    db 'Not unique.',0
                    dw '07'
                    db 'Pentium P55C (Mobile)',0
                    db 'Not unique.',0
                    dw '04'
                    db 'Pentium MMX',0
                    db '350 nm.',0
                    dw '02'
                    db 'Pentium 75MHz',0
                    db '600 nm.',0
                    dw '01'
                    db 'P5, P54, P54CQS(Pentium)',0
                    db '350 nm.',0
                    dw 6h                 ;标志此表结束
                    
    Intel_Family_6_Table:
                    ;上面的懒得用宏改写了
                    cnt '01','Pentium Pro','350 nm.'
                    cnt '03','Klamath (Pentium II)','350 nm.'
                    cnt '05','Deschutes (Pentium II/III)','250 nm.'
                    cnt '06','P6 (Pentium)','Not unique.'
                    cnt '07','Katmai','250 nm.'
                    cnt '08','Coppermine','180 nm.'
                    cnt '0B','Tualatin (Pentium III)','130 nm.'
                    cnt '09','Banias (Pentium M)','130 nm.'
                    cnt '0A','P6 (Pentium)','Not unique.'
                    cnt '0D','Dothan (Pentium M)','90 nm.'
                    cnt '15','Tolapai (Pentium M)','65 nm.'
                    cnt '0E','Yonah','65 nm.'
                    cnt '1F','Merom','65 nm.'
                    cnt '16','Merom L','65 nm.'
                    cnt '17','Penryn / Wolfdale / Yorkfield','45 nm.'
                    cnt '1E','Clarksfield','45 nm.'
                    cnt '25','Arrandale, Clarkdale','32 nm.'
                    cnt '2A','Sandy Bridge-M / Sandy Bridge-H','32 nm.'
                    cnt '3A','Ivy Bridge-M / Ivy Bridge-H','22 nm.'
                    cnt '3C','Haswell-S','22 nm.'
                    cnt '45','Haswell-U','22 nm.'
                    cnt '46','Haswell-MB','22 nm.'
                    cnt '3D','Broadwell-Y / BDW-U / BDW-S','14 nm.'
                    cnt '47','Boradwell-H / BDW-C / BDW-W','14 nm.'
                    cnt '4E','Skylake-Y / SKL-U','14 nm.'
                    cnt '5E','Skylake-H / SKL-S / SKL-DT','14 nm.'
                    cnt '8E','Whiskey Lake / Amber Lake / Kaby Lake-Y / KBL-U / Coffee Lake-U','14 nm.'
                    cnt '9E','Kabylake-H / KBL-S / KBL-DT / KBL-X','14 nm.'
                    cnt '66','Palm Cove / Cannon Lake-U','10 nm.'
                    cnt '7D','Ice Lake-Y','10 nm'
                    cnt '7E','Sunny Cove / Ice Lake-U','10 nm.'
                    cnt '8C','Willow Cove / Tiger Lake-U','10 nm.'
                    cnt '8D','Tiger Lake-H','10 nm.'  
                    cnt 'A5','Comet Lake-H / CML-S','14 nm.'
                    cnt 'A6','Comet Lake-U','14 nm.'
                    cnt 'A7','Rocket Lake-S / RKL-U / Cypress Cove','14 nm.'
                    cnt '97','Alder Lake-S','10 nm.'
                    cnt '9A','Alder Lake-P','10 nm.'
                    cnt 'B7','Raptor Lake-S','7 nm.'
                    cnt 'BA','Raptor Lake-P','7 nm.'
                    cnt 'BE','Raptor Lake-N','7 nm.'
                    cnt 'BF','Raptor Lake-U / RPL-H','7 nm.'
                    cnt 'AA','Crestmont','Intel 4(7 nm.)'
                    cnt 'AB','Meteor Lake-N','Intel 4(7 nm.)'
                    cnt 'AC','Meteor Lake-S','Intel 4(7 nm.)'
                    cnt 'B5','Arrow Lake-U','3 nm.(TSMC)'
                    cnt 'C5','Arrow Lake-H','3 nm.(TSMC)'
                    cnt 'C6','Arrow Lake-S','3 nm.(TSMC)'
                    cnt 'BC','Lunar Lake','3 nm.(TSMC)'
                    cnt 'BD','Lunar Lake','3 nm.(TSMC)'
                    cnt 'B7','Bartlett Lake-S','7 nm,'
                    cnt 'BA','Bartlett Lake-P','7 nm.'
                    cnt 'BE','Bartlett Lake-N','7 nm.'
                    cnt 'BF','Bartlett Lake','7 nm.'
                    cnt 'CC','Panther Lake','Intel 18A (1.8 nm.)'
                    
                    cnt '17','Penryn','45 nm.'
                    cnt '1D','Penryn','45 nm.'
                    cnt '1A','Bloomfield','45 nm.'
                    cnt '1E','Lynnfield','45 nm.'
                    cnt '2E','Nehalem-EX','45 nm.'
                    cnt '2C','Westmere-EP / Gulftown','32 nm.'
                    cnt '2F','Westmere-EX','32 nm.'
                    cnt '2D','Sandy Bridge','32 nm.'
                    cnt '3E','Ivy Bridge','22 nm.'
                    cnt '3F','Haswell','22 nm.'
                    cnt '4F','Broadwell','14 nm.'
                    cnt '56','Broadwell / Hewott lake','14 nm.'
                    cnt '55','Skylake','14 nm.'
                    cnt '6A','Icelake-SP','10 nm.'
                    cnt '6C','Icelake-DE','10 nm.'
                    cnt '8F','Sapphire Rapids','7 nm.'
                    cnt 'CF','Emerald Rapids','7 nm.'
                    cnt 'AD','Redwood Cove','3 nm.'
                    cnt 'AE','Redwood Cove (D)','3 nm.'
                    cnt 'AF','Sierra Forest-SP','3 nm.'
                    cnt 'DD','Clearwater Forest','Intel 18A (1.8 nm.)'
                    
                    cnt '1C','Bonnell','45 nm.'
                    cnt '26','Bonnell','45 nm.'
                    cnt '27','Penwell','32 nm.'
                    cnt '35','Cloverview','32 nm.'
                    cnt '36','Cedarview','32 nm.'
                    cnt '37','Silvermont','22 nm.'
                    cnt '4A','Silvermont','22 nm.'
                    cnt '4D','Silvermont','22 nm.'
                    cnt '5A','Silvermont','22 nm.'
                    cnt '5D','Silvermont','22 nm.'
                    cnt '75','Airmont','14 nm.'
                    cnt '4C','Airmont','14 nm.'
                    cnt '5C','Goldmont','14 nm'
                    cnt '5F','Goldmont','14 nm'
                    cnt '7A','Goldmont-Plus','14 nm'
                    cnt '8A','Lakefield','10 nm.'
                    cnt '86','Jacobsville','10 nm.'
                    cnt '96','Elkhart Lake','10 nm.'
                    cnt '9C','Jasper Lake (L)','10 nm.'
                    cnt '??','Twin Lake','10 nm.'
                    cnt 'B7','Raptor Lake','10 nm.'
                    cnt 'BE','Alder Lake','10 nm.'
                    cnt 'B6','Grand Ridge','Intel 4 (7 nm.)'
                    cnt 'AA','Meteor Lake','Intel 4 (7 nm.)'
                    cnt 'AF','Sierra Forest','Intel 4 (7 nm.)'
                    cnt 'BC','Lunar Lake','3 nm.(TSMC)'
                    cnt 'B5','Arrow Lake','3 nm.(TSMC)'
                    cnt 'CC','Panther Lake','Intel 18A (1.8 nm.)'
                    cnt '??','Wildcat Lake','Intel 18A (1.8 nm.)'

                    cnt '57','Knights Landing','14 nm.'
                    cnt '85','Knights Mill','14 nm.'
                    
                    
                    
                    
                    
                    dw 6h                 ;标志此表结束
                    
    Intel_Family_B_Table:
                    cnt '01','Knights Corner','22 nm.'
                    cnt '00','Knights Ferry','45 nm.'
                    
                    dw 6h
                    
    Intel_Family_F_Table:
                    cnt '01','Willamette','180 nm.'
                    cnt '02','Northwood','130 nm.'
                    cnt '03','Prescott','90 nm.'
                    cnt '04','Prescott (2M)','90 nm.'
                    cnt '06','Cedar Mill','65 nm.'
                    
                    dw 6h 
                    
    
    Intel_Family_13_Table:
                    cnt '00','Nova Lake','Intel 18A (1.8 nm.)'
                    cnt '01','Diamond Rapids','Intel 18A (1.8 nm.)'
                    
                    dw 6h