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

