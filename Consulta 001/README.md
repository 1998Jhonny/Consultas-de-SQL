# Consultas SQL - Proyecto Restaurante Balaji

Este es mi primer proyecto de análisis de datos utilizando SQL. Poco menos de un mes de haber comenzado en este mundo, tuve la oportunidad de trabajar con datos reales de un restaurante llamado **Balaji**.

En este repositorio comparto las consultas que utilicé para obtener insights relacionados con las ventas, productos, métodos de pago, fechas y comportamiento de los consumidores y de los colaboradores.

Los datos provienen del conjunto Restaurant Sales Report de RAJATSURANA97, disponible en Kaggle


---
# Lo que puedes aprender con este proyecto de SQL:
- **Limpieza de datos**
  - convertir fechas en múltiples formatos a un formato uniforme `STR_TO_DATE`
  - Manejo de valores nulos y datos inconsistentes `NULL`, cadenas vacías, duplicados).
  - Activar y desactivar el modo seguro `SQL_SAFE_UPDATES` 
- **Consultas útiles para análisis**
  - Renombrar tablas para facilitar la lectura
  - Uso de `GROUP BY`, `ORDER BY`, `COUNT`, `SUM` y funciones de agregación para obtener insights de ventas, productos, y comportamiento de los clientes.
  - Identificar días, meses y trimestres con mayores ventas.
  - Analizar qué productos y métodos de pago son los más usados.  
- **Aplicar lógica de negocio a una base de datos real**
  - Definir y analizar métricas claves para el departamento de ventas en base a productos más vendidos, horario con más movimiento.
  - Detectar tendencias y patrones de comportamiento del cliente a lo largo del tiempo (ventas mensuales, trimestrales, por tipo de producto).
- **Consultas avanzadas**
  - Consultas anidadas y uso de funciones de ventana `ROW_NUMBER`, `LAG` para calcular crecimiento mensual y productos más populares por trimestre.


    ![Productos_mas_vendidos_trimestral](https://github.com/user-attachments/assets/30393b4c-1e21-488f-b8b9-c56b0c88077b)   
---

# Cómo usar este repo

1. Abre los archivos `balaji_db.sql` dentro del repositorio `consultas-SQL/`.
2. Puedes ejecutarlos en un motor de base de datos compatible con MySQL.
3. Asegúrate de descargar la base de datos `Balaji Fast Food Sales.csv` que se encuentra en este repositorio o en el perfil de RAJATSURANA97 en Kaggle.
4. Lee el documento `descripción_de_datos.txt`.

---

# Contacto

Si tienes sugerencias o comentarios, Puedes escribirme por aquí, en [LinkedIn](www.linkedin.com/in/9812jhonny) o al correo 9812jhonny@gmail.com.



**Agradecimientos a RAJATSURANA97**
