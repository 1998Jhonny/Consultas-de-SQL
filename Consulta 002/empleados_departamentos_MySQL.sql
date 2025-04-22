USE empleadoss_departamentoss;

SELECT * FROM empleados;
SELECT * FROM departamentos;

DESCRIBE empleados;
# Seleccionar las comisiones y el salario
SELECT comisionE, salemp FROM empleados ORDER BY comisione;

SELECT comisione AS Comisiones FROM empleados;

#10 Obtener el valor total a pagar que resulta de sumar a los empleados del departamento 3000 una bonificación de 500.000, en orden alfabético del empleado
SELECT 
nomEmp AS Nombre_empleado,
SUM(salEmp + 500000) AS Valor_a_Pagar
FROM empleados
WHERE codDepto = 3000
GROUP BY codDepto, nomemp
ORDER BY nomEmp ASC;

#11. Obtener la lista de los empleados que ganan una comisión superior a su sueldo.
SELECT 
nomEmp AS Nombre_empleado,
salEmp AS Sueldo,
comisionE AS Comision
FROM empleados
WHERE comisionE > salEmp
ORDER BY Comision DESC;

#12. Listar los empleados cuya comisión es menor o igual que el 30% de su sueldo.
SELECT 
nomEmp AS Nombre_empleado,
salEmp AS Sueldo,
comisionE AS Comision
FROM empleados
WHERE comisionE <= (salEmp*0.3)
ORDER BY Comision DESC;

#14. Hallar el salario y la comisión de aquellos empleados cuyo número de documento de identidad es superior al '19.709.802'
SELECT 
nDIEmp,
salEmp AS Sueldo,
comisionE AS Comision
FROM empleados
WHERE nDIEmp > "19.709.802";

#16. Listar el salario, la comisión, el salario total (salario + comisión), documento de identidad del empleado y nombre, de aquellos empleados que tienen comisión superior a 1.000.000, ordenar el informe por el número del documento de identidad
SELECT nDIEmp, salemp, comisione, (salemp + comisione) AS "Salario Total"
FROM empleados
WHERE comisione > 1000000
ORDER BY comisione ASC;

#18. Hallar los empleados cuyo nombre no contiene la cadena "MA"
SELECT nomemp
FROM empleados
WHERE LOWER(nomemp) NOT LIKE "%ma%";

#20. Obtener el nombre y el departamento de los empleados con cargo 'Secretaria' o 'Vendedor', que no trabajan en el departamento de “PRODUCCION”, cuyo salario es superior a $1.000.000, ordenados por fecha de incorporación.
SELECT e.nomemp, d.nombreDpto
FROM empleados e, departamentos d
WHERE e.codDepto = d.codDepto AND LOWER(e.cargoe) = "secretaria" AND LOWER(e.cargoe) = "vendedor"
AND LOWER(d.nombreDpto) <> "producción" AND e.salEmp > 1000000 
ORDER BY e.fecIncorporacion;

#21. Obtener información de los empleados cuyo nombre tiene exactamente 11 caracteres
SELECT * 
FROM empleados
WHERE CHAR_LENGTH(nomemp) < 11;

#22. Obtener información de los empleados cuyo nombre tiene al menos 11 caracteres
SELECT e.nomemp, e.salemp, d.nombredpto 
FROM empleados e, departamentos d
WHERE e.codDepto = d.codDepto AND LOWER(e.nomemp) LIKE "m%" AND (e.salemp < 800000 OR e.comisione > 0) 
AND LOWER(d.nombreDpto) <> "ventas";

#24. Obtener los nombres, salarios y comisiones de los empleados que reciben un salario situado entre la mitad de la comisión la propia comisión
SELECT nomemp, salemp, comisione
FROM empleados
WHERE salemp BETWEEN (comisione/2) AND comisione;

#25. Mostrar el salario más alto de la empresa.
SELECT nomemp, salEmp 
FROM empleados
WHERE salEmp = (SELECT MAX(salEmp) FROM empleados);

#26. Mostrar cada una de las comisiones y el número de empleados que las reciben. Solo si tiene comision.
SELECT comisione, COUNT(*)
FROM empleados
GROUP BY comisione
HAVING comisione > 0;

# 27. Mostrar el nombre del último empleado de la lista por orden alfabético.
SELECT nomemp FROM empleados
ORDER BY nomemp DESC
LIMIT 1;

#28. Hallar el salario más alto, el más bajo y la diferencia entre ellos
SELECT MAX(salemp) AS 'Salario Mayor', MIN(salemp) AS 'Salario menor',MAX(salemp) - MIN(salemp) AS Diferencia FROM empleados;

#29. Mostrar el número de empleados de sexo femenino y de sexo masculino, por departamento.
SELECT codDepto AS Departamento, sexEmp AS genero, COUNT(*) AS Total
FROM empleados
GROUP BY Departamento, genero;

#30. Hallar el salario promedio por departamento.
SELECT d.nombreDpto AS Departamento, AVG(e.salemp) AS Salario_Promedio
FROM empleados e, departamentos d
WHERE e.codDepto = d.codDepto
GROUP BY d.nombreDpto;

SELECT codDepto AS Departamento, AVG(salemp) AS Salario_Promedio
FROM empleados
GROUP BY codDepto;

#31. Mostrar la lista de los empleados cuyo salario es mayor o igual que el promedio de la empresa. Ordenarlo por departamento.
SELECT nomEmp AS "Lista empleados", salEmp AS "Salario >= promedio" 
FROM empleados
WHERE salEmp >= (SELECT AVG(salEmp) FROM empleados);

#32. Hallar los departamentos que tienen más de tres empleados. Mostrar el número de empleados de esos departamentos.
SELECT codDepto AS Departamento,
COUNT(*) AS Numero_empleados
FROM empleados
GROUP BY codDepto
HAVING Numero_empleados > 3;

SELECT e.codDepto AS Departamento,
d.nombreDpto AS Nombre_departamento,
COUNT(*) AS Numero_empleados
FROM empleados e, departamentos d
WHERE e.codDepto = d.codDepto
GROUP BY d.codDepto
HAVING Numero_empleados > 3;

#33. Mostrar el código y nombre de cada jefe, junto al número de empleados que dirige. Solo los que tengan mas de dos empleados (2 incluido)
SELECT j.nDIEmp, 
j.nomEmp,
COUNT(*) AS Numero_empleados
FROM empleados e, empleados j
WHERE e.jefeID = j.nDIEmp
GROUP BY j.nDIEmp, j.nomEmp  
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC;

#34. Hallar los departamentos que no tienen empleados
SELECT e.codDepto,
d.nombreDpto,
COUNT(*) AS Numero_de_empleados
FROM departamentos d, empleados e 
WHERE e.codDepto = d.codDepto
GROUP BY e.codDepto, d.nombreDpto
HAVING COUNT(*) <= 2;

#35. Mostrar el nombre del departamento cuya suma de salarios sea la más alta, indicando el valor de la suma.
SELECT 
d.nombreDpto,
SUM(e.salEmp) AS "Salario mas alto"
FROM empleados e, departamentos d
WHERE e.codDepto = d.codDepto
GROUP BY d.nombreDpto
ORDER BY SUM(e.salEmp) DESC
LIMIT 1;