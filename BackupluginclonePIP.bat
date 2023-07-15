@echo off

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%" & set "MS=%dt:~15,3%"
set "dirname=%DD%_%MM%_%YY%_%HH%%Min%"

set basedir=C:
set workdir=C:\mysqlapoio\clonebackup\
set BKclonedir=C:\Users\flams_ocitf6p\Documents\1-Projeto_pip_sql\Projeto_PIP_My_SQL\BackupPluginCLONE

"C:\Program Files\7-Zip\7z.exe" a -tzip cloneBK%dirname%.7z %workdir%\

MOVE cloneBK%dirname%.7z %BKclonedir%
REM Exclui o diretório clonebackup
RD /S /Q %workdir%






