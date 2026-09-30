CREATE TABLE dim.Producto
(
    producto_sk INT IDENTITY(1,1) PRIMARY KEY,

    producto_id_origen INT NOT NULL UNIQUE,

    codigo VARCHAR(30),
    nombre VARCHAR(150),

    precio DECIMAL(12,2),
    costo DECIMAL(12,2),

    activo BIT,

    fecha_carga DATETIME2 DEFAULT SYSDATETIME()
);