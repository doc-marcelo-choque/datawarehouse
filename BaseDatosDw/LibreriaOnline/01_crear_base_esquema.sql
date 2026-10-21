/*=============================================================================
  LibreriaOnline - Creacion de base, esquema, tablas, restricciones e indices
  Compatible con Microsoft SQL Server 2019 o superior.
  El script puede ejecutarse nuevamente: solo crea objetos que no existen.
=============================================================================*/

USE master;
GO

IF DB_ID(N'LibreriaOnline') IS NULL
BEGIN
    PRINT N'Creando base de datos LibreriaOnline...';
    CREATE DATABASE LibreriaOnline;
END
ELSE
    PRINT N'La base de datos LibreriaOnline ya existe.';
GO

USE LibreriaOnline;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'libreria')
    EXEC(N'CREATE SCHEMA libreria AUTHORIZATION dbo;');
GO

/*----------------------------- Catalogos ----------------------------------*/
IF OBJECT_ID(N'libreria.Categoria', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Categoria
    (
        CategoriaId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Categoria PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL
            CONSTRAINT UQ_Categoria_Nombre UNIQUE,
        Descripcion NVARCHAR(300) NULL,
        Activo BIT NOT NULL
            CONSTRAINT DF_Categoria_Activo DEFAULT (1)
    );
END;
GO

IF OBJECT_ID(N'libreria.Editorial', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Editorial
    (
        EditorialId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Editorial PRIMARY KEY,
        Nombre NVARCHAR(150) NOT NULL
            CONSTRAINT UQ_Editorial_Nombre UNIQUE,
        Pais NVARCHAR(100) NOT NULL,
        Activo BIT NOT NULL
            CONSTRAINT DF_Editorial_Activo DEFAULT (1)
    );
END;
GO

IF OBJECT_ID(N'libreria.Idioma', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Idioma
    (
        IdiomaId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Idioma PRIMARY KEY,
        Nombre NVARCHAR(80) NOT NULL
            CONSTRAINT UQ_Idioma_Nombre UNIQUE,
        CodigoISO NVARCHAR(10) NOT NULL
            CONSTRAINT UQ_Idioma_CodigoISO UNIQUE
    );
END;
GO

IF OBJECT_ID(N'libreria.MetodoPago', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.MetodoPago
    (
        MetodoPagoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_MetodoPago PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL
            CONSTRAINT UQ_MetodoPago_Nombre UNIQUE,
        Activo BIT NOT NULL
            CONSTRAINT DF_MetodoPago_Activo DEFAULT (1)
    );
END;
GO

IF OBJECT_ID(N'libreria.EstadoPedido', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.EstadoPedido
    (
        EstadoPedidoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_EstadoPedido PRIMARY KEY,
        Nombre NVARCHAR(50) NOT NULL
            CONSTRAINT UQ_EstadoPedido_Nombre UNIQUE,
        Descripcion NVARCHAR(250) NOT NULL
    );
END;
GO

/*----------------------------- Maestros -----------------------------------*/
IF OBJECT_ID(N'libreria.Autor', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Autor
    (
        AutorId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Autor PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(120) NOT NULL,
        Pais NVARCHAR(100) NOT NULL,
        FechaNacimiento DATE NULL,
        CONSTRAINT UQ_Autor_NombreNacimiento
            UNIQUE (Nombre, Apellido, FechaNacimiento),
        CONSTRAINT CK_Autor_FechaNacimiento
            CHECK (FechaNacimiento IS NULL OR FechaNacimiento >= '19000101')
    );
END;
GO

IF OBJECT_ID(N'libreria.Libro', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Libro
    (
        LibroId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Libro PRIMARY KEY,
        Titulo NVARCHAR(250) NOT NULL,
        ISBN NVARCHAR(20) NOT NULL
            CONSTRAINT UQ_Libro_ISBN UNIQUE,
        AutorId INT NOT NULL,
        CategoriaId INT NOT NULL,
        EditorialId INT NOT NULL,
        IdiomaId INT NOT NULL,
        FechaPublicacion DATE NOT NULL,
        Precio DECIMAL(18,2) NOT NULL,
        Costo DECIMAL(18,2) NOT NULL,
        Activo BIT NOT NULL
            CONSTRAINT DF_Libro_Activo DEFAULT (1),
        CONSTRAINT FK_Libro_Autor
            FOREIGN KEY (AutorId) REFERENCES libreria.Autor(AutorId),
        CONSTRAINT FK_Libro_Categoria
            FOREIGN KEY (CategoriaId) REFERENCES libreria.Categoria(CategoriaId),
        CONSTRAINT FK_Libro_Editorial
            FOREIGN KEY (EditorialId) REFERENCES libreria.Editorial(EditorialId),
        CONSTRAINT FK_Libro_Idioma
            FOREIGN KEY (IdiomaId) REFERENCES libreria.Idioma(IdiomaId),
        CONSTRAINT CK_Libro_Precio CHECK (Precio >= 0),
        CONSTRAINT CK_Libro_Costo CHECK (Costo >= 0 AND Costo <= Precio)
    );
END;
GO

IF OBJECT_ID(N'libreria.Cliente', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Cliente
    (
        ClienteId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Cliente PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(120) NOT NULL,
        Email NVARCHAR(200) NOT NULL
            CONSTRAINT UQ_Cliente_Email UNIQUE,
        Telefono NVARCHAR(30) NULL,
        Ciudad NVARCHAR(100) NOT NULL,
        Pais NVARCHAR(100) NOT NULL
            CONSTRAINT DF_Cliente_Pais DEFAULT (N'Bolivia'),
        FechaRegistro DATE NOT NULL
            CONSTRAINT DF_Cliente_FechaRegistro DEFAULT (CONVERT(DATE, SYSDATETIME())),
        Activo BIT NOT NULL
            CONSTRAINT DF_Cliente_Activo DEFAULT (1)
    );
END;
GO

IF OBJECT_ID(N'libreria.Sucursal', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Sucursal
    (
        SucursalId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Sucursal PRIMARY KEY,
        Nombre NVARCHAR(150) NOT NULL
            CONSTRAINT UQ_Sucursal_Nombre UNIQUE,
        Ciudad NVARCHAR(100) NOT NULL,
        Direccion NVARCHAR(250) NOT NULL,
        Activo BIT NOT NULL
            CONSTRAINT DF_Sucursal_Activo DEFAULT (1)
    );
END;
GO

IF OBJECT_ID(N'libreria.Empleado', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Empleado
    (
        EmpleadoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Empleado PRIMARY KEY,
        SucursalId INT NOT NULL,
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(120) NOT NULL,
        Cargo NVARCHAR(100) NOT NULL,
        FechaIngreso DATE NOT NULL,
        Activo BIT NOT NULL
            CONSTRAINT DF_Empleado_Activo DEFAULT (1),
        CONSTRAINT FK_Empleado_Sucursal
            FOREIGN KEY (SucursalId) REFERENCES libreria.Sucursal(SucursalId)
    );
END;
GO

/*--------------------------- Transacciones --------------------------------*/
IF OBJECT_ID(N'libreria.Pedido', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Pedido
    (
        PedidoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Pedido PRIMARY KEY,
        ClienteId INT NOT NULL,
        EmpleadoId INT NULL,
        EstadoPedidoId INT NOT NULL,
        FechaPedido DATETIME2(0) NOT NULL
            CONSTRAINT DF_Pedido_FechaPedido DEFAULT (SYSDATETIME()),
        Subtotal DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Pedido_Subtotal DEFAULT (0),
        Descuento DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Pedido_Descuento DEFAULT (0),
        Impuesto DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Pedido_Impuesto DEFAULT (0),
        Total DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Pedido_Total DEFAULT (0),
        CONSTRAINT FK_Pedido_Cliente
            FOREIGN KEY (ClienteId) REFERENCES libreria.Cliente(ClienteId),
        CONSTRAINT FK_Pedido_Empleado
            FOREIGN KEY (EmpleadoId) REFERENCES libreria.Empleado(EmpleadoId),
        CONSTRAINT FK_Pedido_Estado
            FOREIGN KEY (EstadoPedidoId) REFERENCES libreria.EstadoPedido(EstadoPedidoId),
        CONSTRAINT CK_Pedido_Importes
            CHECK (
                Subtotal >= 0 AND Descuento >= 0 AND Descuento <= Subtotal
                AND Impuesto >= 0 AND Total >= 0
                AND Total = ROUND(Subtotal - Descuento + Impuesto, 2)
            )
    );
END;
GO

IF OBJECT_ID(N'libreria.DetallePedido', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.DetallePedido
    (
        DetallePedidoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_DetallePedido PRIMARY KEY,
        PedidoId INT NOT NULL,
        LibroId INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(18,2) NOT NULL,
        Descuento DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_DetallePedido_Descuento DEFAULT (0),
        Subtotal DECIMAL(18,2) NOT NULL,
        CONSTRAINT FK_DetallePedido_Pedido
            FOREIGN KEY (PedidoId) REFERENCES libreria.Pedido(PedidoId),
        CONSTRAINT FK_DetallePedido_Libro
            FOREIGN KEY (LibroId) REFERENCES libreria.Libro(LibroId),
        CONSTRAINT UQ_DetallePedido_PedidoLibro UNIQUE (PedidoId, LibroId),
        CONSTRAINT CK_DetallePedido_Cantidad CHECK (Cantidad > 0),
        CONSTRAINT CK_DetallePedido_Precio CHECK (PrecioUnitario >= 0),
        CONSTRAINT CK_DetallePedido_Descuento
            CHECK (Descuento >= 0 AND Descuento <= Cantidad * PrecioUnitario),
        CONSTRAINT CK_DetallePedido_Subtotal
            CHECK (Subtotal = ROUND(Cantidad * PrecioUnitario - Descuento, 2))
    );
END;
GO

IF OBJECT_ID(N'libreria.Pago', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Pago
    (
        PagoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Pago PRIMARY KEY,
        PedidoId INT NOT NULL,
        MetodoPagoId INT NOT NULL,
        FechaPago DATETIME2(0) NOT NULL,
        Monto DECIMAL(18,2) NOT NULL,
        EstadoPago NVARCHAR(30) NOT NULL,
        Referencia NVARCHAR(80) NOT NULL
            CONSTRAINT UQ_Pago_Referencia UNIQUE,
        CONSTRAINT FK_Pago_Pedido
            FOREIGN KEY (PedidoId) REFERENCES libreria.Pedido(PedidoId),
        CONSTRAINT FK_Pago_MetodoPago
            FOREIGN KEY (MetodoPagoId) REFERENCES libreria.MetodoPago(MetodoPagoId),
        CONSTRAINT UQ_Pago_Pedido UNIQUE (PedidoId),
        CONSTRAINT CK_Pago_Monto CHECK (Monto >= 0),
        CONSTRAINT CK_Pago_Estado
            CHECK (EstadoPago IN (N'APROBADO', N'PENDIENTE', N'RECHAZADO', N'REEMBOLSADO'))
    );
END;
GO

IF OBJECT_ID(N'libreria.Resena', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Resena
    (
        ResenaId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Resena PRIMARY KEY,
        ClienteId INT NOT NULL,
        LibroId INT NOT NULL,
        Calificacion TINYINT NOT NULL,
        Comentario NVARCHAR(1000) NULL,
        FechaResena DATETIME2(0) NOT NULL
            CONSTRAINT DF_Resena_FechaResena DEFAULT (SYSDATETIME()),
        CONSTRAINT FK_Resena_Cliente
            FOREIGN KEY (ClienteId) REFERENCES libreria.Cliente(ClienteId),
        CONSTRAINT FK_Resena_Libro
            FOREIGN KEY (LibroId) REFERENCES libreria.Libro(LibroId),
        CONSTRAINT UQ_Resena_ClienteLibro UNIQUE (ClienteId, LibroId),
        CONSTRAINT CK_Resena_Calificacion CHECK (Calificacion BETWEEN 1 AND 5)
    );
END;
GO

IF OBJECT_ID(N'libreria.Inventario', N'U') IS NULL
BEGIN
    CREATE TABLE libreria.Inventario
    (
        InventarioId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Inventario PRIMARY KEY,
        SucursalId INT NOT NULL,
        LibroId INT NOT NULL,
        StockActual INT NOT NULL,
        StockMinimo INT NOT NULL
            CONSTRAINT DF_Inventario_StockMinimo DEFAULT (5),
        FechaActualizacion DATETIME2(0) NOT NULL
            CONSTRAINT DF_Inventario_FechaActualizacion DEFAULT (SYSDATETIME()),
        CONSTRAINT FK_Inventario_Sucursal
            FOREIGN KEY (SucursalId) REFERENCES libreria.Sucursal(SucursalId),
        CONSTRAINT FK_Inventario_Libro
            FOREIGN KEY (LibroId) REFERENCES libreria.Libro(LibroId),
        CONSTRAINT UQ_Inventario_SucursalLibro UNIQUE (SucursalId, LibroId),
        CONSTRAINT CK_Inventario_StockActual CHECK (StockActual >= 0),
        CONSTRAINT CK_Inventario_StockMinimo CHECK (StockMinimo >= 0)
    );
END;
GO

/*---------------------- Indices para ETL y consultas ----------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Libro_AutorId' AND object_id = OBJECT_ID(N'libreria.Libro'))
    CREATE INDEX IX_Libro_AutorId ON libreria.Libro(AutorId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Libro_CategoriaId' AND object_id = OBJECT_ID(N'libreria.Libro'))
    CREATE INDEX IX_Libro_CategoriaId ON libreria.Libro(CategoriaId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Libro_EditorialId' AND object_id = OBJECT_ID(N'libreria.Libro'))
    CREATE INDEX IX_Libro_EditorialId ON libreria.Libro(EditorialId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Libro_IdiomaId' AND object_id = OBJECT_ID(N'libreria.Libro'))
    CREATE INDEX IX_Libro_IdiomaId ON libreria.Libro(IdiomaId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Libro_Titulo' AND object_id = OBJECT_ID(N'libreria.Libro'))
    CREATE INDEX IX_Libro_Titulo ON libreria.Libro(Titulo);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Cliente_Ciudad' AND object_id = OBJECT_ID(N'libreria.Cliente'))
    CREATE INDEX IX_Cliente_Ciudad ON libreria.Cliente(Ciudad);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Empleado_SucursalId' AND object_id = OBJECT_ID(N'libreria.Empleado'))
    CREATE INDEX IX_Empleado_SucursalId ON libreria.Empleado(SucursalId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Pedido_ClienteId' AND object_id = OBJECT_ID(N'libreria.Pedido'))
    CREATE INDEX IX_Pedido_ClienteId ON libreria.Pedido(ClienteId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Pedido_EmpleadoId' AND object_id = OBJECT_ID(N'libreria.Pedido'))
    CREATE INDEX IX_Pedido_EmpleadoId ON libreria.Pedido(EmpleadoId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Pedido_EstadoFecha' AND object_id = OBJECT_ID(N'libreria.Pedido'))
    CREATE INDEX IX_Pedido_EstadoFecha ON libreria.Pedido(EstadoPedidoId, FechaPedido);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Pedido_FechaPedido' AND object_id = OBJECT_ID(N'libreria.Pedido'))
    CREATE INDEX IX_Pedido_FechaPedido ON libreria.Pedido(FechaPedido);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_DetallePedido_LibroId' AND object_id = OBJECT_ID(N'libreria.DetallePedido'))
    CREATE INDEX IX_DetallePedido_LibroId ON libreria.DetallePedido(LibroId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Pago_MetodoPagoId' AND object_id = OBJECT_ID(N'libreria.Pago'))
    CREATE INDEX IX_Pago_MetodoPagoId ON libreria.Pago(MetodoPagoId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Pago_FechaPago' AND object_id = OBJECT_ID(N'libreria.Pago'))
    CREATE INDEX IX_Pago_FechaPago ON libreria.Pago(FechaPago);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Resena_LibroId' AND object_id = OBJECT_ID(N'libreria.Resena'))
    CREATE INDEX IX_Resena_LibroId ON libreria.Resena(LibroId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Inventario_LibroId' AND object_id = OBJECT_ID(N'libreria.Inventario'))
    CREATE INDEX IX_Inventario_LibroId ON libreria.Inventario(LibroId);
GO

PRINT N'Estructura de LibreriaOnline preparada correctamente.';
GO
