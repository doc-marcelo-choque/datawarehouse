/*=============================================================================
  LibreriaOnline - Pruebas de integridad, coherencia matematica y negocio
  El script finaliza con error si encuentra alguna inconsistencia.
=============================================================================*/

USE LibreriaOnline;
GO
SET NOCOUNT ON;

DECLARE @Errores TABLE
(
    Prueba NVARCHAR(200) NOT NULL,
    FilasConError BIGINT NOT NULL
);

/* Cantidades minimas y exactas de la carga propuesta. */
INSERT INTO @Errores
SELECT N'Cantidad de categorias distinta de 8', ABS(COUNT_BIG(*) - 8)
FROM libreria.Categoria HAVING COUNT_BIG(*) <> 8
UNION ALL
SELECT N'Cantidad de editoriales distinta de 12', ABS(COUNT_BIG(*) - 12)
FROM libreria.Editorial HAVING COUNT_BIG(*) <> 12
UNION ALL
SELECT N'Cantidad de idiomas distinta de 3', ABS(COUNT_BIG(*) - 3)
FROM libreria.Idioma HAVING COUNT_BIG(*) <> 3
UNION ALL
SELECT N'Cantidad de metodos de pago distinta de 5', ABS(COUNT_BIG(*) - 5)
FROM libreria.MetodoPago HAVING COUNT_BIG(*) <> 5
UNION ALL
SELECT N'Cantidad de estados de pedido distinta de 5', ABS(COUNT_BIG(*) - 5)
FROM libreria.EstadoPedido HAVING COUNT_BIG(*) <> 5
UNION ALL
SELECT N'Cantidad de autores distinta de 60', ABS(COUNT_BIG(*) - 60)
FROM libreria.Autor HAVING COUNT_BIG(*) <> 60
UNION ALL
SELECT N'Cantidad de libros distinta de 250', ABS(COUNT_BIG(*) - 250)
FROM libreria.Libro HAVING COUNT_BIG(*) <> 250
UNION ALL
SELECT N'Cantidad de clientes distinta de 500', ABS(COUNT_BIG(*) - 500)
FROM libreria.Cliente HAVING COUNT_BIG(*) <> 500
UNION ALL
SELECT N'Cantidad de sucursales distinta de 4', ABS(COUNT_BIG(*) - 4)
FROM libreria.Sucursal HAVING COUNT_BIG(*) <> 4
UNION ALL
SELECT N'Cantidad de empleados distinta de 20', ABS(COUNT_BIG(*) - 20)
FROM libreria.Empleado HAVING COUNT_BIG(*) <> 20
UNION ALL
SELECT N'Cantidad de pedidos distinta de 3000', ABS(COUNT_BIG(*) - 3000)
FROM libreria.Pedido HAVING COUNT_BIG(*) <> 3000
UNION ALL
SELECT N'Cantidad de detalles distinta de 7500', ABS(COUNT_BIG(*) - 7500)
FROM libreria.DetallePedido HAVING COUNT_BIG(*) <> 7500
UNION ALL
SELECT N'Cantidad de resenas distinta de 400', ABS(COUNT_BIG(*) - 400)
FROM libreria.Resena HAVING COUNT_BIG(*) <> 400
UNION ALL
SELECT N'Cantidad de inventarios distinta de 1000', ABS(COUNT_BIG(*) - 1000)
FROM libreria.Inventario HAVING COUNT_BIG(*) <> 1000;

/* Rango temporal requerido: enero de 2024 a septiembre de 2026. */
INSERT INTO @Errores
SELECT N'Pedidos fuera del rango temporal permitido', COUNT_BIG(*)
FROM libreria.Pedido
WHERE FechaPedido < '20240101' OR FechaPedido >= '20261001'
HAVING COUNT_BIG(*) > 0;

