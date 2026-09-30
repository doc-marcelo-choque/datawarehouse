USE dw_tienda_friki;
GO

CREATE TABLE dim.Cliente
(
    cliente_sk INT IDENTITY(1,1) PRIMARY KEY,

    cliente_id_origen INT NOT NULL UNIQUE,

    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    genero VARCHAR(30),

    ciudad VARCHAR(100),
    departamento VARCHAR(100),
    pais VARCHAR(100),

    fecha_registro DATE,
    activo BIT,

    fecha_carga DATETIME2 DEFAULT SYSDATETIME()
);