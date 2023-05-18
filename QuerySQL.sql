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


SELECT Q.PROJETO, s.status, q.UNIDADE_COORDENADORA, o.fonte_1, o.caixa_2022, e.valor_atendido  FROM pip.tb_act_orcamentario o
join tb_act_qualitativo Q on Q.ID_PROJETO = O.ID_PROJETO2
left join tb_act_execucao E on e.id_projeto1 = q.id_projeto
left join tb_act_status S on s.id_projeto = e.id_projeto1;

alter view VW_DESAFIO
AS
SELECT Q.PROJETO, s.status, q.UNIDADE_COORDENADORA, o.fonte_1, o.caixa_2022, e.valor_atendido  FROM pip.tb_act_orcamentario o
join tb_act_qualitativo Q on Q.ID_PROJETO = O.ID_PROJETO2
left join tb_act_execucao E on e.id_projeto1 = q.id_projeto
left join tb_act_status S on s.id_projeto = e.id_projeto1;
SELECT * FROM VW_DESAFIO;

-- todos os projetos estruturantes que estão em execução

select q.PROJETO, q.UNIDADE_COORDENADORA, q.escopo, q.AREA_ESTRATEGICA, q.PROJETO_ESTRUTURANTE, S.STATUS, o.FONTE_1, o.CAIXA_2022, o.CAIXA_2023, 
o.CAIXA_2024, o.DEMAIS_FONTES_2022, o.DEMAIS_FONTES_2023, o.DEMAIS_FONTES_2024 from tb_act_qualitativo as q
join tb_act_orcamentario as o on o.ID_PROJETO2 = q.ID_PROJETO
JOIN tb_act_status as s on  S.ID_PROJETO = O.ID_PROJETO2
where q.projeto_estruturante = 'Sim' and s.status = 'Em Execução';

SELECT UNIDADE_COORDENADORA, AREA_ESTRATEGICA FROM tb_act_qualitativo;

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


CREATE TABLE auditoria_PIP (
	id int auto_increment primary key,
	id_projeto2 int not null,
	projeto varchar(100) not null,
	FONTE_1 INT,
	CAIXA_2023 DECIMAL(12,2),
	DEMAIS_FONTES_2023 decimal(12,2),
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
		INSERT INTO auditoria_PIP(
	id,
	id_projeto2,
	projeto,
	FONTE_1,
	CAIXA_2023,
	DEMAIS_FONTES_2023,
	updatedat,
	usuario,
	operation
)
VALUES (
	new.id_projeto2,
	new.FONTE_1,
	new.CAIXA_2023,
	new.DEMAIS_FONTES_2023,
	now(),
	user(),
	'INS' );
END$$ 

DELIMITER ;
			 





