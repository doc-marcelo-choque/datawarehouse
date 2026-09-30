CREATE TABLE dim.Fecha
(
    fecha_sk INT PRIMARY KEY,

    fecha DATE NOT NULL UNIQUE,

    dia INT,
    mes INT,
    nombre_mes VARCHAR(20),
    trimestre INT,
    anio INT,

    es_fin_semana BIT
);