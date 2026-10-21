/*=============================================================================
  LibreriaOnline - Carga deterministica de datos de prueba
  No usa RAND(), NEWID(), servicios externos ni ORM. La misma base vacia
  siempre recibe los mismos datos. Si la carga ya existe, se omite sin error.
=============================================================================*/

USE LibreriaOnline;
GO

CREATE OR ALTER PROCEDURE libreria.CargarDatosPrueba
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (SELECT 1 FROM libreria.Pedido)
    BEGIN
        PRINT N'La carga de prueba ya existe; no se insertaron duplicados.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM libreria.Categoria)
       OR EXISTS (SELECT 1 FROM libreria.Libro)
       OR EXISTS (SELECT 1 FROM libreria.Cliente)
    BEGIN
        THROW 50001, N'Las tablas contienen una carga parcial. Use una base vacia para preservar la reproducibilidad.', 1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        /*
          SQL Server no revierte los contadores IDENTITY al deshacer una
          transaccion. Como las tablas estan vacias, se reinician para que un
          reintento posterior a cualquier error conserve los mismos IDs.
        */
        DBCC CHECKIDENT (N'libreria.DetallePedido', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Pago', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Resena', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Inventario', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Pedido', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Empleado', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Libro', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Autor', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Cliente', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Sucursal', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Categoria', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Editorial', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.Idioma', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.MetodoPago', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT (N'libreria.EstadoPedido', RESEED, 0) WITH NO_INFOMSGS;

        /*------------------------- Catalogos ------------------------------*/
        INSERT INTO libreria.Categoria (Nombre, Descripcion, Activo)
        VALUES
            (N'Ficcion', N'Novelas y relatos de ficcion contemporanea.', 1),
            (N'Tecnologia', N'Programacion, datos, infraestructura e innovacion.', 1),
            (N'Negocios', N'Administracion, finanzas y emprendimiento.', 1),
            (N'Infantil', N'Lecturas y cuentos para publico infantil.', 1),
            (N'Historia', N'Historia universal y latinoamericana.', 1),
            (N'Ciencia', N'Divulgacion y textos de ciencias.', 1),
            (N'Arte', N'Arte, diseno, fotografia y creatividad.', 1),
            (N'Biografia', N'Biografias, memorias y testimonios.', 1);

        INSERT INTO libreria.Editorial (Nombre, Pais, Activo)
        VALUES
            (N'Editorial Altiplano', N'Bolivia', 1),
            (N'Letras del Sur', N'Argentina', 1),
            (N'Planeta Andino', N'Bolivia', 1),
            (N'Ediciones Horizonte', N'Espana', 1),
            (N'Conocimiento Abierto', N'Mexico', 1),
            (N'Editorial Illimani', N'Bolivia', 1),
            (N'Paginas del Pacifico', N'Chile', 1),
            (N'Nova Ciencia', N'Colombia', 1),
            (N'TecnoLibros', N'Estados Unidos', 1),
            (N'Casa del Saber', N'Peru', 1),
            (N'Lectura Viva', N'Uruguay', 1),
            (N'Ediciones Tunari', N'Bolivia', 1);

        INSERT INTO libreria.Idioma (Nombre, CodigoISO)
        VALUES
            (N'Espanol', N'es'),
            (N'Ingles', N'en'),
            (N'Portugues', N'pt');

        INSERT INTO libreria.MetodoPago (Nombre, Activo)
        VALUES
            (N'Tarjeta de debito', 1),
            (N'Tarjeta de credito', 1),
            (N'Pago QR', 1),
            (N'Transferencia bancaria', 1),
            (N'Billetera movil', 1);

        INSERT INTO libreria.EstadoPedido (Nombre, Descripcion)
        VALUES
            (N'Pendiente', N'Pedido creado, a la espera de confirmacion o pago.'),
            (N'Pagado', N'Pago confirmado; pedido en preparacion.'),
            (N'Enviado', N'Pedido entregado al operador logistico.'),
            (N'Entregado', N'Pedido recibido por el cliente.'),
            (N'Cancelado', N'Pedido anulado y excluido de las ventas efectivas.');

        /* Listas auxiliares deterministicas para nombres y apellidos. */
        CREATE TABLE #Nombres
        (
            Numero INT IDENTITY(1,1) PRIMARY KEY,
            Nombre NVARCHAR(100) NOT NULL
        );
        INSERT INTO #Nombres (Nombre)
        VALUES (N'Alejandra'), (N'Andrea'), (N'Camila'), (N'Carla'),
               (N'Daniela'), (N'Elena'), (N'Gabriela'), (N'Jimena'),
               (N'Laura'), (N'Lucia'), (N'Natalia'), (N'Valeria'),
               (N'Alejandro'), (N'Carlos'), (N'Daniel'), (N'Diego'),
               (N'Fernando'), (N'Javier'), (N'Luis'), (N'Marco');

        CREATE TABLE #Apellidos
        (
            Numero INT IDENTITY(1,1) PRIMARY KEY,
            Apellido NVARCHAR(120) NOT NULL
        );
        INSERT INTO #Apellidos (Apellido)
        VALUES (N'Aguilar'), (N'Arce'), (N'Cabrera'), (N'Castillo'),
               (N'Choque'), (N'Condori'), (N'Flores'), (N'Garcia'),
               (N'Gutierrez'), (N'Mamani'), (N'Mendoza'), (N'Morales'),
               (N'Perez'), (N'Quispe'), (N'Rojas'), (N'Romero'),
               (N'Salazar'), (N'Sanchez'), (N'Silva'), (N'Vargas');

        /*--------------------------- Autores ------------------------------*/
        ;WITH Combinaciones AS
        (
            SELECT TOP (60)
                ROW_NUMBER() OVER (ORDER BY n.Numero, a.Numero) AS Fila,
                n.Nombre,
                a.Apellido
            FROM #Nombres AS n
            CROSS JOIN #Apellidos AS a
            ORDER BY n.Numero, a.Numero
        )
        INSERT INTO libreria.Autor (Nombre, Apellido, Pais, FechaNacimiento)
        SELECT
            Nombre,
            Apellido,
            CASE (Fila - 1) % 10
                WHEN 0 THEN N'Bolivia' WHEN 1 THEN N'Bolivia'
                WHEN 2 THEN N'Argentina' WHEN 3 THEN N'Chile'
                WHEN 4 THEN N'Peru' WHEN 5 THEN N'Mexico'
                WHEN 6 THEN N'Colombia' WHEN 7 THEN N'Espana'
                WHEN 8 THEN N'Estados Unidos' ELSE N'Reino Unido'
            END,
            DATEADD(DAY, (Fila * 811) % 20000, CONVERT(DATE, '19400101'))
        FROM Combinaciones;

        /*---------------------------- Libros ------------------------------*/
        ;WITH Numeros AS
        (
            SELECT 1 AS Numero
            UNION ALL
            SELECT Numero + 1 FROM Numeros WHERE Numero < 250
        ),
        Datos AS
        (
            SELECT
                Numero,
                CASE Numero % 12
                    WHEN 0 THEN N'El horizonte' WHEN 1 THEN N'Rutas de'
                    WHEN 2 THEN N'Introduccion a' WHEN 3 THEN N'Historias de'
                    WHEN 4 THEN N'La guia de' WHEN 5 THEN N'Cronicas del'
                    WHEN 6 THEN N'Fundamentos de' WHEN 7 THEN N'El arte de'
                    WHEN 8 THEN N'Memorias de' WHEN 9 THEN N'Viaje a'
                    WHEN 10 THEN N'Aprendiendo' ELSE N'El futuro de'
                END AS Prefijo,
                CASE Numero % 15
                    WHEN 0 THEN N'los Andes' WHEN 1 THEN N'la inteligencia artificial'
                    WHEN 2 THEN N'la empresa moderna' WHEN 3 THEN N'la imaginacion'
                    WHEN 4 THEN N'Bolivia' WHEN 5 THEN N'el universo'
                    WHEN 6 THEN N'la creatividad' WHEN 7 THEN N'vidas extraordinarias'
                    WHEN 8 THEN N'los datos' WHEN 9 THEN N'la naturaleza'
                    WHEN 10 THEN N'el liderazgo' WHEN 11 THEN N'la aventura'
                    WHEN 12 THEN N'la historia americana' WHEN 13 THEN N'la ciencia'
                    ELSE N'el conocimiento'
                END AS Tema,
                CAST(45 + ((Numero * 17) % 56) * 5 AS DECIMAL(18,2)) AS PrecioBase
            FROM Numeros
        )
        INSERT INTO libreria.Libro
        (
            Titulo, ISBN, AutorId, CategoriaId, EditorialId, IdiomaId,
            FechaPublicacion, Precio, Costo, Activo
        )
        SELECT
            CONCAT(Prefijo, N' ', Tema, N' - Edicion ', RIGHT(N'000' + CONVERT(NVARCHAR(3), Numero), 3)),
            CONCAT(N'978-99954-', RIGHT(N'000000' + CONVERT(NVARCHAR(6), Numero), 6)),
            ((Numero * 7 - 1) % 60) + 1,
            CASE
                WHEN Numero % 100 < 28 THEN 1
                WHEN Numero % 100 < 45 THEN 2
                WHEN Numero % 100 < 58 THEN 3
                WHEN Numero % 100 < 69 THEN 4
                WHEN Numero % 100 < 79 THEN 5
                WHEN Numero % 100 < 87 THEN 6
                WHEN Numero % 100 < 94 THEN 7
                ELSE 8
            END,
            ((Numero * 5 - 1) % 12) + 1,
            CASE WHEN Numero % 10 < 7 THEN 1 WHEN Numero % 10 < 9 THEN 2 ELSE 3 END,
            DATEADD(DAY, (Numero * 97) % 9000, CONVERT(DATE, '20000101')),
            PrecioBase,
            ROUND(PrecioBase * (55 + Numero % 16) / 100.0, 2),
            CASE WHEN Numero % 47 = 0 THEN 0 ELSE 1 END
        FROM Datos
        OPTION (MAXRECURSION 0);

        /*--------------------------- Clientes -----------------------------*/
        ;WITH Numeros AS
        (
            SELECT 1 AS Numero
            UNION ALL
            SELECT Numero + 1 FROM Numeros WHERE Numero < 500
        )
        INSERT INTO libreria.Cliente
        (
            Nombre, Apellido, Email, Telefono, Ciudad, Pais,
            FechaRegistro, Activo
        )
        SELECT
            n.Nombre,
            CONCAT(a1.Apellido, N' ', a2.Apellido),
            CONCAT(N'cliente', RIGHT(N'0000' + CONVERT(NVARCHAR(4), x.Numero), 4), N'@correo.bo'),
            CONCAT(N'+591 7', RIGHT(N'0000000' + CONVERT(NVARCHAR(7), 1000000 + (x.Numero * 7919) % 8999999), 7)),
            CASE
                WHEN x.Numero % 100 < 22 THEN N'La Paz'
                WHEN x.Numero % 100 < 37 THEN N'El Alto'
                WHEN x.Numero % 100 < 55 THEN N'Cochabamba'
                WHEN x.Numero % 100 < 76 THEN N'Santa Cruz'
                WHEN x.Numero % 100 < 83 THEN N'Sucre'
                WHEN x.Numero % 100 < 89 THEN N'Tarija'
                WHEN x.Numero % 100 < 94 THEN N'Oruro'
                WHEN x.Numero % 100 < 98 THEN N'Potosi'
                ELSE N'Trinidad'
            END,
            N'Bolivia',
            DATEADD(DAY, (x.Numero * 29) % 730, CONVERT(DATE, '20220101')),
            CASE WHEN x.Numero % 41 = 0 THEN 0 ELSE 1 END
        FROM Numeros AS x
        JOIN #Nombres AS n ON n.Numero = ((x.Numero * 7 - 1) % 20) + 1
        JOIN #Apellidos AS a1 ON a1.Numero = ((x.Numero * 11 - 1) % 20) + 1
        JOIN #Apellidos AS a2 ON a2.Numero = ((x.Numero * 17 - 1) % 20) + 1
        OPTION (MAXRECURSION 0);

        /*---------------------- Sucursales y empleados --------------------*/
        INSERT INTO libreria.Sucursal (Nombre, Ciudad, Direccion, Activo)
        VALUES
            (N'Centro de distribucion La Paz', N'La Paz', N'Av. Mariscal Santa Cruz 1250', 1),
            (N'Sucursal Cochabamba', N'Cochabamba', N'Av. Ballivian 620', 1),
            (N'Sucursal Santa Cruz', N'Santa Cruz', N'Av. Monseñor Rivero 410', 1),
            (N'Sucursal Sucre', N'Sucre', N'Calle Aniceto Arce 230', 1);

        ;WITH Numeros AS
        (
            SELECT 1 AS Numero
            UNION ALL
            SELECT Numero + 1 FROM Numeros WHERE Numero < 20
        )
        INSERT INTO libreria.Empleado
            (SucursalId, Nombre, Apellido, Cargo, FechaIngreso, Activo)
        SELECT
            ((x.Numero - 1) / 5) + 1,
            n.Nombre,
            CONCAT(a1.Apellido, N' ', a2.Apellido),
            CASE (x.Numero - 1) % 5
                WHEN 0 THEN N'Jefe de sucursal'
                WHEN 1 THEN N'Coordinador de pedidos'
                WHEN 2 THEN N'Asesor de ventas'
                WHEN 3 THEN N'Encargado de almacen'
                ELSE N'Atencion al cliente'
            END,
            DATEADD(DAY, (x.Numero * 83) % 1450, CONVERT(DATE, '20200101')),
            CASE WHEN x.Numero = 20 THEN 0 ELSE 1 END
        FROM Numeros AS x
        JOIN #Nombres AS n ON n.Numero = ((x.Numero * 3 - 1) % 20) + 1
        JOIN #Apellidos AS a1 ON a1.Numero = ((x.Numero * 5 - 1) % 20) + 1
        JOIN #Apellidos AS a2 ON a2.Numero = ((x.Numero * 9 - 1) % 20) + 1
        OPTION (MAXRECURSION 0);

        /* Cada una de las cuatro sucursales recibe los 250 libros. */
        INSERT INTO libreria.Inventario
            (SucursalId, LibroId, StockActual, StockMinimo, FechaActualizacion)
        SELECT
            s.SucursalId,
            l.LibroId,
            CASE
                WHEN l.LibroId <= 25 THEN 35 + (s.SucursalId * 11 + l.LibroId * 7) % 90
                WHEN l.LibroId <= 100 THEN 15 + (s.SucursalId * 13 + l.LibroId * 5) % 55
                ELSE 2 + (s.SucursalId * 17 + l.LibroId * 3) % 30
            END,
            CASE WHEN l.LibroId <= 25 THEN 15 WHEN l.LibroId <= 100 THEN 8 ELSE 4 END,
            DATETIME2FROMPARTS(2026, 9, 30, 23, 0, 0, 0, 0)
        FROM libreria.Sucursal AS s
        CROSS JOIN libreria.Libro AS l;

        /*--------------------------- Pedidos ------------------------------*/
        DECLARE @Pendiente INT = (SELECT EstadoPedidoId FROM libreria.EstadoPedido WHERE Nombre = N'Pendiente');
        DECLARE @Pagado INT = (SELECT EstadoPedidoId FROM libreria.EstadoPedido WHERE Nombre = N'Pagado');
        DECLARE @Enviado INT = (SELECT EstadoPedidoId FROM libreria.EstadoPedido WHERE Nombre = N'Enviado');
        DECLARE @Entregado INT = (SELECT EstadoPedidoId FROM libreria.EstadoPedido WHERE Nombre = N'Entregado');
        DECLARE @Cancelado INT = (SELECT EstadoPedidoId FROM libreria.EstadoPedido WHERE Nombre = N'Cancelado');

        ;WITH Numeros AS
        (
            SELECT 1 AS Numero
            UNION ALL
            SELECT Numero + 1 FROM Numeros WHERE Numero < 3000
        )
        INSERT INTO libreria.Pedido
        (
            ClienteId, EmpleadoId, EstadoPedidoId, FechaPedido,
            Subtotal, Descuento, Impuesto, Total
        )
        SELECT
            CASE
                WHEN Numero <= 1800 THEN ((Numero * 37 - 1) % 180) + 1
                WHEN Numero <= 2120 THEN Numero - 1620
                ELSE ((Numero * 43 - 1) % 180) + 1
            END,
            CASE WHEN Numero % 4 = 0 THEN NULL ELSE ((Numero * 7 - 1) % 20) + 1 END,
            CASE
                WHEN Numero % 100 < 6 THEN @Cancelado
                WHEN Numero % 100 < 13 THEN @Pendiente
                WHEN Numero % 100 < 25 THEN @Pagado
                WHEN Numero % 100 < 42 THEN @Enviado
                ELSE @Entregado
            END,
            DATEADD(
                MINUTE,
                540 + (Numero * 7919) % 780,
                CONVERT(DATETIME2(0), DATEADD(DAY, (Numero * 37) % 1004, CONVERT(DATE, '20240101')))
            ),
            0, 0, 0, 0
        FROM Numeros
        OPTION (MAXRECURSION 0);

        /*
          Se generan 7.500 detalles: dos por pedido y un tercero para los
          pedidos impares. Los libros 1-25 son muy vendidos, 26-100 tienen
          demanda media y 101-250 tienen demanda baja.
        */
        ;WITH Lineas AS
        (
            SELECT 1 AS Linea UNION ALL SELECT 2 UNION ALL SELECT 3
        ),
        Seleccion AS
        (
            SELECT
                p.PedidoId,
                x.Linea,
                CASE
                    WHEN x.Linea = 1
                        THEN ((p.PedidoId * 13 + x.Linea * 7 - 1) % 25) + 1
                    WHEN x.Linea = 2 AND p.PedidoId % 10 < 6
                        THEN ((p.PedidoId * 13 + x.Linea * 7 - 1) % 25) + 1
                    WHEN x.Linea = 2 AND p.PedidoId % 10 < 9
                        THEN 26 + ((p.PedidoId * 17 + x.Linea * 11 - 1) % 75)
                    WHEN x.Linea = 2
                        THEN 101 + ((p.PedidoId * 19 + x.Linea * 13 - 1) % 150)
                    WHEN p.PedidoId % 10 < 4
                        THEN ((p.PedidoId * 13 + x.Linea * 7 - 1) % 25) + 1
                    WHEN p.PedidoId % 10 < 8
                        THEN 26 + ((p.PedidoId * 17 + x.Linea * 11 - 1) % 75)
                    ELSE 101 + ((p.PedidoId * 19 + x.Linea * 13 - 1) % 150)
                END AS LibroId
            FROM libreria.Pedido AS p
            CROSS JOIN Lineas AS x
            WHERE x.Linea <= 2 + p.PedidoId % 2
        ),
        Importes AS
        (
            SELECT
                s.PedidoId,
                s.LibroId,
                1 + CASE WHEN s.LibroId <= 25 AND (s.PedidoId + s.Linea) % 9 = 0 THEN 2
                         WHEN (s.PedidoId + s.Linea) % 7 = 0 THEN 1 ELSE 0 END AS Cantidad,
                l.Precio AS PrecioUnitario,
                CASE WHEN (s.PedidoId + s.Linea) % 13 = 0 THEN CAST(0.10 AS DECIMAL(5,2))
                     WHEN (s.PedidoId + s.Linea) % 7 = 0 THEN CAST(0.05 AS DECIMAL(5,2))
                     ELSE CAST(0.00 AS DECIMAL(5,2)) END AS TasaDescuento
            FROM Seleccion AS s
            JOIN libreria.Libro AS l ON l.LibroId = s.LibroId
        )
        INSERT INTO libreria.DetallePedido
            (PedidoId, LibroId, Cantidad, PrecioUnitario, Descuento, Subtotal)
        SELECT
            PedidoId,
            LibroId,
            Cantidad,
            PrecioUnitario,
            ROUND(Cantidad * PrecioUnitario * TasaDescuento, 2),
            ROUND(Cantidad * PrecioUnitario * (1 - TasaDescuento), 2)
        FROM Importes;

        /* Recalculo matematico de cabeceras a partir de todos sus detalles. */
        ;WITH Totales AS
        (
            SELECT
                PedidoId,
                CAST(SUM(Cantidad * PrecioUnitario) AS DECIMAL(18,2)) AS SubtotalBruto,
                CAST(SUM(Descuento) AS DECIMAL(18,2)) AS DescuentoTotal
            FROM libreria.DetallePedido
            GROUP BY PedidoId
        )
        UPDATE p
        SET
            Subtotal = t.SubtotalBruto,
            Descuento = t.DescuentoTotal,
            Impuesto = ROUND((t.SubtotalBruto - t.DescuentoTotal) * 0.13, 2),
            Total = ROUND((t.SubtotalBruto - t.DescuentoTotal) * 1.13, 2)
        FROM libreria.Pedido AS p
        JOIN Totales AS t ON t.PedidoId = p.PedidoId;

        /*---------------------------- Pagos -------------------------------*/
        INSERT INTO libreria.Pago
            (PedidoId, MetodoPagoId, FechaPago, Monto, EstadoPago, Referencia)
        SELECT
            p.PedidoId,
            ((p.PedidoId * 7 - 1) % 5) + 1,
            DATEADD(MINUTE, 15 + p.PedidoId % 1800, p.FechaPedido),
            p.Total,
            CASE
                WHEN e.Nombre IN (N'Pagado', N'Enviado', N'Entregado') THEN N'APROBADO'
                WHEN e.Nombre = N'Cancelado' AND p.PedidoId % 2 = 0 THEN N'REEMBOLSADO'
                WHEN e.Nombre = N'Cancelado' THEN N'RECHAZADO'
                ELSE N'PENDIENTE'
            END,
            CONCAT(N'PG-', CONVERT(CHAR(4), YEAR(p.FechaPedido)), N'-',
                   RIGHT(N'000000' + CONVERT(NVARCHAR(6), p.PedidoId), 6))
        FROM libreria.Pedido AS p
        JOIN libreria.EstadoPedido AS e ON e.EstadoPedidoId = p.EstadoPedidoId
        WHERE e.Nombre IN (N'Pagado', N'Enviado', N'Entregado', N'Cancelado')
           OR (e.Nombre = N'Pendiente' AND p.PedidoId % 2 = 0);

        /* Solo clientes con pedidos entregados pueden dejar una resena. */
        ;WITH ComprasEntregadas AS
        (
            SELECT
                p.ClienteId,
                d.LibroId,
                MAX(p.FechaPedido) AS UltimaCompra
            FROM libreria.Pedido AS p
            JOIN libreria.EstadoPedido AS e
              ON e.EstadoPedidoId = p.EstadoPedidoId AND e.Nombre = N'Entregado'
            JOIN libreria.DetallePedido AS d ON d.PedidoId = p.PedidoId
            GROUP BY p.ClienteId, d.LibroId
        ),
        Elegidas AS
        (
            SELECT TOP (400)
                ClienteId,
                LibroId,
                UltimaCompra,
                ROW_NUMBER() OVER (ORDER BY (ClienteId * 31 + LibroId * 17) % 10007, ClienteId, LibroId) AS Fila
            FROM ComprasEntregadas
            ORDER BY (ClienteId * 31 + LibroId * 17) % 10007, ClienteId, LibroId
        )
        INSERT INTO libreria.Resena
            (ClienteId, LibroId, Calificacion, Comentario, FechaResena)
        SELECT
            ClienteId,
            LibroId,
            CASE WHEN Fila % 20 = 0 THEN 2
                 WHEN Fila % 9 = 0 THEN 3
                 WHEN Fila % 3 = 0 THEN 4 ELSE 5 END,
            CASE WHEN Fila % 20 = 0 THEN N'La experiencia pudo ser mejor.'
                 WHEN Fila % 9 = 0 THEN N'Buena lectura, aunque esperaba un poco mas.'
                 WHEN Fila % 3 = 0 THEN N'Muy recomendable y con excelente contenido.'
                 ELSE N'Excelente libro; supero mis expectativas.' END,
            DATEADD(DAY, 3 + Fila % 18, UltimaCompra)
        FROM Elegidas;

        COMMIT TRANSACTION;

        PRINT N'Carga deterministica completada correctamente.';
        SELECT N'Categoria' AS Tabla, COUNT_BIG(*) AS Registros FROM libreria.Categoria
        UNION ALL SELECT N'Editorial', COUNT_BIG(*) FROM libreria.Editorial
        UNION ALL SELECT N'Idioma', COUNT_BIG(*) FROM libreria.Idioma
        UNION ALL SELECT N'MetodoPago', COUNT_BIG(*) FROM libreria.MetodoPago
        UNION ALL SELECT N'EstadoPedido', COUNT_BIG(*) FROM libreria.EstadoPedido
        UNION ALL SELECT N'Autor', COUNT_BIG(*) FROM libreria.Autor
        UNION ALL SELECT N'Libro', COUNT_BIG(*) FROM libreria.Libro
        UNION ALL SELECT N'Cliente', COUNT_BIG(*) FROM libreria.Cliente
        UNION ALL SELECT N'Sucursal', COUNT_BIG(*) FROM libreria.Sucursal
        UNION ALL SELECT N'Empleado', COUNT_BIG(*) FROM libreria.Empleado
        UNION ALL SELECT N'Pedido', COUNT_BIG(*) FROM libreria.Pedido
        UNION ALL SELECT N'DetallePedido', COUNT_BIG(*) FROM libreria.DetallePedido
        UNION ALL SELECT N'Pago', COUNT_BIG(*) FROM libreria.Pago
        UNION ALL SELECT N'Resena', COUNT_BIG(*) FROM libreria.Resena
        UNION ALL SELECT N'Inventario', COUNT_BIG(*) FROM libreria.Inventario;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

EXEC libreria.CargarDatosPrueba;
GO
