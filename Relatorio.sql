-- STORE PROCEDURE CRIADA A FIM DE OTIMIZAR O TEMPO PARA GERAR RELATÓRIOS DE ACOMPANHAMENTOS POR UNIDADE_COORDENADORA
-- CASO A SECRETARIA DE SEGURANÇA PUBLICA SOLICITE O RELATÓRIO DOS PROJETOS CADASTRADOS EM SUA UNIDADE APENAS LANÇAR O CODIGO DA UNIDADE COORDENADORA
-- STORE PROCEDURE SUPORTA ATÉ 3 PARAMETROS OU SEJA ATÉ 3 UNIDADES COORDENADORAS, CASO PRECISE DE MAIS, ATUALIZE O SCRIPT ABAIXO.

DELIMITER $$

CREATE PROCEDURE RelatorioUO1 (
    IN Unidade_Coordenadora1 INT,
    IN Unidade_Coordenadora2 INT,
    IN Unidade_Coordenadora3 INT
)
BEGIN
    SELECT
        Q.projeto,
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
    FROM
        tb_act_qualitativo AS Q
    JOIN tb_act_orcamentario AS O ON O.id_projeto2 = Q.id_projeto
    WHERE
        O.uo_cod = Unidade_Coordenadora1
        OR O.uo_cod = Unidade_Coordenadora2
        OR O.uo_cod = Unidade_Coordenadora3;
END$$


DELIMITER ;
-- EXEMPLE
CALL RELATORIOUO1(32101, 10102, 10109)
