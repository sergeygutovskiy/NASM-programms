@echo off
if %1=="" goto error
nasm -f bin %~n1.asm -o com/%~n1.com
goto end
:error
echo No file
:end 