/* Cada uno de los 33 meses debe contener pedidos. */
;WITH Meses AS
(
    SELECT CONVERT(DATE, '20240101') AS InicioMes
    UNION ALL
    SELECT DATEADD(MONTH, 1, InicioMes)
    FROM Meses
    WHERE InicioMes < '20260901'
)
INSERT INTO @Errores
SELECT N'Meses sin pedidos entre enero de 2024 y septiembre de 2026', COUNT_BIG(*)
FROM Meses AS m
WHERE NOT EXISTS
(
    SELECT 1
    FROM libreria.Pedido AS p
    WHERE p.FechaPedido >= m.InicioMes
      AND p.FechaPedido < DATEADD(MONTH, 1, m.InicioMes)
)
HAVING COUNT_BIG(*) > 0
OPTION (MAXRECURSION 0);

/* Formula exacta de cada linea. */
INSERT INTO @Errores
SELECT N'Detalles con calculo incorrecto', COUNT_BIG(*)
FROM libreria.DetallePedido
WHERE Subtotal <> ROUND(Cantidad * PrecioUnitario - Descuento, 2)
   OR Cantidad <= 0 OR PrecioUnitario < 0 OR Descuento < 0
HAVING COUNT_BIG(*) > 0;

/* Cabecera contra agregados de detalle e impuesto del 13 %. */
;WITH Totales AS
(
    SELECT
        PedidoId,
        CAST(SUM(Cantidad * PrecioUnitario) AS DECIMAL(18,2)) AS Bruto,
        CAST(SUM(Descuento) AS DECIMAL(18,2)) AS Descuento,
        CAST(SUM(Subtotal) AS DECIMAL(18,2)) AS Neto
    FROM libreria.DetallePedido
    GROUP BY PedidoId
)
INSERT INTO @Errores
SELECT N'Pedidos con importes incoherentes', COUNT_BIG(*)
FROM libreria.Pedido AS p
JOIN Totales AS t ON t.PedidoId = p.PedidoId
WHERE p.Subtotal <> t.Bruto
   OR p.Descuento <> t.Descuento
   OR t.Neto <> p.Subtotal - p.Descuento
   OR p.Impuesto <> ROUND(t.Neto * 0.13, 2)
   OR p.Total <> ROUND(t.Neto + p.Impuesto, 2)
HAVING COUNT_BIG(*) > 0;

/* Ningun pedido puede quedar sin detalles. */
INSERT INTO @Errores
SELECT N'Pedidos sin detalles', COUNT_BIG(*)
FROM libreria.Pedido AS p
WHERE NOT EXISTS
    (SELECT 1 FROM libreria.DetallePedido AS d WHERE d.PedidoId = p.PedidoId)
HAVING COUNT_BIG(*) > 0;

/* Pagado, enviado y entregado exigen un unico pago aprobado por el total. */
INSERT INTO @Errores
SELECT N'Pedidos pagados/enviados/entregados sin pago aprobado coherente', COUNT_BIG(*)
FROM libreria.Pedido AS p
JOIN libreria.EstadoPedido AS e ON e.EstadoPedidoId = p.EstadoPedidoId
LEFT JOIN libreria.Pago AS pg
  ON pg.PedidoId = p.PedidoId
 AND pg.EstadoPago = N'APROBADO'
 AND pg.Monto = p.Total
WHERE e.Nombre IN (N'Pagado', N'Enviado', N'Entregado')
  AND pg.PagoId IS NULL
HAVING COUNT_BIG(*) > 0;

/* Pendientes y cancelados nunca deben figurar con pago aprobado. */
INSERT INTO @Errores
SELECT N'Pedidos pendientes/cancelados con pago aprobado', COUNT_BIG(*)
FROM libreria.Pedido AS p
JOIN libreria.EstadoPedido AS e ON e.EstadoPedidoId = p.EstadoPedidoId
JOIN libreria.Pago AS pg ON pg.PedidoId = p.PedidoId
WHERE e.Nombre IN (N'Pendiente', N'Cancelado')
  AND pg.EstadoPago = N'APROBADO'
HAVING COUNT_BIG(*) > 0;

