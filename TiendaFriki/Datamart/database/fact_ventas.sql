CREATE TABLE fact.Ventas
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
        REFERENCES dim.Cliente(cliente_sk),

    CONSTRAINT FK_Ventas_Producto
        FOREIGN KEY (producto_sk)
        REFERENCES dim.Producto(producto_sk),

    CONSTRAINT FK_Ventas_Fecha
        FOREIGN KEY (fecha_sk)
        REFERENCES dim.Fecha(fecha_sk)
);