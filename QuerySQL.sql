-- O GOVERNO DO ESTADO DO ESPIRITO SANTO ATRAVÉS DA SECRETARIA DE ORÇAMENTO E PLANEJAMENTO, BUSCANDO QUALIDADE NO GASTO PÚBLICO E
-- UM MAIOR CONTROLE ORÇAMENTARIO NA ÁREA DOS INVESTIMENTOS, SOLICITA UMA PROJEÇÃO ORÇAMENTARIA PARA DEFINIR QUANTO DE RECURSO DO TESOURO ESTADUAL
-- SERÁ NECESSÁRIO PARA 2023 PARA PROJETOS QUE JA ESTÃO EM ANDAMENTO.
-- CRITERIOS ADOTADOS: COLUNA FONTE_1 (FILTRO CAIXA DO TESOURO) POWER QUERY POWER BI
--                     COLUNA STATUS (FILTRO NULL E EM EXECUÇÃO)
SELECT * FROM tb_act_qualitativo;
SELECT * FROM tb_act_execucao;
SELECT * FROM tb_act_orcamentario;
select * from tb_act_status;


SELECT VALOR_ATENDIDO, TIPO, tipo_fonte FROM pip.tb_act_execucao;


SELECT Q.PROJETO,
 s.status,
 q.UNIDADE_COORDENADORA,
 o.fonte_1, o.caixa_2022,
 e.valor_atendido  
 FROM pip.tb_act_orcamentario o
join tb_act_qualitativo Q on Q.ID_PROJETO = O.ID_PROJETO2
left join tb_act_execucao E on e.id_projeto1 = q.id_projeto
left join tb_act_status S on s.id_projeto = e.id_projeto1;

alter view VW_DESAFIO
AS
SELECT Q.PROJETO,
 s.status,
 q.UNIDADE_COORDENADORA,
 o.fonte_1,
 o.caixa_2022,
 e.valor_atendido  
 FROM pip.tb_act_orcamentario o
join tb_act_qualitativo Q on Q.ID_PROJETO = O.ID_PROJETO2
left join tb_act_execucao E on e.id_projeto1 = q.id_projeto
left join tb_act_status S on s.id_projeto = e.id_projeto1;
SELECT * FROM VW_DESAFIO;

-- todos os projetos estruturantes que estão em execução

select q.PROJETO,
 q.UNIDADE_COORDENADORA,
 q.escopo,
 q.AREA_ESTRATEGICA,
 q.PROJETO_ESTRUTURANTE,
 S.STATUS,
 o.FONTE_1,
 o.CAIXA_2022,
 o.CAIXA_2023, 
 o.CAIXA_2024,
 o.DEMAIS_FONTES_2022,
 o.DEMAIS_FONTES_2023,
 o.DEMAIS_FONTES_2024 
 from tb_act_qualitativo as q
join tb_act_orcamentario as o on o.ID_PROJETO2 = q.ID_PROJETO
JOIN tb_act_status as s on  S.ID_PROJETO = O.ID_PROJETO2
where q.projeto_estruturante = 'Sim' and s.status = 'Em Execução';


-- PROJETOS ESTRUTURANTES COM STATUS "PARALISADOS"
-- Em um esforço para melhores práticas no que se refere a comunicação entre planejamento e orçamento, foi requisitado os projetos que estãos
-- paralisados afim de realizar entregas que já estão em andamento.

-- CRIANDO UMA PROCEDURE PARA CHAMAR A ATUALIZAÇÃO DESSES DADOS

DELIMITER $$

CREATE PROCEDURE Paralisados()
BEGIN
    
    SELECT q.PROJETO,
           q.UNIDADE_COORDENADORA,
           q.escopo,
           q.AREA_ESTRATEGICA,
           q.PROJETO_ESTRUTURANTE,
           s.STATUS,
           o.FONTE_1,
           o.CAIXA_2022,
           o.CAIXA_2023, 
           o.CAIXA_2024,
           o.DEMAIS_FONTES_2022,
           o.DEMAIS_FONTES_2023,
           o.DEMAIS_FONTES_2024 
    FROM tb_act_qualitativo AS q
    JOIN tb_act_orcamentario AS o ON o.ID_PROJETO2 = q.ID_PROJETO
    JOIN tb_act_status AS s ON s.ID_PROJETO = o.ID_PROJETO2
    WHERE q.projeto_estruturante = 'Sim' AND s.STATUS = 'paralisado';
END $$

DELIMITER ;
CALL Paralisados();

-- CRIANDO VIEW PARA EXPORTAR OS DADOS

CREATE VIEW PARALISADO AS
SELECT q.PROJETO,
       q.UNIDADE_COORDENADORA,
       q.escopo,
       q.AREA_ESTRATEGICA,
       q.PROJETO_ESTRUTURANTE,
       s.STATUS,
       o.FONTE_1,
       o.CAIXA_2022,
       o.CAIXA_2023,
       o.CAIXA_2024,
       o.DEMAIS_FONTES_2022,
       o.DEMAIS_FONTES_2023,
       o.DEMAIS_FONTES_2024
FROM tb_act_qualitativo AS q
JOIN tb_act_orcamentario AS o ON o.ID_PROJETO2 = q.ID_PROJETO
JOIN tb_act_status AS s ON s.ID_PROJETO = o.ID_PROJETO2
WHERE q.projeto_estruturante = 'Sim' AND s.STATUS = 'paralisado';

SELECT * FROM PARALISADO;



