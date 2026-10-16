Crear y ejecutar `etl/etl_fact_ventas.ipynb`.

Origen:
- `tienda_friki.Venta`
- `tienda_friki.DetalleVenta`

Dimensiones:
- `dbo.DimCliente`
- `dbo.DimProducto`
- `dbo.DimFecha`

Destino:
- `dbo.FactVentas`

Granularidad:
una línea de producto por venta.

Carga incremental por:
`detalle_venta_id_origen`

Calcular:
`importe_venta`, `costo_total`, `utilidad`.

Aplicar la skill `notebook-tutorial-es`.

Ejecutar, validar y corregir errores.