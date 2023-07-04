

-- CRIANDO USUÁRIO ESPECIFICO PARA BACKUP COM SENHA CRIPTOGRAFADA

CREATE USER 'mypipbackup'@'localhost' IDENTIFIED BY 'backup#123';
GRANT CREATE, INSERT, DROP, UPDATE ON mysql.backup_progress TO 'mypipbackup'@'localhost';
GRANT CREATE, INSERT, SELECT, DROP, UPDATE, ALTER ON mysql.backup_history 
    TO 'mypipbackup'@'localhost';
GRANT REPLICATION CLIENT ON *.* TO 'mypipbackup'@'localhost';
GRANT SELECT ON performance_schema.replication_group_members TO 'mypipbackup'@'localhost';
GRANT SELECT, LOCK TABLES ON `pip`.* TO `mypipbackup`@`localhost`;



-- COMANDO NO PROMPT PARA CRIAR arquivo CRIPTOGRAFADO
-- mysql_config_editor set --login-path=multiuseaccess_mysql_root --host=localhost --user=mypipbackup --password

-- CAMINHO DO ARQUIVO CRIADO (C:\Users\flams_ocitf6p\AppData\Roaming\MySQL)

-- executar arquivo.bat, para realizar o backup

