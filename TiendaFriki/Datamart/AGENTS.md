# Proyecto Data Warehouse - Tienda Friki

## Objetivo

Proyecto educativo para aprender procesos ETL desde Stage hacia un Data Warehouse en SQL Server.

## Estructura

- `database/estructura_stage.sql`: estructura de Stage.
- `database/estructura_dw.sql`: estructura del Data Warehouse.
- `etl/`: notebooks ETL.
- `etl/.env`: configuración de conexiones.
- `prompts/`: tareas específicas para el agente.

## Reglas generales

- Responde y documenta en español.
- Mantén el código sencillo y didáctico.
- Usa `pandas`, `SQLAlchemy` y `python-dotenv`.
- No uses clases ni abstracciones innecesarias.
- No escribas credenciales directamente en el código.
- Consulta siempre las estructuras SQL antes de generar consultas.
- No crees ni modifiques tablas desde los ETL.
- No uses `DROP`, `TRUNCATE` ni `if_exists="replace"`.
- No elimines datos existentes del Data Warehouse.
- Los ETL deben poder ejecutarse varias veces sin generar duplicados.

## Estructura de los ETL

Cada notebook debe seguir:

1. Importación de librerías.
2. Lectura de `.env`.
3. Conexiones.
4. Extracción.
5. Transformación.
6. Carga incremental.
7. Validación.

## Carga incremental

Para dimensiones:

1. Leer datos desde Stage.
2. Realizar transformaciones necesarias.
3. Leer claves existentes en el DW.
4. Detectar registros nuevos.
5. Insertar únicamente registros nuevos.

Las claves sustitutas `*_sk` definidas como `IDENTITY`
deben ser generadas por SQL Server.

Para tablas de hechos, obtener primero las claves sustitutas
desde las dimensiones.

## Orden de carga

1. DimCliente
2. DimProducto
3. DimFecha
4. FactVentas

## Validación

Todo ETL debe mostrar:

- registros extraídos;
- registros existentes;
- registros nuevos;
- registros insertados.

Una segunda ejecución sin cambios debe insertar 0 registros.

## Ejecución de prompts

Cuando se solicite ejecutar un archivo de `prompts/`:

1. Lee este `AGENTS.md`.
2. Lee completamente el prompt indicado.
3. Consulta los archivos que el prompt requiera.
4. Genera o modifica únicamente el artefacto solicitado.