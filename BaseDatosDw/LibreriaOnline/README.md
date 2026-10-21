# LibreriaOnline para SQL Server

Conjunto de scripts T-SQL compatible con SQL Server 2019 o superior. Crea una base
transaccional realista que puede utilizarse como origen de una práctica de Data Warehouse.

## Archivos

1. `01_crear_base_esquema.sql`: crea `LibreriaOnline`, el esquema `libreria`, las 15 tablas,
   restricciones e índices. No reemplaza una base existente.
2. `02_cargar_datos.sql`: crea una carga determinística y coherente. Si ya existen pedidos,
   omite la carga para no generar duplicados.
3. `03_validar_datos.sql`: comprueba cantidades, fechas, fórmulas, pagos, reseñas y registros
   huérfanos. Devuelve un error si alguna prueba falla.

Todo el diseño y la generación se implementan en T-SQL. `sqlcmd` solamente envía los
scripts al servidor; no se utiliza ORM.

## Ejecución

Desde PowerShell, en este directorio:

```powershell
$sqlcmd = "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE"

& $sqlcmd -S localhost -U marcelo -P 54321 -C -b -i "01_crear_base_esquema.sql"
& $sqlcmd -S localhost -U marcelo -P 54321 -C -b -i "02_cargar_datos.sql"
& $sqlcmd -S localhost -U marcelo -P 54321 -C -b -i "03_validar_datos.sql"
```

La opción `-b` hace que `sqlcmd` devuelva un código de error si falla una instrucción o una
validación. La opción `-C` confía en el certificado de la instancia local.

## Criterio de importes

- `DetallePedido.Subtotal = Cantidad * PrecioUnitario - Descuento`.
- `Pedido.Subtotal` representa el importe bruto de sus líneas.
- `Pedido.Descuento` es la suma de descuentos de sus líneas.
- El impuesto es el 13 % del importe neto.
- `Pedido.Total = Subtotal - Descuento + Impuesto`.
- Las ventas efectivas corresponden a los estados `Pagado`, `Enviado` y `Entregado`.
  Los pedidos `Pendiente` y `Cancelado` no se contabilizan como ingreso confirmado.

Los pedidos están comprendidos entre enero de 2024 y septiembre de 2026. La carga produce
clientes recurrentes y de una sola compra, además de libros con niveles de demanda alto,
medio y bajo.

