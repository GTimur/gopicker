@echo off
chcp 1251
SET CURDATE=%date:~6,4%%date:~3,2%%date:~0,2%
SET GET_PATH=%date:~6,4%\%date:~3,2%\%date:~0,2%
SET CONTENTPATH=D:\TEMP\1
D:
cd %CONTENTPATH%
R:\WORK\SCRIPTS\PICKER\gopicker_x64.exe -file="*.fru" -dst="%CONTENTPATH%" -silent=false -findDir="." -findNameContains="310" -findPhrase="@" -findOnly=true
