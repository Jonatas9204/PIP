-- CRIANDO TRIGGER DE AUDITORIA PARA IDENTIFICAR ALTERAÇÕES NOS VALORES ORÇAMENTÁRIOS PREVIAMENTE 
-- CADASTRADOS, A FIM DE MAIOR SEGURANÇA E CONSISTÊNCIA DOS DADOS.


--
-- TABELA DE AUDITORIA
--

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
    old_row_data JSON,
    new_row_data JSON,
	CHECK (operation IN ('INS', 'DEL', 'UPD'))
	);
    
    
    
--
-- TRIGGER DE INSERT
--
    
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
        operation,
        old_row_data, -- Adicionando a coluna old_row_data
        new_row_data  -- Adicionando a coluna new_row_data
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
        'INS',
        JSON_OBJECT(
            'id_orcamentario', NEW.id_orcamentario,
            'id_projeto2', NEW.id_projeto2,
            'uo_cod', NEW.uo_cod,
            'fonte_1', NEW.fonte_1,
            'fonte_2', NEW.fonte_2,
            'fonte_3', NEW.fonte_3,
            'fonte_4', NEW.fonte_4,
            'CAIXA_2022', NEW.CAIXA_2022,
            'CAIXA_2023', NEW.CAIXA_2023,
            'CAIXA_2024', NEW.CAIXA_2024,
            'DEMAIS_FONTES_2022', NEW.DEMAIS_FONTES_2022,
            'DEMAIS_FONTES_2023', NEW.DEMAIS_FONTES_2023,
            'DEMAIS_FONTES_2024', NEW.DEMAIS_FONTES_2024
        ),
        NULL -- Como é uma inserção, a coluna old_row_data será NULL
    );
END$$
DELIMITER ;

--
-- TRIGGER DE DELETE
--

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
        operation,
        old_row_data, -- Adicionando a coluna old_row_data
        new_row_data  -- Adicionando a coluna new_row_data
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
        'DEL',
        JSON_OBJECT(
            'id_orcamentario', OLD.id_orcamentario,
            'id_projeto2', OLD.id_projeto2,
            'uo_cod', OLD.uo_cod,
            'fonte_1', OLD.fonte_1,
            'fonte_2', OLD.fonte_2,
            'fonte_3', OLD.fonte_3,
            'fonte_4', OLD.fonte_4,
            'CAIXA_2022', OLD.CAIXA_2022,
            'CAIXA_2023', OLD.CAIXA_2023,
            'CAIXA_2024', OLD.CAIXA_2024,
            'DEMAIS_FONTES_2022', OLD.DEMAIS_FONTES_2022,
            'DEMAIS_FONTES_2023', OLD.DEMAIS_FONTES_2023,
            'DEMAIS_FONTES_2024', OLD.DEMAIS_FONTES_2024
        ),
        NULL -- Como é uma exclusão, a coluna new_row_data será NULL
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
  1181,
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

DELETE FROM tb_act_orcamentario WHERE (ID_ORCAMENTARIO = '1181');
  
SELECT * FROM auditoria_pip;



--
-- TRIGGER DE UPDATE
--

DELIMITER $$
CREATE TRIGGER auditoria_orcamento_update AFTER UPDATE
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
        operation,
        old_row_data,
        new_row_data
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
        'UPD',
        JSON_OBJECT(
            'id_orcamentario', OLD.id_orcamentario,
            'id_projeto2', OLD.id_projeto2,
            'uo_cod', OLD.uo_cod,
            'fonte_1', OLD.fonte_1,
            'fonte_2', OLD.fonte_2,
            'fonte_3', OLD.fonte_3,
            'fonte_4', OLD.fonte_4,
            'CAIXA_2022', OLD.CAIXA_2022,
            'CAIXA_2023', OLD.CAIXA_2023,
            'CAIXA_2024', OLD.CAIXA_2024,
            'DEMAIS_FONTES_2022', OLD.DEMAIS_FONTES_2022,
            'DEMAIS_FONTES_2023', OLD.DEMAIS_FONTES_2023,
            'DEMAIS_FONTES_2024', OLD.DEMAIS_FONTES_2024
        ),
        JSON_OBJECT(
            'id_orcamentario', NEW.id_orcamentario,
            'id_projeto2', NEW.id_projeto2,
            'uo_cod', NEW.uo_cod,
            'fonte_1', NEW.fonte_1,
            'fonte_2', NEW.fonte_2,
            'fonte_3', NEW.fonte_3,
            'fonte_4', NEW.fonte_4,
            'CAIXA_2022', NEW.CAIXA_2022,
            'CAIXA_2023', NEW.CAIXA_2023,
            'CAIXA_2024', NEW.CAIXA_2024,
            'DEMAIS_FONTES_2022', NEW.DEMAIS_FONTES_2022,
            'DEMAIS_FONTES_2023', NEW.DEMAIS_FONTES_2023,
            'DEMAIS_FONTES_2024', NEW.DEMAIS_FONTES_2024
        )
    );
END$$
DELIMITER ;



