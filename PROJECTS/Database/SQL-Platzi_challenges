/**
  
  DESAFIOS SQL PLATZI
  
  **/

----- DESAFIO 1: El primero
--Encontrar las primeras 5 filas de una tabla

SELECT *
FROM platzi.alumnos
FETCH FIRST 5 ROW ONLY;

SELECT *
FROM platzi.alumnos
LIMIT 5;

SELECT *
FROM (
SELECT ROW_NUMBER() OVER() AS row_id, *
FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id < 6;
--WHERE row_id BETWEEN 1 and 5;
--WHERE row_id <=5; --En esta ultima linea podemos elegir que fila traer

----- DESAFIO 2: El segundo mas alto
--Traer la segunda colegiatura mas alta


SELECT DISTINCT colegiatura
FROM platzi.alumnos AS a1
WHERE 2 = (
	SELECT COUNT (DISTINCT colegiatura)
	FROM platzi.alumnos a2
	WHERE a1.colegiatura <= a2.colegiatura
); --

SELECT DISTINCT colegiatura
FROM platzi.alumnos AS a1
ORDER BY colegiatura DESC
LIMIT 1 OFFSET 1; --Dejo pasar el primer row

SELECT *
FROM platzi.alumnos AS datos_alumnos
INNER JOIN (
	SELECT DISTINCT colegiatura
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC
	LIMIT 1 OFFSET 1
) AS segunda_mayor_colegiatura
ON datos_alumnos.colegiatura = segunda_mayor_colegiatura.colegiatura;

SELECT *
FROM platzi.alumnos AS datos_alumnos
WHERE colegiatura = (
	SELECT DISTINCT colegiatura
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC
	LIMIT 1 OFFSET 1
);

--Reto, traer la segunda mitad de la table

SELECT *
FROM platzi.alumnos
WHERE id > (
	SELECT COUNT (id)/2
	FROM platzi.alumnos
);

SELECT *
FROM platzi.alumnos
OFFSET (
	SELECT COUNT(id)/2
	FROM platzi.alumnos
);

SELECT ROW_NUMBER() OVER() AS row_id, *
FROM platzi.alumnos
OFFSET (
	SELECT COUNT(*)/2
	FROM platzi.alumnos
);

----- DESAFIO 3: Seleccionar de un set de opciones

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id IN (1,3,5,10,,12,15,20);

SELECT *
FROM platzi.alumnos
WHERE id IN(
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
);

--Reto, traer todo lo que no esta en el set de opciones

SELECT *
FROM platzi.alumnos
WHERE tutor_id <> 30;

SELECT * 
FROM platzi.alumnos
WHERE id NOT IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
)

----- DESAFIO 4: En mis tiempos
--Sacar partes de la fecha en formato correspondiente (date, datetime, datestamp)

SELECT EXTRACT(YEAR FROM fecha_incorporacion) AS year_incorporacion
FROM platzi.alumnos;

SELECT DATE_PART('YEAR', fecha_incorporacion) AS year_incorporacion
FROM platzi.alumnos;

SELECT DATE_PART('YEAR', fecha_incorporacion) AS year_incorporacion,
	DATE_PART('MONTH', fecha_incorporacion) AS month_incorporacion,
	DATE_PART('DAY', fecha_incorporacion) AS day_incorporacion
FROM platzi.alumnos;

--Reto, extrar partes de la hora

SELECT DATE_PART('HOUR', fecha_incorporacion) AS hour_incorporacion,
	DATE_PART('MINUTE', fecha_incorporacion) AS minute_incorporacion,
	DATE_PART('SECOND', fecha_incorporacion) AS second_incorporacion
FROM platzi.alumnos;

SELECT EXTRACT(HOUR FROM fecha_incorporacion) AS hora_incorporacion,
		EXTRACT(MINUTE FROM fecha_incorporacion) AS minute_incorporacion,
		EXTRACT(SECOND FROM fecha_incorporacion) AS second_incorporacion
FROM platzi.alumnos;


----- DESAFIO 5: Seleccionar por año
--Usar el extrac como filtro en lugar de seleccionador

SELECT *
FROM platzi.alumnos
WHERE (EXTRACT(YEAR FROM fecha_incorporacion) = 2019);

SELECT *
FROM platzi.alumnos
WHERE (DATE_PART('YEAR', fecha_incorporacion) = 2019);

SELECT *
FROM (
	SELECT *,
	DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
	FROM platzi.alumnos) AS alumnos_con_anio
WHERE anio_incorporacion = 2019;

--Reto, alumnos que se incorporaron en Mayo del 2018

SELECT *
FROM (
	SELECT *,
	DATE_PART('YEAR', fecha_incorporacion) AS year_incorporacion,
	DATE_PART('MONTH', fecha_incorporacion) AS month_incorporacion
	FROM platzi.alumnos
) AS alumons_year_month
WHERE year_incorporacion = 2018 AND month_incorporacion = 05;

