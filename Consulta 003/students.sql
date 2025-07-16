CREATE DATABASE IF NOT EXISTS STUDENTS;
USE STUDENTS;
SHOW TABLES;

RENAME TABLE `students social media addiction` TO ADDICTION;

SELECT * FROM ADDICTION;

#-Que genero pasa más tiempo frente a redes sociales
SELECT GENDER, 
	COUNT(GENDER) AS Conteo,
    ROUND(SUM(Avg_Daily_Usage_Hours), 2) AS Total_Hours,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS AVG_Hours_Student
FROM ADDICTION
GROUP BY GENDER
ORDER BY Total_Hours DESC;

#EDA AVG_DAILY_USAGE_HOURS
SELECT 
  COUNT(*) AS N,
  MIN(Avg_Daily_Usage_Hours) AS Minimum,
  MAX(Avg_Daily_Usage_Hours) AS Maximum,
  ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Average_SM,
  ROUND(STDDEV(Avg_Daily_Usage_Hours), 2) AS Standard_Deviation
FROM 
  ADDICTION;

#-Es posible que a mayor grado de educación resulte un menor uso de redes sociales
SELECT Academic_Level, 
	COUNT(Academic_Level) AS Total_Students, 
	ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Hours_SM,
    ROUND(AVG(Addicted_Score), 2) AS Addicted_Score,
    ROUND(AVG(Mental_Health_Score), 2) AS Mental_Health_Score
FROM ADDICTION
GROUP BY Academic_Level;

#-Los paises con peor nivel de desarrollo frecuenta más el uso de redes sociales
SELECT * FROM ADDICTION
WHERE COUNTRY IN ('Vatican City', 'Kosovo');

#Mostrar tablas
SHOW TABLES;

SELECT * FROM ADDICTION;
#EDA PIB_PER_EUR
  SELECT
	COUNT(*) AS N,
    MIN(PIB_PER_EUR) AS Minimum,
    MAX(PIB_PER_EUR) AS Maximum,
    ROUND(AVG(PIB_PER_EUR), 2) AS AVG_PIBPER,
    ROUND(STDDEV(PIB_PER_EUR), 2) AS Standard_Deviation
FROM
	COUNTRY_DATA;

DESCRIBE COUNTRY_DATA;

#Cambiar el nombre de las columnas
ALTER TABLE COUNTRY_DATA
CHANGE COLUMN ï»¿Country COUNTRY VARCHAR(50),
CHANGE COLUMN FECHA DATE_YEAR YEAR,
CHANGE COLUMN `PIB Per Capita â‚¬` PIB_PER_EUR INT,
CHANGE COLUMN `Var. anual PIB Per Capita` VAR_PIB_PER DECIMAL(10,2);

#- Desarrollo del país y horas que pasan en Redes Soc.
SELECT 
  a.Country,
  AVG(a.Avg_Daily_Usage_Hours) AS Avg_Usage_Hours,
  c.PIB_PER_EUR
FROM 
  ADDICTION a
JOIN 
  COUNTRY_DATA c
    ON a.Country = c.COUNTRY
GROUP BY 
  a.Country, c.PIB_PER_EUR
ORDER BY 
  c.PIB_PER_EUR ASC;

#-Los paises con peor nivel de desarrollo frecuenta más el uso de redes sociales
SELECT 
  a.Country,
  AVG(a.Avg_Daily_Usage_Hours) AS Avg_Usage_Hours,
  c.PIB_PER_EUR
FROM 
  ADDICTION a
JOIN 
  COUNTRY_DATA c
    ON a.Country = c.COUNTRY
GROUP BY 
  a.Country, c.PIB_PER_EUR
HAVING 
  AVG(a.Avg_Daily_Usage_Hours) > (
    SELECT AVG(Avg_Daily_Usage_Hours) FROM ADDICTION
  )
ORDER BY 
  c.PIB_PER_EUR ASC;

#-Cual es el uso recomendado de horas frente a pantallas al día, y cual es el promedio para dicho estudio
#https://research.iastate.edu/2023/06/15/iowa-state-researchers-find-cutting-back-on-social-media-reduces-anxiety-depression-loneliness/
SELECT 
Gender, 
Academic_Level, 
AVG(Avg_Daily_Usage_Hours) AS AVG_Hours
FROM ADDICTION
GROUP BY Gender, Academic_Level;

#Redes sociales más utilizadas
SELECT 
Most_Used_Platform, 
COUNT(*) AS Total_Records,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ADDICTION), 2) AS percentage
FROM ADDICTION
GROUP BY Most_Used_Platform
ORDER BY Total_Records DESC;

#Redes sociales menos conocidas
SELECT Country, Most_Used_Platform, COUNT(*) AS Total_Records FROM ADDICTION
WHERE Most_Used_Platform IN ('WeChat', 'LINE', 'KakaoTalk', 'VKontakte')
GROUP BY Most_Used_Platform, COUNTRY;

#Agrupación por plataforma
#- Descripción del tipo de estudiante
SELECT 
  Most_Used_Platform,
  COUNT(*) AS Num_Students,
  ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS AVG_Daily_Use,
  ROUND(AVG(Addicted_Score), 2) AS AVG_Adiction,
  ROUND(AVG(Mental_Health_Score), 2) AS AVG_Mental_Health,
  ROUND(AVG(CASE WHEN Affects_Academic_Performance = 'Yes' THEN 1 ELSE 0 END) * 100, 1) AS Perct_Academic_Impact,
  ROUND(AVG(Age), 0) AS AVG_Students
FROM 
  ADDICTION
GROUP BY 
  Most_Used_Platform
