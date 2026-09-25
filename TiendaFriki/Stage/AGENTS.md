# Base de datos origen
La estructura de la base de datos operacional de origen se encuentra en:
`database/origen_schema_tienda_friki.sql`

Antes de generar consultas SQL:
* Revisar el esquema de la base de datos.
* No inventar tablas ni columnas.
* Verificar claves primarias y foráneas.
* Considerar la base de datos origen como solo lectura.
* No ejecutar sentencias `INSERT`, `UPDATE`, `DELETE`, `DROP`, `ALTER` o `TRUNCATE` sobre la base de datos origen.

# Entorno Python

Este proyecto utiliza Anaconda/Conda.

El entorno oficial del proyecto es:
`base`

# Jupyter
Los notebooks deben utilizar el kernel asociado al entorno Conda:
`base`
El intérprete debe corresponder al entorno `base`.


# Forma de trabajo del agente
El objetivo de este proyecto es utilizar ETL con Python.
Antes de modificar código:
- Trabajar siempre de manera incremental.
- No generar el proceso ETL completo salvo que se solicite explícitamente.
- Generar solamente el bloque solicitado.
- Explicar brevemente el propósito del código.
- Mantener el código sencillo y educativo.
- No abstraer prematuramente en clases o funciones complejas.
- Utilizar pandas para extracción y transformación.
- Utilizar SQLAlchemy para conexiones a PostgreSQL.
- No modificar bloques anteriores salvo que exista un error.
- Antes de escribir código nuevo, reutilizar variables ya existentes.

## Documentación obligatoria de notebooks

- Cada nueva celda de código que Codex agregue a un archivo `.ipynb` DEBE comenzar con un comentario Python de una sola línea.
- El comentario debe estar dentro de la propia celda, como primera línea del código.
- El comentario debe escribirse en primera persona y describir brevemente qué realiza esa celda.
- No sustituir este comentario por una explicación en el chat.
- No crear una celda de código nueva sin este comentario inicial.

Ejemplo:

`# Extraigo los datos de categorías desde la base de datos origen`

## Convenciones
Los DataFrame deben utilizar el prefijo:
df_
Ejemplos:
df_categoria
df_producto
df_cliente
df_venta