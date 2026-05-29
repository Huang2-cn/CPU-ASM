@echo off
cd %~dp0
set T16Bit=.\temp\16.bin
set T32Bit=.\temp\32.bin

if "%~1" == "" (
	echo 用法：make.bat 输出文件名 [nodel]
	echo 注：nodel用于保存中途文件，是可选参数。
	goto endian
	)

if not exist temp\ (
	mkdir temp
	)
	
del /f /s /q %~1>nul
.\tool\VER.exe
.\tool\nasm -f bin .\src\16.asm -o %T16Bit% -l .\temp\16.log -i .\src\include
.\tool\nasm -f bin .\src\32.asm -o %T32Bit% -l .\temp\32.log -i .\src\include
if not exist %T16Bit% (
	echo 16.asm有错误
	goto endian
	)

if not exist %T32Bit% (
	echo 32.asm有错误
	goto endian
	)
.\tool\cut %T32Bit%
copy /b "%T16Bit%" + "%T32Bit%" "%~1" >nul
if %errorlevel% neq 0 (
	echo 拼不到一起去！
	)
if "%~2" == "-nodel" (
	goto suc
	)
del /f /s /q %T16Bit% >nul
del /f /s /q %T32Bit% >nul
:suc
echo 成功编译！
:endian