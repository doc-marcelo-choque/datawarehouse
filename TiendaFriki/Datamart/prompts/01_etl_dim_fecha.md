# ETL DimFecha

## Objetivo

Crear y ejecutar:

`etl/etl_dim_fecha.ipynb`

## Referencias

Antes de programar, revisar:

- `database/estructura_stage.sql`
- `database/estructura_dw.sql`
- `etl/etl_dim_cliente.ipynb`
- `etl/etl_dim_producto.ipynb`

Usar los notebooks existentes como referencia de estilo.

## Origen

Obtener las fechas desde la tabla de ventas de Stage.

Usar el campo:

`fecha_venta`

## Destino

Cargar:

`dbo.DimFecha`

## Transformación

Generar los campos definidos en la estructura real de `DimFecha`.

La clave:

`fecha_sk`

debe tener formato:

`AAAAMMDD`

El nombre del mes debe estar en español.

`es_fin_semana` debe identificar sábado y domingo.

## Carga incremental

Comparar por:

`fecha_sk`

Insertar únicamente fechas que todavía no existan.

## Resultado esperado

Crear

`etl/etl_dim_fecha.ipynb`
