-- STORE PROCEDURE CRIADA AFIM DE OTIMIZAR O TEMPO PARA GERAR RELATÓRIOS DE ACOMPANHAMENTOS POR UNIDADE_COORDENADORA
-- CASO A SECRETARIA DE SEGURANÇA PUBLICA SOLICITE O RELATÓRIO DOS PROJETOS CADASTRADOS EM SUA UNIDADE APENAS LANÇAR O CODIGO DA UNIDADE COORDENADORA

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