-- STORE PROCEDURE CRIADA AFIM DE OTIMIZAR O TEMPO PARA GERAR RELATÓRIOS DE ACOMPANHAMENTOS POR UNIDADE_COORDENADORA
delimiter $$

create procedure RelatorioUO ( in Unidade_Coordenadora int)
	begin
		select Q.projeto, 
			 Q.entrega_produto, 
			 Q.resultados_esperados, 
			 Q.unidade_coordenadora, 
			 O.uo_cod, 
			 Q.area_estrategica, 
			 Q.escopo, 
			 O.CAIXA_2022,
			 O.CAIXA_2023,
			 O.CAIXA_2024,
			 O.DEMAIS_FONTES_2022,
			 O.DEMAIS_FONTES_2023,
			 O.DEMAIS_FONTES_2024
	FROM tb_act_qualitativo AS Q
	JOIN tb_act_orcamentario as O on O.id_projeto2 = Q.id_projeto
	WHERE O.uo_cod = Unidade_Coordenadora;
	END$$ 

DELIMITER ;

CALL RelatorioUO(35101);

-- CRIANDO TRIGGER DE AUDITORIA PARA IDENTIFICAR ALTERAÇÕES NOS VALORES ORÇAMENTÁRIOS PREVIAMENTE 
-- CADASTRADOS, AFIM DE MAIOR SEGURANÇA E CONSISTÊNCIA DOS DADOS.

DROP TABLE IF EXISTS AUDITORIA_PIP;
CREATE TABLE auditoria_PIP (
	id_orcamentario INT ,
  id_projeto2 INT,
  uo_cod VARCHAR(45),
  fonte_1 VARCHAR(45),
  fonte_2 VARCHAR(45),
  fonte_3 VARCHAR(45),
  fonte_4 VARCHAR(45),
  CAIXA_2022 VARCHAR(45),
  CAIXA_2023 VARCHAR(45),
  CAIXA_2024 VARCHAR(45),
  DEMAIS_FONTES_2022 VARCHAR(45),
  DEMAIS_FONTES_2023 VARCHAR(45),
  DEMAIS_FONTES_2024 VARCHAR(45),
	updatedat datetime not null,
	operation char(3) not null,
	usuario varchar (20),
	CHECK( operation = 'INS' or operation = 'DEL')
	);

DELIMITER $$
CREATE TRIGGER auditoria_orcamento AFTER INSERT 
ON tb_act_orcamentario
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_PIP (
        id_orcamentario,
        id_projeto2,
        uo_cod,
        fonte_1,
        fonte_2,
        fonte_3,
        fonte_4,
        CAIXA_2022,
        CAIXA_2023,
        CAIXA_2024,
        DEMAIS_FONTES_2022,
        DEMAIS_FONTES_2023,
        DEMAIS_FONTES_2024,
        updatedat,
        usuario,
        operation
    )
    VALUES (
        NEW.id_orcamentario,
        NEW.id_projeto2,
        NEW.uo_cod,
        NEW.fonte_1,
        NEW.fonte_2,
        NEW.fonte_3,
        NEW.fonte_4,
        NEW.CAIXA_2022,
        NEW.CAIXA_2023,
        NEW.CAIXA_2024,
        NEW.DEMAIS_FONTES_2022,
        NEW.DEMAIS_FONTES_2023,
        NEW.DEMAIS_FONTES_2024,
        NOW(),
        USER(),
        'INS'
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER auditoria_orcamento2 AFTER DELETE
ON tb_act_orcamentario
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_PIP (
        id_orcamentario,
        id_projeto2,
        uo_cod,
        fonte_1,
        fonte_2,
        fonte_3,
        fonte_4,
        CAIXA_2022,
        CAIXA_2023,
        CAIXA_2024,
        DEMAIS_FONTES_2022,
        DEMAIS_FONTES_2023,
        DEMAIS_FONTES_2024,
        updatedat,
        usuario,
        operation
    )
    VALUES (
        OLD.id_orcamentario,
        OLD.id_projeto2,
        OLD.uo_cod,
        OLD.fonte_1,
        OLD.fonte_2,
        OLD.fonte_3,
        OLD.fonte_4,
        OLD.CAIXA_2022,
        OLD.CAIXA_2023,
        OLD.CAIXA_2024,
        OLD.DEMAIS_FONTES_2022,
        OLD.DEMAIS_FONTES_2023,
        OLD.DEMAIS_FONTES_2024,
        NOW(),
        USER(),
        'DEL'
    );
END$$
DELIMITER ;

-- ------------------------------------------------
 -- TESTANDO AS TRIGGERS DE INSERT INTO E DELETE.
-- ------------------------------------------------

 INSERT INTO tb_act_orcamentario (
  id_orcamentario,
  id_projeto2,
  uo_cod,
  fonte_1,
  fonte_2,
  fonte_3,
  fonte_4,
  CAIXA_2022,
  CAIXA_2023,
  CAIXA_2024,
  DEMAIS_FONTES_2022,
  DEMAIS_FONTES_2023,
  DEMAIS_FONTES_2024
) VALUES (
  1180,
  1182,
  '3555',
  '0101000999',
  '0101000999',
  '0101000999',
  '0101000999',
  '1265000.00',
  '1265000.00',
  '1265000.00',
  '1265000.00',
  '1265000.00',
  '1265000.00'
);

DELETE FROM tb_act_orcamentario WHERE (ID_ORCAMENTARIO = '1180');
  
SELECT * FROM auditoria_pip;

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
  
  
 
  
  
  

  














