# Proyecto Data Warehouse - Tienda Friki

## Objetivo

Proyecto educativo para desarrollar procesos ETL desde Stage hacia un Data Warehouse en SQL Server, utilizando Python, Jupyter Notebook y agentes de programación.

## Estructura del proyecto

- `database/`: estructuras SQL de Stage y Data Warehouse.
- `etl/notebooks/`: notebooks originales utilizados para desarrollo y aprendizaje.
- `etl/scripts/`: programas Python ejecutables generados a partir de los notebooks.
- `etl/.env`: configuración de conexiones a SQL Server.
- `.github/skills/`: capacidades especializadas disponibles para los agentes de programación.
- `prompts/`: instrucciones para tareas específicas.

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

## Estructura lógica de los ETL

Todos los procesos ETL deben contemplar:

1. Importación de librerías.
2. Lectura de configuración desde `.env`.
3. Conexiones.
4. Extracción.
5. Transformación.
6. Carga incremental.
7. Validación.

Los notebooks se utilizan para desarrollo y experimentación.

Los scripts Python se utilizan para ejecución independiente y automatización.

Ambas implementaciones deben conservar las mismas reglas de negocio.

## Carga incremental

Para dimensiones:

1. Leer datos desde Stage.
2. Realizar las transformaciones necesarias.
3. Leer claves existentes en el DW.
4. Detectar registros nuevos.
5. Insertar únicamente registros nuevos.

Las claves sustitutas `*_sk` definidas como `IDENTITY` deben ser generadas por SQL Server.

Para tablas de hechos, obtener primero las claves sustitutas desde las dimensiones.

## Orden de carga

1. DimCliente
2. DimProducto
3. DimFecha
4. FactVentas

Los procesos deben respetar sus dependencias.

Si falla un proceso requerido por otro, no se debe continuar con los procesos dependientes.

## Validación

Todo ETL debe mostrar:

- Registros extraídos.
- Registros existentes.
- Registros nuevos.
- Registros insertados.

Una segunda ejecución sin cambios debe insertar 0 registros.

## Uso de skills

Las capacidades especializadas se encuentran en `.github/skills/`.

Cuando una tarea corresponda a una skill disponible, consultar su archivo `SKILL.md` y aplicar sus instrucciones.

Las skills deben complementar las reglas generales de este documento, sin duplicarlas.

## Ejecución de prompts

Cuando se solicite ejecutar un archivo de `prompts/`:

1. Leer este `AGENTS.md`.
2. Leer completamente el prompt indicado.
3. Consultar la skill correspondiente cuando sea aplicable.
4. Consultar los archivos que la tarea requiera.
5. Generar o modificar únicamente los artefactos solicitados.

## Protección de archivos

- No modificar los notebooks originales durante su conversión a scripts.
- No modificar archivos SQL sin autorización.
- No modificar `.env` sin autorización.
- No ejecutar operaciones de escritura en las bases de datos sin autorización.
- No exponer credenciales en código, documentación o registros de ejecución.

## Entorno Python

- El proyecto utiliza el entorno Conda `etl`.
- El intérprete Python está configurado en `.vscode/settings.json`.
- No utilizar otro intérprete ni instalar dependencias sin autorización.
- No crees ambientes
- Las skills deben respetar esta configuración y no redefinir el entorno Python.