SELECT *
FROM platzi.alumnos
WHERE EXTRACT(YEAR FROM fecha_incorporacion) = 2018 AND
	EXTRACT(MONTH FROM fecha_incorporacion) = 05;
	
----- DESAFIO 6: Encontrar duplicados

--Insertar duplicado para el reto--
insert into platzi.alumnos (id, nombre, apellido, email, colegiatura, fecha_incorporacion, carrera_id, tutor_id) 
values (1001, 'Pamelina', null, 'pmylchreestrr@salon.com', 4800, '2020-04-26 10:18:51', 12, 16);

SELECT *
FROM platzi.alumnos AS ou
WHERE (
	SELECT COUNT(*) 
	FROM platzi.alumnos AS inr
	WHERE ou.id = inr.id
) > 1;

SELECT (platzi.alumnos.nombre,
		platzi.alumnos.apellido,
		platzi.alumnos.email,
		platzi.alumnos.colegiatura,
		platzi.alumnos.fecha_incorporacion,
		platzi.alumnos.carrera_id,
		platzi.alumnos.tutor_id)::text, --::text es el equivalente a CAST
		COUNT(*) 
FROM platzi.alumnos
GROUP BY platzi.alumnos.nombre,
		platzi.alumnos.apellido,
		platzi.alumnos.email,
		platzi.alumnos.colegiatura,
		platzi.alumnos.fecha_incorporacion,
		platzi.alumnos.carrera_id,
		platzi.alumnos.tutor_id
HAVING COUNT(*) >1;

SELECT *
FROM (
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
		nombre,
		apellido,
		email,
		colegiatura,
		fecha_incorporacion,
		carrera_id,
		tutor_id
		ORDER BY id ASC
	) AS row,
	*
	FROM platzi.alumnos
) AS duplicados
WHERE duplicados.row > 1;

--Reto, eliminar duplicado utilizando el ultimo metodo

DELETE
FROM platzi.alumnos 
WHERE id IN (
	SELECT id
	FROM (
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
		nombre,
		apellido,
		email,
		colegiatura,
		fecha_incorporacion,
		carrera_id,
		tutor_id
		ORDER BY id ASC
	) AS row
	FROM platzi.alumnos
) AS duplicados
WHERE duplicados.row > 1);

----- DESAFIO 7: Extraer interseccion o rangos en comun entre tutor_id y carreras_id

SELECT *
FROM platzi.alumnos
WHERE (
	SELECT 
		int4range(MIN(tutor_id), MAX(tutor_id)) *
		int4range(MIN(carrera_id), MAX(carrera_id)) --Rango entre el minimo y el maximo
	FROM platzi.alumnos
	) @> tutor_id
	AND (
	SELECT 
		int4range(MIN(tutor_id), MAX(tutor_id)) *
		int4range(MIN(carrera_id), MAX(carrera_id))
	FROM platzi.alumnos
	) @> carrera_id;

----- DESAFIO 8: Sacar maximos en una tabla

SELECT MAX(nombre)
FROM platzi.alumnos
 
---Ultima inrorporacion por carrera--
SELECT carrera_id, MAX(fecha_incorporacion)
FROM platzi.alumnos
GROUP BY carrera_id
ORDER BY carrera_id;

--Reto, sacar el minimo por tutor_id de las dos formas

SELECT MIN(nombre)
FROM platzi.alumnos

SELECT tutor_id, MIN(nombre)
FROM platzi.alumnos
GROUP BY tutor_id
ORDER BY tutor_id;

----- DESAFIO 9: Quien es el tutor de cada alumnos usando SELF JOIN

SELECT	CONCAT(a.nombre,' ',a.apellido) AS alumno,
		CONCAT(t.nombre,' ',t.apellido) AS tutor
FROM platzi.alumnos AS a
INNER JOIN platzi.alumnos AS t 
	ON a.tutor_id = t.id;

--Cuantos alumnos tiene cada tutor--
SELECT	CONCAT(t.nombre,' ',t.apellido) AS tutor,
		COUNT(*) AS alumnos_per_tutor
FROM platzi.alumnos AS a
INNER JOIN platzi.alumnos AS t 
	ON a.tutor_id = t.id
GROUP BY tutor
ORDER BY alumnos_per_tutor DESC
LIMIT 10; -- Para sacar el top 10

--Reto, promedio general de alumnos por tutor

SELECT AVG(alumnos_per_tutor) AS promedio_alumnos_tutor
FROM (
	SELECT	CONCAT(t.nombre,' ',t.apellido) AS tutor,
			COUNT(*) AS alumnos_per_tutor
	FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t 
		ON a.tutor_id = t.id
	GROUP BY tutor
) AS alumnos_tutor;


