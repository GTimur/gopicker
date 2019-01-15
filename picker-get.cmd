@echo off
chcp 1251
SET CURDATE=%date:~6,4%%date:~3,2%%date:~0,2%
SET GET_PATH=%date:~6,4%\%date:~3,2%\%date:~0,2%
SET CONTENTPATH=Z:\forms_real\RKC\xml\IN\outpath\content
z:
cd %CONTENTPATH%\%GET_PATH%
C:\TEMP\ED211\gopicker32.exe -file="*.txt" -dst="C:\TEMP\ED211\DATA" -silent=false -findDir="ED211" -findNameContains="ED211" -findOnly
C:\TEMP\ED211\gopicker32.exe -file="*.txt" -dst="C:\TEMP\ED211\DATA" -silent=false -findDir="ED245" -findNameContains="ED245" -findOnly
C:\TEMP\ED211\gopicker32.exe -file="*.txt" -dst="C:\TEMP\ED211\DATA" -silent=false -findDir="ED219" -findNameContains="ED219" -findOnly
c:
cd C:\TEMP\ED211\DATA\%date:~6,4%\%date:~3,2%\%date:~0,2%\ED211
rename *.txt *.asc
cd C:\TEMP\ED211\DATA\%date:~6,4%\%date:~3,2%\%date:~0,2%\ED245
rename *.txt *.asc
cd C:\TEMP\ED211\DATA\%date:~6,4%\%date:~3,2%\%date:~0,2%\ED219
rename *.txt *.asc
