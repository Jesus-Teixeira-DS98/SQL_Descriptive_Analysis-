-- Análise Descritiva das Vendas de 2018 -- 

-- Criando View com Join para trazer o percentual de imposto para cada produto --
CREATE VIEW [Retail_Data_2018] AS
SELECT *
FROM dbo.Base bb
LEFT OUTER JOIN dbo.Imposto ii
ON bb.product_department = ii.departamento

--- Iniciando A Análise do Faturamento ---

-- Faturamento Total -- 
SELECT SUM(receita_bruta) AS "Faturamento Total"
FROM Retail_Data_2018
-- 3450272.14

-- Ticket Médio --
SELECT AVG(receita_bruta) AS "Ticket Médio"
FROM Retail_Data_2018
-- 39.55

-- Desvio Padrão do Faturamento -- 
SELECT STDEVP(receita_bruta) AS "STD"
FROM Retail_Data_2018
-- 50.08

-- Faturamento por Departamento --
SELECT product_department, SUM(receita_bruta) AS Faturamento, (SUM(receita_bruta)/3450272.14) * 100  AS Percentual          
FROM Retail_Data_2018
WHERE receita_bruta >= 0
GROUP BY product_department
ORDER BY faturamento DESC 
-- Departamento de móveis foi o mais lucrativo do período, Representando 81% do faturamento. -- 

-- Visto que o Departamento de Móveis é o mais lucrativo, resolvi expandir a análise por categoria --
SELECT product_category, Sum(receita_bruta) AS "Faturamento por Categoria"
FROM Retail_Data_2018 
WHERE product_department = 'Móveis' 
GROUP BY product_category 
ORDER BY Sum(receita_bruta) desc 
-- Top 3 Categorias: Sala de Estar, Quarto e Sala de Jantar -- 

-- Ticket Médio por Departamento que está acima da média.  -- 
SELECT product_department, AVG(receita_bruta) AS "Ticket Médio"
FROM Retail_Data_2018
GROUP BY product_department 
HAVING AVG(receita_bruta) > (SELECT AVG(receita_bruta) FROM Retail_Data_2018)
ORDER BY AVG(receita_bruta) DESC
-- O departamento de móveis tem o ticket médio de 57.06, superior a média geral de receita. Resultado já esperado, visto que é a maior fonte de receita --

--- O departamento de Móveis foi responsável pela maior parte (81%) do faturamento da empresa no ano de 2018 --
--- Com ticket média alto e vendas concentradas nas categorias Sala de Estar, Quarto e Sala de Jantar ---


--- Análise do Perfil dos Clientes--- 

-- Recorrência por cliente --
CREATE VIEW [Recorrência] AS
SELECT cliente_id, COUNT(cliente_id) AS Recorrencia_Cliente
FROM Retail_Data_2018 
GROUP BY cliente_id

-- Recorrência Média -- 
SELECT AVG(Recorrencia_Cliente) AS "Recorrência Média"
FROM Recorrência
-- 3 -- Em média, cada cliente faz 3 Compras por Ano neste e-commerce --

-- Genêro -- 
SELECT cliente_sexo, SUM(receita_bruta) AS "Receita por Genêro", (SUM(receita_bruta)/3450272.14) *100  AS Percentual 
FROM Retail_Data_2018
GROUP BY cliente_sexo
ORDER BY SUM(receita_bruta) DESC
-- 57% das compras foram feitas por mulheres, além disso 2,37% dos cadastros não tem informação de genêro --

-- Estados --
SELECT  entrega_estado, SUM(receita_bruta) AS "Faturamento por Estado", COUNT(entrega_estado) AS "Número de Pedidos"
FROM Retail_Data_2018
GROUP BY entrega_estado
ORDER BY SUM(receita_bruta) DESC
-- São paulo é o Estado com o maior faturamento e maior Número de pedidos --

--- Com base nas médias encontradas, poderia dizer que a persona dessa Loja é: Mulher de São Paulo que compra móveis até 3 vzs por ano. --