CREATE DATABASE IF NOT EXISTS RESTAURANTE;
USE restaurante;

#Mostrar tablas
SHOW TABLES;

#Cuando hay espacios entre los nombres se debe utilizar "`" para poder llamar
SELECT * FROM `balaji fast food sales` ; 

#Cambiar el nombre de la tabla
RENAME TABLE `balaji fast food sales` TO balajifastfood;

SELECT COUNT(date) FROM balajifastfood;

DESCRIBE balajifastfood;
#Se puede evidenciar que en la columna date hay datos en diferentes formatos día-mes-año y mes-día-año también "-" y "/" dando a lugar un formato de tipo text

#Cambiar el formato de fecha

#Validar si hay claves primarias
SHOW KEYS FROM balajifastfood WHERE Key_name = 'PRIMARY';

#Establecer columna order_id como clave primaria
ALTER TABLE balajifastfood
ADD PRIMARY KEY (order_id);

UPDATE balajifastfood
SET date = STR_TO_DATE(date, '%d-%m-%Y')
WHERE date LIKE '%-%';

UPDATE balajifastfood
SET date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE date LIKE '%/%';

#Cambiar el tipo de columna a formato fecha
ALTER TABLE balajifastfood
MODIFY COLUMN date DATE;

#Revisar toda la información de la tabla
SELECT *
FROM balajifastfood 
ORDER BY date ASC;

# Revisar valores nulos o vacíos
SELECT 
  SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS faltantes_order_id,
  SUM(CASE WHEN item_name IS NULL OR item_name = '' THEN 1 ELSE 0 END) AS faltantes_item_name,
  SUM(CASE WHEN item_price IS NULL THEN 1 ELSE 0 END) AS faltantes_item_price,
  SUM(CASE WHEN transaction_amount IS NULL THEN 1 ELSE 0 END) AS faltantes_transaction_amount,
  SUM(CASE WHEN transaction_type IS NULL THEN 1 ELSE 0 END) AS faltantes_transaction_type
FROM balajifastfood;

# Valores duplicados en order_id
SELECT order_id, COUNT(*) as conteo
FROM balajifastfood
GROUP BY order_id
HAVING COUNT(*) > 1;

#Estandarizar texto para cada columna
SELECT DISTINCT time_of_sale FROM balajifastfood;

#Se comprueba que hay cadenas vacías '' y se deben pasar a NULL

#Reemplaza '' por NULL en la columna transaction_type
UPDATE balajifastfood
SET transaction_type = NULL
WHERE TRIM(transaction_type) = '';

#Total tipo de pago (NULL, CASH Y ONLINE)
SELECT
  COUNT(*) AS total_registros,
  SUM(CASE WHEN transaction_type IS NULL THEN 1 ELSE 0 END) AS nulos,
  SUM(CASE WHEN transaction_type = 'Cash' THEN 1 ELSE 0 END) AS cash,
  SUM(CASE WHEN transaction_type = 'Online' THEN 1 ELSE 0 END) AS en_linea
FROM balajifastfood;

#Total Cantidades, ordenes y Ventas
SELECT SUM(quantity) AS Cantidad,
COUNT(order_id) AS Total_Ordenes, 
SUM(item_price * quantity) As Ventas_Totales
FROM balajifastfood;

#Iniciar con el Analisis exploratorio de datos
#Analisis de ventas

#Cantidad total de ordenes 1000
SELECT COUNT(DISTINCT order_id) AS total_ordenes 
FROM balajifastfood;

#Día con más ventas: 2023-03-19: 3.350 USD día con menores ventas 2022-09-23
SELECT date,
SUM(transaction_amount) AS Ventas_Totales
FROM balajifastfood
GROUP BY date
ORDER BY Ventas_Totales DESC
LIMIT 1;

#Total de ventas 275.230
SELECT SUM(transaction_amount) AS Total_ventas
FROM balajifastfood;

#Total cantidades vendidas 8.162
SELECT SUM(quantity) AS Cantidades_Vendidas
FROM balajifastfood;

# Año con mayor facturación: 2022 con 195.575 USD y 79.655 USD
SELECT YEAR(date),
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY YEAR(date)
ORDER BY Total_Ventas DESC;

#Mes más vendido del 2022, 9 (Septiembre) con 21.340 USD en ventas
SELECT MONTH(date) AS Mes,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
WHERE YEAR(date) = 2022
GROUP BY MONTH(date)
ORDER BY Total_Ventas DESC
LIMIT 1;

