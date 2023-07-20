@echo off

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%" & set "MS=%dt:~15,3%"
set "dirname=%DD%_%MM%_%YY%_%HH%%Min%"
 
mysqlcheck  --defaults-file=C:\mysqlapoio\config.cnf pip > C:\Users\flams_ocitf6p\Documents\1-Projeto_pip_sql\Projeto_PIP_My_SQL\Integridade_DB_PIP\checkdb%dirname%.txt

forfiles /p "C:\Users\flams_ocitf6p\Documents\1-Projeto_pip_sql\Projeto_PIP_My_SQL\Integridade_DB_PIP" /s /m *.* /D -15 /C "cmd /c del @path"


REM Este arquivo deve ser executado de no agendador de tarefas windows