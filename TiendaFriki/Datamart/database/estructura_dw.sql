CREATE DATABASE dw_tienda_friki;
GO

USE dw_tienda_friki;
GO

USE dw_tienda_friki;
GO

CREATE TABLE dbo.DimCliente
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

CREATE TABLE dbo.DimProducto
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

CREATE TABLE dbo.DimFecha
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

CREATE TABLE dbo.FactVentas
(
    venta_sk BIGINT IDENTITY(1,1) PRIMARY KEY,

    venta_id_origen BIGINT NOT NULL,
    detalle_venta_id_origen BIGINT NOT NULL UNIQUE,

    cliente_sk INT NOT NULL,
    producto_sk INT NOT NULL,
    fecha_sk INT NOT NULL,

    cantidad INT NOT NULL,

    precio_unitario DECIMAL(12,2),
    costo_unitario DECIMAL(12,2),
    descuento DECIMAL(12,2),

    importe_venta DECIMAL(14,2),
    costo_total DECIMAL(14,2),
    utilidad DECIMAL(14,2),

    fecha_carga DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Ventas_Cliente
        FOREIGN KEY (cliente_sk)
        REFERENCES dbo.DimCliente(cliente_sk),

    CONSTRAINT FK_Ventas_Producto
        FOREIGN KEY (producto_sk)
        REFERENCES dbo.DimProducto(producto_sk),

    CONSTRAINT FK_Ventas_Fecha
        FOREIGN KEY (fecha_sk)
        REFERENCES dbo.DimFecha(fecha_sk)
);