/* Las resenas corresponden a un libro comprado en un pedido entregado. */
INSERT INTO @Errores
SELECT N'Resenas sin compra entregada del libro', COUNT_BIG(*)
FROM libreria.Resena AS r
WHERE NOT EXISTS
(
    SELECT 1
    FROM libreria.Pedido AS p
    JOIN libreria.EstadoPedido AS e
      ON e.EstadoPedidoId = p.EstadoPedidoId AND e.Nombre = N'Entregado'
    JOIN libreria.DetallePedido AS d
      ON d.PedidoId = p.PedidoId AND d.LibroId = r.LibroId
    WHERE p.ClienteId = r.ClienteId
)
HAVING COUNT_BIG(*) > 0;

/* Las claves foraneas ya impiden huerfanos; estas pruebas los hacen visibles. */
INSERT INTO @Errores
SELECT N'Detalles huerfanos', COUNT_BIG(*)
FROM libreria.DetallePedido AS d
LEFT JOIN libreria.Pedido AS p ON p.PedidoId = d.PedidoId
LEFT JOIN libreria.Libro AS l ON l.LibroId = d.LibroId
WHERE p.PedidoId IS NULL OR l.LibroId IS NULL
HAVING COUNT_BIG(*) > 0
UNION ALL
SELECT N'Pagos huerfanos', COUNT_BIG(*)
FROM libreria.Pago AS pg
LEFT JOIN libreria.Pedido AS p ON p.PedidoId = pg.PedidoId
LEFT JOIN libreria.MetodoPago AS m ON m.MetodoPagoId = pg.MetodoPagoId
WHERE p.PedidoId IS NULL OR m.MetodoPagoId IS NULL
HAVING COUNT_BIG(*) > 0
UNION ALL
SELECT N'Inventarios huerfanos', COUNT_BIG(*)
FROM libreria.Inventario AS i
LEFT JOIN libreria.Sucursal AS s ON s.SucursalId = i.SucursalId
LEFT JOIN libreria.Libro AS l ON l.LibroId = i.LibroId
WHERE s.SucursalId IS NULL OR l.LibroId IS NULL
HAVING COUNT_BIG(*) > 0;

IF EXISTS (SELECT 1 FROM @Errores)
BEGIN
    SELECT Prueba, FilasConError FROM @Errores ORDER BY Prueba;
    THROW 51000, N'La validacion de LibreriaOnline encontro errores.', 1;
END;

PRINT N'TODAS LAS VALIDACIONES FUERON SUPERADAS.';

/* Resumen util para comprobar el conjunto cargado. */
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

SELECT
    MIN(FechaPedido) AS PrimerPedido,
    MAX(FechaPedido) AS UltimoPedido,
    COUNT_BIG(*) AS Pedidos,
    COUNT(DISTINCT CONVERT(CHAR(7), FechaPedido, 120)) AS MesesConPedidos
FROM libreria.Pedido;

SELECT
    e.Nombre AS EstadoPedido,
    COUNT_BIG(*) AS Cantidad,
    CAST(SUM(CASE WHEN e.Nombre IN (N'Pagado', N'Enviado', N'Entregado')
                  THEN p.Total ELSE 0 END) AS DECIMAL(18,2)) AS VentaEfectivaBOB
FROM libreria.Pedido AS p
JOIN libreria.EstadoPedido AS e ON e.EstadoPedidoId = p.EstadoPedidoId
GROUP BY e.Nombre
ORDER BY e.Nombre;

/* Evidencia de libros muy, medianamente y poco vendidos. */
SELECT TOP (15)
    l.LibroId,
    l.Titulo,
    SUM(CASE WHEN e.Nombre IN (N'Pagado', N'Enviado', N'Entregado')
             THEN d.Cantidad ELSE 0 END) AS UnidadesEfectivas
FROM libreria.Libro AS l
LEFT JOIN libreria.DetallePedido AS d ON d.LibroId = l.LibroId
LEFT JOIN libreria.Pedido AS p ON p.PedidoId = d.PedidoId
LEFT JOIN libreria.EstadoPedido AS e ON e.EstadoPedidoId = p.EstadoPedidoId
GROUP BY l.LibroId, l.Titulo
ORDER BY UnidadesEfectivas DESC, l.LibroId;
GO

