

-- Checagem Manual da Integridade do Banco de Dados e tabelas --
-- Prompt de comando, execute como administrador --
-- Como boa prática rodar comando semanalmente

mysqlcheck pip -u root -p

-- Em casos de erros encontrados, prosseguir com o procedimento abaixo:
 
-- rodar mysqlcheck novamente primeiramente com as opcoes --repair e --quick, se o problema persistir
-- rodar novamente mysqlcheck com a opcao apenas --repair e se o problema persistir e nao tiver backup atualizado
-- rodar novamente mysqlcheck com as opcoes --repair e --force, e neste caso podera ter perda de dados nas tabelas
-- para o mysql tentar recuperar o que puder para liberar a tabela para uso.


Options:
--check or -c
--extended or -e para checagem mais aprofundadas e demoradas nas tabelas
--medium-check or -m
--quick or -q para checagem apenas dos indices. Nao ira checar as tabelas.
--repair or -r
--analyze or -a
--optimize or -o 