-- An�lise Descritiva das Vendas de 2018 -- 

-- Criando View com Join para trazer o percentual de imposto para cada produto --
CREATE VIEW [Retail_Data_2018] AS
SELECT *
FROM dbo.Base bb
LEFT OUTER JOIN dbo.Imposto ii
ON bb.product_department = ii.departamento

--- Iniciando A An�lise do Faturamento ---

-- Faturamento Total -- 
SELECT SUM(receita_bruta) AS "Faturamento Total"
FROM Retail_Data_2018
-- 3450272.14

-- Ticket M�dio --
SELECT AVG(receita_bruta) AS "Ticket M�dio"
FROM Retail_Data_2018
-- 39.55

-- Desvio Padr�o do Faturamento -- 
SELECT STDEVP(receita_bruta) AS "STD"
FROM Retail_Data_2018
-- 50.08

-- Faturamento por Departamento --
SELECT product_department, SUM(receita_bruta) AS Faturamento, (SUM(receita_bruta)/3450272.14) * 100  AS Percentual          
FROM Retail_Data_2018
WHERE receita_bruta >= 0
GROUP BY product_department
ORDER BY faturamento DESC 
-- Departamento de m�veis foi o mais lucrativo do per�odo, Representando 81% do faturamento. -- 

-- Visto que o Departamento de M�veis � o mais lucrativo, resolvi expandir a an�lise por categoria --
SELECT product_category, Sum(receita_bruta) AS "Faturamento por Categoria"
FROM Retail_Data_2018 
WHERE product_department = 'M�veis' 
GROUP BY product_category 
ORDER BY Sum(receita_bruta) desc 
-- Top 3 Categorias: Sala de Estar, Quarto e Sala de Jantar -- 

-- Ticket M�dio por Departamento que est� acima da m�dia.  -- 
SELECT product_department, AVG(receita_bruta) AS "Ticket M�dio"
FROM Retail_Data_2018
GROUP BY product_department 
HAVING AVG(receita_bruta) > (SELECT AVG(receita_bruta) FROM Retail_Data_2018)
ORDER BY AVG(receita_bruta) DESC
-- O departamento de m�veis tem o ticket m�dio de 57.06, superior a m�dia geral de receita. Resultado j� esperado, visto que � a maior fonte de receita --

--- O departamento de M�veis foi respons�vel pela maior parte (81%) do faturamento da empresa no ano de 2018 --
--- Com ticket m�dia alto e vendas concentradas nas categorias Sala de Estar, Quarto e Sala de Jantar ---


--- An�lise do Perfil dos Clientes--- 

-- Recorr�ncia por cliente --
CREATE VIEW [Recorr�ncia] AS
SELECT cliente_id, COUNT(cliente_id) AS Recorrencia_Cliente
FROM Retail_Data_2018 
GROUP BY cliente_id

-- Recorr�ncia M�dia -- 
SELECT AVG(Recorrencia_Cliente) AS "Recorr�ncia M�dia"
FROM Recorr�ncia
-- 3 -- Em m�dia, cada cliente faz 3 Compras por Ano neste e-commerce --

-- Gen�ro -- 
SELECT cliente_sexo, SUM(receita_bruta) AS "Receita por Gen�ro", (SUM(receita_bruta)/3450272.14) *100  AS Percentual 
FROM Retail_Data_2018
GROUP BY cliente_sexo
ORDER BY SUM(receita_bruta) DESC
-- 57% das compras foram feitas por mulheres, al�m disso 2,37% dos cadastros n�o tem informa��o de gen�ro --

-- Estados --
SELECT  entrega_estado, SUM(receita_bruta) AS "Faturamento por Estado", COUNT(entrega_estado) AS "N�mero de Pedidos"
FROM Retail_Data_2018
GROUP BY entrega_estado
ORDER BY SUM(receita_bruta) DESC
-- S�o paulo � o Estado com o maior faturamento e maior N�mero de pedidos --

-- Faixa Et�ria -- 
SELECT SUM(receita_bruta) AS 'receita bruta', 
	CASE
		WHEN cliente_idade Between 0 And 20 Then '0 At� 20 Anos'
		WHEN cliente_idade Between 21 And 40 Then '21 At� 40 Anos'
		WHEN cliente_idade > 40 THEN 'Maior que 60'
		ELSE 'outros' 
	END AS "faixa_etaria"
FROM Retail_Data_2018
GROUP BY CASE
		WHEN cliente_idade Between 0 And 20 Then '0 At� 20 Anos'
		WHEN cliente_idade Between 21 And 40 Then '21 At� 40 Anos'
		WHEN cliente_idade > 40 THEN 'Maior que 60'
		ELSE 'outros' 
	END 
ORDER BY SUM(receita_bruta) DESC

--- Com base nas m�dias encontradas, poderia dizer que a persona dessa Loja �: Mulher de S�o Paulo que tem entre 21 e 40 anos e compra m�veis at� 3 vzs por ano. --


--- Analisando o Faturamento Ao longo do Ano -- 

-- Faturamento Bruto Mensal --
SELECT	SUM(receita_bruta) AS 'Faturamento' , DATEPART(MONTH, data_venda) AS M�s
FROM Retail_Data_2018
GROUP BY DATEPART(MONTH, data_venda)
ORDER BY DATEPART(MONTH, data_venda) ASC 
-- O ano tem uma tend�ncia de alta ao longo do meses -- 
-- Qu�o mais pr�ximo do fim do ano, maior o faturamento, o pico de vendas ocorre em novembro.-- 

-- An�lise de Vendas por trimestre -- 
SELECT	SUM(receita_bruta) AS 'Faturamento' , DATEPART(QUARTER, data_venda) AS Trimestre
FROM Retail_Data_2018
GROUP BY DATEPART(QUARTER, data_venda)
ORDER BY DATEPART(QUARTER, data_venda) ASC 
-- Como visto acima, o quarto trimestre � o que teve o maior faturamento -- 

--- Com base na an�lise acima, sabe-se que o setor de m�veis � o mais lucrativo, al�m disso as vendas aumentam ao longo do ano, principalmente no �ltimo trimestre -- 
--- Black Friday e datas festivas s�o excelente pontos para se aproveitar, o perfil de cliente encontrado deve ser usado para ADS -- 
