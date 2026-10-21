
-- Reporte de Ventas
SELECT
    p.PedidoId,
    p.FechaPedido,

    YEAR(p.FechaPedido) AS Anio,
    MONTH(p.FechaPedido) AS Mes,

    CONCAT(
        c.Nombre, ' ', c.Apellido
    ) AS Cliente,

    c.Ciudad,

    e.Nombre AS Estado,

    p.Subtotal,
    p.Descuento,
    p.Impuesto,
    p.Total

FROM libreria.Pedido p

INNER JOIN libreria.Cliente c
    ON p.ClienteId = c.ClienteId

INNER JOIN libreria.EstadoPedido e
    ON p.EstadoPedidoId = e.EstadoPedidoId

WHERE
    e.Nombre IN (
        'Pagado',
        'Enviado',
        'Entregado'
    )

ORDER BY p.FechaPedido;