ORDER BY 
  AVG_Daily_Use DESC;

SELECT 
  Most_Used_Platform,
  Academic_Level,
  COUNT(*) AS Students,
  ROUND(AVG(Addicted_Score), 2) AS AVG_Adiction
FROM 
  ADDICTION
GROUP BY 
  Most_Used_Platform, Academic_Level
ORDER BY 
  Most_Used_Platform, AVG_Adiction DESC;

#-Impacto de mayor uso de redes sociales en el rendimiento académico, para este caso se realizará por quartiles
-- Q1
SELECT Avg_Daily_Usage_Hours AS Q1
FROM ADDICTION
ORDER BY Avg_Daily_Usage_Hours
LIMIT 1 OFFSET 175;

-- Q2
SELECT Avg_Daily_Usage_Hours AS Q2
FROM ADDICTION
ORDER BY Avg_Daily_Usage_Hours
LIMIT 1 OFFSET 351;

-- Q3
SELECT Avg_Daily_Usage_Hours AS Q3
FROM ADDICTION
ORDER BY Avg_Daily_Usage_Hours
LIMIT 1 OFFSET 527;

SELECT 
  CASE 
    WHEN Avg_Daily_Usage_Hours <= 4.1 THEN 'Q1 - Low'
    WHEN Avg_Daily_Usage_Hours <= 4.8 THEN 'Q2 - Medium-Low'
    WHEN Avg_Daily_Usage_Hours <= 5.8 THEN 'Q3 - Medium-High'
    ELSE 'Q4 - High'
  END AS Quartile_Usage,
  COUNT(*) AS Total_Students,
  SUM(CASE WHEN Affects_Academic_Performance = 'Yes' THEN 1 ELSE 0 END) AS Affected,
  ROUND(SUM(CASE WHEN Affects_Academic_Performance = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Percent_Affected
FROM 
  ADDICTION
GROUP BY 
  Quartile_Usage
ORDER BY 
  Quartile_Usage;

#-Como afectan emocionalmente las redes sociales a los hombres y a las mujeres de acuerdo al número de horas al día
SELECT 
  Gender,
  CASE
    WHEN Avg_Daily_Usage_Hours < 2 THEN '0-2h'
    WHEN Avg_Daily_Usage_Hours < 4 THEN '2-4h'
    WHEN Avg_Daily_Usage_Hours < 6 THEN '4-6h'
    WHEN Avg_Daily_Usage_Hours < 8 THEN '6-8h'
    ELSE '8h+'
  END AS Range_Hours,
  COUNT(*) AS Total_Students,
  ROUND(AVG(Mental_Health_Score), 2) AS AVG_Health_Score
FROM 
  ADDICTION
GROUP BY 
  Gender, Range_Hours
ORDER BY 
  Gender, Range_Hours;

#Estudio de la variable horas
SELECT
    MIN(Avg_Daily_Usage_Hours) AS Minimum,
    MAX(Avg_Daily_Usage_Hours) AS Maximum,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Avg_Use_SM,
    ROUND(STDDEV(Avg_Daily_Usage_Hours), 2) AS Standard_Deviation
FROM
	ADDICTION;

#-Aquellas adolecentes que se encuentran solteros tienen mayor riesgo de salud mental y de puntuación adictiva al celular
SELECT Relationship_Status AS relationship,
ROUND(AVG(Mental_Health_Score), 2) AS Health_Score,
ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Hours_Use_RS,
ROUND(AVG(Addicted_Score), 2) AS Level_Adiction,
ROUND(AVG(Sleep_Hours_Per_Night), 2) AS Sleep_Hours
FROM ADDICTION
GROUP BY Relationship_Status;

#-Cuantos confilctos han tenido con familiares, amigos o parejas debido a su uso de las redes sociales
SELECT 
GENDER,
Relationship_Status, 
ROUND(AVG(Conflicts_Over_Social_Media), 2) AS CONFLICTS 
FROM ADDICTION
GROUP BY GENDER, Relationship_Status;

SELECT Most_Used_Platform, 
ROUND(AVG(Conflicts_Over_Social_Media), 2) AS CONFLICTS
FROM ADDICTION
GROUP BY Most_Used_Platform;

SELECT MIN(Conflicts_Over_Social_Media) AS MIN,
MAX(Conflicts_Over_Social_Media) AS MAX
FROM ADDICTION;

# más horas = más conflictos
SELECT 
  ROUND(Avg_Daily_Usage_Hours) AS Hours,
  ROUND(AVG(Conflicts_Over_Social_Media), 2) AS AVG_Conflicts
FROM ADDICTION
GROUP BY Hours
ORDER BY Hours;

SELECT 
  Gender,
  CASE 
    WHEN Conflicts_Over_Social_Media <= 1 THEN 'low'
    WHEN Conflicts_Over_Social_Media <= 3 THEN 'Moderate'
    ELSE 'High'
  END AS Level_Conflict,
  COUNT(*) AS Total_Students
FROM 
  ADDICTION
GROUP BY 
  Gender, Level_Conflict
ORDER BY 
  Gender, Level_Conflict;
  
SELECT
ROUND(Age) AS AGE,
ROUND(AVG(Conflicts_Over_Social_Media), 2) AS CONFLICTS
FROM ADDICTION
GROUP BY Age
ORDER BY Age ASC;

#-Un mayor consumo de  horas refleja causas de insomnio
SELECT 
ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Hours_SM,
ROUND(Sleep_Hours_Per_Night) AS Hours_sleep,
COUNT(*) AS Total_Students
FROM ADDICTION
GROUP BY Hours_sleep
ORDER BY Hours_SM DESC;
