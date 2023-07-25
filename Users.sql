-- ESSA ETAPA MARCA A ATRIBUIÇÃO DOS PONTOS FOCAIS QUE ESTARÃO ADMINISTRANDO A BASE DE DADOS DOS PROJETOS DE INVESTIMENTOS DO ESTADO(PIP). 
-- CRIANDO ROLES PARA ATRIBUIR AOS USUÁRIOS.

create role 'app_desenvolvedor', 'app_leitura', 'app_gravacao';

-- ATRIBUINDO PRIVILÉGIOS AS ROLES E AOS USUÁRIOS

GRANT ALL ON PIP.* TO 'app_desenvolvedor';
GRANT SELECT ON PIP.* TO 'app_leitura'; -- ATRIBUIR PARA O USUARIO GERENTE DE MONITORAMENTO E AVALIAÇÃO  DE POLITICAS PUBLICAS
GRANT INSERT, UPDATE, DELETE ON PIP.* TO 'app_gravacao'; -- DBA JR

-- CRIANDO USUÁRIOS 

CREATE USER 'ROGERIO'@'localhost' IDENTIFIED BY 'dbajr123';
CREATE USER 'lUCAS'@'localhost' IDENTIFIED BY 'GMAPP213';
CREATE USER 'LILIA'@'localhost' IDENTIFIED BY 'read_user2pass';
CREATE USER 'JonatasDBA'@'%' IDENTIFIED BY 'dev1user';

-- atribuição

GRANT 'app_desenvolvedor' TO 'JonatasDBA'@'%';
GRANT 'app_leitura' TO 'lUCAS'@'localhost';
GRANT 'app_leitura' TO 'LILIA'@'localhost';
GRANT 'app_gravacao' TO 'ROGERIO'@'localhost';

-- Ativando

SET DEFAULT ROLE ALL TO
  'ROGERIO'@'localhost',
  'lUCAS'@'localhost',
  'LILIA'@'localhost',
  'JonatasDBA'@'%';