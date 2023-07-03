--
-- RESTORE DATABASE PROMPT DE COMANDO
--
-- Caminho do arquivo por Exemplo: C:\Users\flams_ocitf6p\Documents\1 - Projeto pip sql\Projeto PIP My SQL\TEST1RESTAURAÇÃO\pip_372023_1950

-- Depois o comando abaixo para executar o restore:

mysql -u root -p teste_pip < pip_372023_1950.sql

-- Restore realizado, subir as transações realizadas para integridade do banco.
-- Através do prompt de comando realizar a restauração dos BINLOGS

cd C:\Users\flams_ocitf6p\Documents\1 - Projeto pip sql\Projeto PIP My SQL\TEST1RESTAURAÇÃO\LOG

mysqlbinlog DESKTOP-FLAMS-bin.000026 | mysql -uroot -p teste_pip
mysqlbinlog DESKTOP-FLAMS-bin.000027 | mysql -uroot -p teste_pip 
mysqlbinlog DESKTOP-FLAMS-bin.000028 | mysql -uroot -p teste_pip 
mysqlbinlog DESKTOP-FLAMS-bin.000029 | mysql -uroot -p teste_pip
