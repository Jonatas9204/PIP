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




  

  