#Mes más vendido del 2023, 3 (marzo) con 20.400 USD en ventas
SELECT MONTH(date) AS Mes,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
WHERE YEAR(date) = 2023
GROUP BY MONTH(date)
ORDER BY Total_Ventas DESC
LIMIT 1;

#Ordenar los productos más vendidos 1-Sandwich $65.820 2-Frankie $57.500 3-Cold coffee $54.440
SELECT item_name AS Nombre_producto,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY item_name
ORDER BY Total_Ventas DESC;
 
 #preferencias del cliente en artículos Fastfood $188.840 y Beverages $86.390
SELECT item_type AS Tipo_de_producto,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY item_type
ORDER BY Total_Ventas DESC;

#Cuál genero vendió más: hombres 143.440 USD - Mujeres 131.790 USD
SELECT received_by AS Genero,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY received_by
ORDER BY Total_Ventas DESC;

#Tipo de pago: efectivo: 132.840 USD y Online: 110.595 USD no registrado: 31.795 USD
SELECT transaction_type AS Tipo_de_pago,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY Tipo_de_pago
ORDER BY Total_Ventas DESC;

#Frecuencia de uso para el método de pago Cash: 476 veces, online 417
SELECT transaction_type AS Tipo_de_pago,
COUNT(*) AS Frecuencia_de_uso,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY Tipo_de_pago
ORDER BY Frecuencia_de_uso;

#Horario con mayores ventas y menores ventas Night: 62.075 USD -  Midnight: 50.725 USD 
SELECT time_of_sale AS Horario,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
GROUP BY Horario
ORDER BY Total_Ventas DESC;

#Popularidad de los productos en diferentes momentos del día
SELECT 
  time_of_sale AS Horario,
  item_name AS Producto,
  COUNT(*) AS Frecuencia_Ventas,
  SUM(transaction_amount) AS Total_Recaudado
FROM balajifastfood
GROUP BY Horario, Producto
ORDER BY Frecuencia_Ventas DESC;

#Que genero trabaja más en la noche: Hombres 299 y Mujeres 306
SELECT received_by AS Genero,
COUNT(order_id) AS Total_Ordenes
FROM balajifastfood
WHERE time_of_sale IN ('Night', 'Evening', 'Midnight')
GROUP BY received_by
ORDER BY Total_Ordenes;

# El día con mayores ventas que genero facturo más Hombres: 2.180 usd Mujeres: 1.170
SELECT received_by AS Genero,
SUM(transaction_amount) AS Total_Ventas
FROM balajifastfood
WHERE DATE = "2023-03-19"
GROUP BY received_by
ORDER BY Total_Ventas DESC;

#Ventas por cada mes
SELECT DATE_FORMAT(date, '%Y-%m') AS mes,
SUM(transaction_amount) AS ventas_mensuales
FROM balajifastfood
GROUP BY mes
ORDER BY mes;

#Incremento % mensual de las ventas
WITH ventas_mensuales AS (
  SELECT
    DATE_FORMAT(date, '%Y-%m') AS mes,
    SUM(transaction_amount) AS ventas_mensuales
  FROM balajifastfood
  GROUP BY DATE_FORMAT(date, '%Y-%m')
)
SELECT
  mes,
  ventas_mensuales,
  ROUND((ventas_mensuales - LAG(ventas_mensuales) OVER (ORDER BY mes)) 
        / LAG(ventas_mensuales) OVER (ORDER BY mes) * 100, 2) AS incremento_mensual
FROM ventas_mensuales
ORDER BY mes;


#Comportamiento de las ventas trimestrales
SELECT 
  YEAR(date) AS anio,
  QUARTER(date) AS trimestre,
  SUM(transaction_amount) AS ventas_trimestrales
FROM balajifastfood
GROUP BY YEAR(date), QUARTER(date)
ORDER BY anio, trimestre;

SELECT * FROM balajifastfood;

#Productos con mayores ventas trimestralmente
SELECT 
  CONCAT(anio, '-Q', trimestre) AS periodo,
  item_name AS producto_mas_vendido,
  ventas_producto
FROM (
  SELECT 
    YEAR(date) AS anio,
    QUARTER(date) AS trimestre,
    item_name,
    SUM(transaction_amount) AS ventas_producto,
    ROW_NUMBER() OVER (PARTITION BY YEAR(date), QUARTER(date) 
                       ORDER BY SUM(transaction_amount) DESC) AS rn
  FROM balajifastfood
  GROUP BY YEAR(date), QUARTER(date), item_name
) AS productos
WHERE rn = 1
ORDER BY anio, trimestre;
