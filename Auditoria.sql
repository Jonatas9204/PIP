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