# Tienda Friki — Proyecto Data Warehouse y Data Mart

Proyecto educativo de integración de datos, diseñado para recorrer el ciclo completo desde una **base transaccional PostgreSQL** hasta un **Data Mart dimensional en SQL Server**, utilizando procesos ETL desarrollados con Python, pandas, SQLAlchemy y Jupyter Notebook. Incluye un flujo de trabajo preparado para la asistencia de agentes de programación como GitHub Copilot y Codex.

## 1. Arquitectura

```text
PostgreSQL (OLTP)
  BD: tienda_friki | Esquema: tienda
         |
         | ETL de origen a Stage (debe estar implementado)
         v
SQL Server (Staging)
  BD: Stage | Esquema: tienda_friki
         |
         | ETL Python / notebooks
         v
SQL Server (Data Mart)
  BD: dw_tienda_friki | Esquema: dbo
  +-- DimCliente
  +-- DimProducto
  +-- DimFecha
  +-- FactVentas
```

**Separación de responsabilidades:** PostgreSQL conserva los datos operativos, Stage reúne los datos que se procesarán y el Data Mart soporta consultas analíticas mediante dimensiones y hechos. Los ETL del Data Mart identifican registros nuevos para evitar inserciones duplicadas al repetir una carga.

## 2. Estructura propuesta del repositorio

```text
Datamart/
├── README.md
├── AGENTS.md
├── environment.yml
├── .gitignore
├── .vscode/
│   └── settings.json
├── .github/
│   └── skills/
│       ├── notebook-a-ejecutable/
│       │   └── SKILL.md
│       └── notebook-tutorial-es/
│           └── SKILL.md
├── database/
│   ├── tienda_friki_bk.sql          # Respaldo lógico PostgreSQL
│   ├── estructura_stage.sql         # DDL Stage (si está disponible)
│   └── estructura_dw.sql            # DDL Data Mart (si está disponible)
├── etl/
│   ├── .env                         # Configuración privada, no versionar
│   ├── notebooks/
│   │   ├── etl_dim_cliente.ipynb
│   │   ├── etl_dim_producto.ipynb
│   │   ├── etl_dim_fecha.ipynb
│   │   └── etl_fact_ventas.ipynb
│   └── scripts/                     # Salida de la conversión a Python
│       ├── etl_dim_cliente.py
│       ├── etl_dim_producto.py
│       ├── etl_dim_fecha.py
│       └── etl_fact_ventas.py
├── prompts/
└── run_etl.py                       # Orquestador, cuando se implemente
```

> **Estado de los archivos:** se verificaron el respaldo PostgreSQL, `AGENTS.md`, `.env` y los cuatro notebooks del Data Mart. La estructura SQL de Stage/DW, el ETL PostgreSQL → Stage, `environment.yml`, los scripts `.py`, las skills y `run_etl.py` se documentan como componentes previstos o que deben verificarse en el repositorio real; no se presupone que estén creados.

## 3. Requisitos previos

- Windows con PowerShell o Anaconda PowerShell Prompt.
- PostgreSQL y sus herramientas `psql` / `pg_restore` (según el formato de respaldo).
- Microsoft SQL Server con acceso a las bases Stage y Data Mart.
- SQL Server Management Studio (SSMS) o `sqlcmd`.
- Anaconda o Miniconda.
- **ODBC Driver 17 for SQL Server**, instalado en Windows (el paquete `pyodbc` no instala el driver del sistema).
- VS Code con extensiones Python y Jupyter; GitHub Copilot o Codex son opcionales.

La instancia PostgreSQL, su puerto, el usuario y la contraseña pueden variar. No están fijados en el respaldo. En algunos entornos del proyecto se ha usado el puerto **5433**; sustituirlo si tu servidor usa otro.

## 4. Preparar el entorno Python con Conda

### 4.1. Crear `environment.yml`

Guardar este archivo en la raíz del proyecto:

```yaml
name: etl
channels:
  - conda-forge
dependencies:
  - python=3.11
  - pip
  - pandas
  - sqlalchemy
  - pyodbc
  - python-dotenv
  - jupyterlab
  - nbconvert
  - ipykernel
  - openpyxl
  - psycopg2
```

`psycopg2` permite conectar Python con PostgreSQL en caso de implementar o ejecutar el tramo origen → Stage. Los notebooks del Data Mart incluidos actualmente utilizan SQL Server.

### 4.2. Crear, activar y verificar

Abrir **Anaconda PowerShell Prompt** y situarse en la raíz del repositorio:

```powershell
conda env create -f environment.yml
conda activate etl
python --version
python -c "import sys; print(sys.executable)"
python -c "import pandas, sqlalchemy, pyodbc, dotenv, psycopg2; print('Dependencias correctas')"
```

Para actualizar un entorno existente después de cambiar `environment.yml`:

```powershell
conda env update -f environment.yml
```

Para listar entornos y confirmar la instalación:

```powershell
conda env list
conda info --base
```

Si `conda` no se reconoce en PowerShell normal, abrir Anaconda PowerShell Prompt y ejecutar:

```powershell
conda init powershell
```

Después reiniciar VS Code/PowerShell. En el equipo en que se preparó originalmente el entorno, la raíz de Anaconda era `C:\Users\Pc\anaconda326`; en otras máquinas esa ruta será diferente.

### 4.3. Kernel Jupyter y VS Code

```powershell
python -m ipykernel install --user --name etl --display-name "Python (ETL)"
```

En VS Code seleccionar **Python: Select Interpreter** y el entorno Conda `etl`; en los notebooks, seleccionar el kernel **Python (ETL)**.

Opcionalmente, para una estación con Anaconda en `C:\Users\Pc\anaconda326`, colocar en `.vscode/settings.json`:

```json
{
  "python.defaultInterpreterPath": "C:\\Users\\Pc\\anaconda326\\envs\\etl\\python.exe",
  "python.terminal.activateEnvironment": true
}
```

Esta ruta es específica del equipo. La selección del intérprete en VS Code **no garantiza** que cada terminal de un agente use ese Python; comprobar siempre `sys.executable` antes de probar scripts.

## 5. Restaurar la base transaccional en PostgreSQL

El archivo disponible `tienda_friki_bk.sql` es un **volcado SQL de texto**, generado con `pg_dump` de PostgreSQL 18.6. Contiene, entre otros objetos, el esquema `tienda` y las tablas `cliente`, `producto`, `categoria`, `subcategoria`, `venta` y `detalle_venta`.

### 5.1. Crear la base vacía

Con PostgreSQL iniciado, desde PowerShell, usando las utilidades PostgreSQL disponibles en el PATH:

```powershell
createdb -h localhost -p 5433 -U postgres tienda_friki
```

Alternativamente, en `psql` conectado a otra base (por ejemplo `postgres`):

```sql
CREATE DATABASE tienda_friki;
```

No ejecutar esta creación si la base ya existe.

### 5.2. Restaurar el SQL

Desde la raíz del repositorio:

```powershell
psql -h localhost -p 5433 -U postgres -d tienda_friki -v ON_ERROR_STOP=1 -f "database/tienda_friki_bk.sql"
```

**Nota:** el respaldo contiene instrucciones de propietario para el rol `postgres`, por lo que una restauración con otro usuario puede requerir permisos adicionales o la adaptación del script. El respaldo está destinado a una base vacía. El archivo SQL no debe restaurarse con `pg_restore`, reservado para volcados en formato no textual.

Verificar las tablas:

```powershell
psql -h localhost -p 5433 -U postgres -d tienda_friki -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'tienda' ORDER BY table_name;"
```

Y los datos principales:

```powershell
psql -h localhost -p 5433 -U postgres -d tienda_friki -c "SELECT COUNT(*) AS clientes FROM tienda.cliente;"
psql -h localhost -p 5433 -U postgres -d tienda_friki -c "SELECT COUNT(*) AS ventas FROM tienda.venta;"
```

## 6. Crear Stage en SQL Server

Stage es una base independiente llamada `Stage`, con esquema `tienda_friki`. Su creación física y la de sus tablas deben hacerse **antes** de ejecutar la carga PostgreSQL → Stage.

### 6.1. Ejecutar el DDL

Si el repositorio contiene `database/estructura_stage.sql`, abrirlo y ejecutarlo en SSMS contra la instancia SQL Server adecuada, o utilizar `sqlcmd`:

```powershell
sqlcmd -S 'SERVIDOR\INSTANCIA' -U USUARIO -d master -b -i 'database/estructura_stage.sql'
```

El archivo debe crear la base y sus objetos si esa es la responsabilidad de su DDL. Si solo crea el esquema y las tablas, crear previamente la base `Stage` y ejecutarlo con `-d Stage`. **Revisar el contenido del SQL antes de ejecutarlo**, porque el DDL de Stage no está incluido entre los archivos verificados para este README.

### 6.2. Verificar las tablas

```sql
USE Stage;
GO
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'tienda_friki'
ORDER BY TABLE_NAME;
```

Los notebooks del Data Mart consultan, entre otras, `tienda_friki.Cliente`, `tienda_friki.Producto`, `tienda_friki.venta` y `tienda_friki.detalle_venta`. Respeta esos nombres o adapta las consultas después de confirmar el esquema definitivo.

## 7. Cargar datos PostgreSQL → Stage

Este tramo realiza la extracción de datos transaccionales desde el esquema `tienda` de PostgreSQL y su carga en el esquema `tienda_friki` de SQL Server. Puede implementarse con Python, SQLAlchemy y pandas.

**No se dispone aquí de un script confirmado para esta etapa.** Por tanto, el comando concreto para ejecutarla dependerá del archivo ETL que se incorpore al repositorio. No se debe considerar Stage cargado solamente por haber creado sus tablas.

Comprobar una carga de ejemplo desde SQL Server:

```sql
USE Stage;
GO
SELECT COUNT(*) AS clientes FROM tienda_friki.Cliente;
SELECT COUNT(*) AS productos FROM tienda_friki.Producto;
SELECT COUNT(*) AS ventas FROM tienda_friki.venta;
SELECT COUNT(*) AS detalles FROM tienda_friki.detalle_venta;
```

Antes de automatizar la etapa, definir el criterio incremental (fechas de modificación, claves nuevas o comparación de datos), las comprobaciones de calidad y las tablas de control necesarias.

## 8. Crear el Data Mart en SQL Server

El Data Mart se aloja en la base `dw_tienda_friki`, esquema `dbo`, y contiene tres dimensiones y una tabla de hechos:

| Tabla | Propósito |
|---|---|
| `dbo.DimCliente` | Atributos descriptivos del cliente. |
| `dbo.DimProducto` | Atributos descriptivos del producto. |
| `dbo.DimFecha` | Fechas y atributos para análisis temporal. |
| `dbo.FactVentas` | Medidas y referencias dimensionales por detalle de venta. |

Ejecutar el DDL real, si existe en `database/estructura_dw.sql`, desde SSMS o `sqlcmd`:

```powershell
sqlcmd -S 'SERVIDOR\INSTANCIA' -U USUARIO -d master -b -i 'database/estructura_dw.sql'
```

Como en Stage, ajustar `-d` según si el archivo crea la base o solo los objetos en ella. **El DDL del Data Mart no estaba entre los archivos disponibles para verificación**; no debe asumirse que esos scripts ya existen.

Validar:

```sql
USE dw_tienda_friki;
GO
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
```

## 9. Configurar conexiones a SQL Server

Crear `etl/.env` (archivo local y privado) con los nombres de variables utilizados por los notebooks:

```dotenv
# SQL Server — Stage
SQLSERVER_SERVIDOR=SERVIDOR\INSTANCIA
SQLSERVER_USUARIO=USUARIO_ETL
SQLSERVER_PASSWORD=REEMPLAZAR_CON_SECRETO_LOCAL
SQLSERVER_BASE_DATOS=Stage
SQLSERVER_ESQUEMA=tienda_friki
SQLSERVER_DRIVER=ODBC Driver 17 for SQL Server

# SQL Server — Data Mart
SQLSERVER_SERVIDOR_DW=SERVIDOR\INSTANCIA
SQLSERVER_USUARIO_DW=USUARIO_ETL
SQLSERVER_PASSWORD_DW=REEMPLAZAR_CON_SECRETO_LOCAL
SQLSERVER_BASE_DATOS_DW=dw_tienda_friki
SQLSERVER_ESQUEMA_DW=dbo
SQLSERVER_DRIVER_DW=ODBC Driver 17 for SQL Server
```

No subir `etl/.env` al repositorio, no publicar contraseñas en ejemplos y no registrar cadenas de conexión completas en logs.

**Ruta del `.env`:** si los notebooks se ejecutan con directorio de trabajo `etl/notebooks`, se puede utilizar `load_dotenv(Path('../.env').resolve())`; si el directorio de trabajo es la raíz del repositorio, utilizar `Path('etl/.env')`. Para scripts ubicados en `etl/scripts`, resolverlo respecto al archivo con `Path(__file__).resolve().parent.parent / '.env'`. La ruta relativa de un notebook depende del directorio de trabajo del kernel.

Verificar los drivers ODBC detectados:

```powershell
conda run -n etl python -c "import pyodbc; print(pyodbc.drivers())"
```

## 10. Ejecutar los ETL del Data Mart

Los cuatro notebooks del proyecto realizan cargas incrementales desde Stage hacia el Data Mart. El orden definido en `AGENTS.md` es:

1. `etl_dim_cliente.ipynb`
2. `etl_dim_producto.ipynb`
3. `etl_dim_fecha.ipynb`
4. `etl_fact_ventas.ipynb`

Antes de ejecutar, seleccionar el kernel `Python (ETL)` y validar la ubicación del `.env` en cada notebook. La ejecución de los ETL **sí escribe datos** en SQL Server.

### 10.1. Trabajar desde Jupyter

```powershell
conda activate etl
jupyter lab
```

Abrir los notebooks en `etl/notebooks/` y ejecutarlos según el orden indicado. La primera ejecución carga registros nuevos; una segunda ejecución sin cambios en Stage debería insertar cero registros.

### 10.2. Convertir notebooks a archivos Python

Desde la raíz del proyecto:

```powershell
conda run -n etl python -m nbconvert --to script etl/notebooks/etl_dim_cliente.ipynb --output-dir etl/scripts
conda run -n etl python -m nbconvert --to script etl/notebooks/etl_dim_producto.ipynb --output-dir etl/scripts
conda run -n etl python -m nbconvert --to script etl/notebooks/etl_dim_fecha.ipynb --output-dir etl/scripts
conda run -n etl python -m nbconvert --to script etl/notebooks/etl_fact_ventas.ipynb --output-dir etl/scripts
```

`nbconvert` solo convierte el código: **no garantiza que el script resultante esté listo para automatización**. Puede requerir ajustes en la resolución del `.env`, eliminación de operaciones exclusivas de Jupyter, manejo de errores, cierre de conexiones y punto de entrada `main()`.

### 10.3. Validar la sintaxis sin ejecutar el ETL

Una vez generados y revisados los scripts:

```powershell
conda run -n etl python -m py_compile etl/scripts/etl_dim_cliente.py
conda run -n etl python -m py_compile etl/scripts/etl_dim_producto.py
conda run -n etl python -m py_compile etl/scripts/etl_dim_fecha.py
conda run -n etl python -m py_compile etl/scripts/etl_fact_ventas.py
```

### 10.4. Ejecutar scripts revisados

Cuando los scripts estén adaptados y probados:

```powershell
conda run -n etl python etl/scripts/etl_dim_cliente.py
conda run -n etl python etl/scripts/etl_dim_producto.py
conda run -n etl python etl/scripts/etl_dim_fecha.py
conda run -n etl python etl/scripts/etl_fact_ventas.py
```

Un posible `run_etl.py` puede orquestar estos cuatro procesos cuando se implemente. No se presenta como disponible hasta que exista y se valide.

## 11. Pruebas del Data Mart

Consulta de conteos:

```sql
USE dw_tienda_friki;
GO
SELECT COUNT(*) AS clientes FROM dbo.DimCliente;
SELECT COUNT(*) AS productos FROM dbo.DimProducto;
SELECT COUNT(*) AS fechas FROM dbo.DimFecha;
SELECT COUNT(*) AS ventas FROM dbo.FactVentas;
```

Verificar hechos sin relación dimensional (si las claves tienen los nombres utilizados por los notebooks):

```sql
SELECT COUNT(*) AS ventas_sin_cliente
FROM dbo.FactVentas f
LEFT JOIN dbo.DimCliente c ON f.cliente_sk = c.cliente_sk
WHERE f.cliente_sk IS NOT NULL AND c.cliente_sk IS NULL;

SELECT COUNT(*) AS ventas_sin_producto
FROM dbo.FactVentas f
LEFT JOIN dbo.DimProducto p ON f.producto_sk = p.producto_sk
WHERE p.producto_sk IS NULL;
```

Prueba de idempotencia: ejecutar dos veces el ETL con Stage sin cambios y comparar los conteos. En la segunda pasada, el número de filas insertadas debe ser cero. La lógica de los notebooks actuales es fundamentalmente **insertar registros nuevos**; no constituye por sí sola una estrategia completa para actualizar atributos modificados (SCD) ni para reflejar anulaciones o cambios de hechos ya cargados.

## 12. Agentes de programación: Copilot y Codex

Las reglas generales del proyecto están en `AGENTS.md`; las tareas especializadas se describen en skills, por ejemplo `.github/skills/notebook-a-ejecutable/SKILL.md` si existe.

Para pedir la conversión de un notebook sin modificar el original:

> Lee `AGENTS.md`. Utiliza la skill `notebook-a-ejecutable` si está disponible y convierte `etl/notebooks/etl_dim_cliente.ipynb` en `etl/scripts/etl_dim_cliente.py`. Usa el entorno Conda `etl`. No ejecutes cargas de datos ni cambies los archivos SQL o el `.env` sin autorización.

Los agentes deben verificar el intérprete antes de ejecutar código, por ejemplo:

```powershell
conda run -n etl python -c "import sys; print(sys.executable)"
```

El reconocimiento automático de skills puede variar según el agente y su versión. Si no encuentra una skill, se le puede solicitar expresamente leer la ruta de su `SKILL.md`.

## 13. Problemas frecuentes

| Problema | Comprobación o solución |
|---|---|
| `conda` no se reconoce | Abrir Anaconda Prompt, ejecutar `conda init powershell` y reiniciar la terminal. |
| `jupyter` no se reconoce | Activar `etl` o usar `conda run -n etl python -m jupyter lab`. |
| `No module named nbconvert` | Revisar `environment.yml` y ejecutar `conda env update -f environment.yml`. |
| `IM002` / driver ODBC no encontrado | Instalar el ODBC Driver correspondiente y comprobar `pyodbc.drivers()`. |
| Error de certificado TLS en SQL Server | Revisar configuración de cifrado/certificado y la cadena de conexión; `TrustServerCertificate=yes` es una solución de laboratorio, no la recomendación por defecto para producción. |
| No se encuentra `.env` | Revisar el directorio de trabajo del notebook o resolver rutas con `__file__` en scripts. |
| Errores de FK en `FactVentas` | Confirmar que se cargaron las dimensiones y se encontraron las claves sustitutas. |
| Datos duplicados al repetir la carga | Revisar claves naturales, reglas incrementales y restricciones de unicidad en SQL Server. |
| `sqlcmd` no se reconoce | Instalar las utilidades de línea de comandos de SQL Server o usar SSMS. |

## 14. Seguridad y control de versiones

Archivo `.gitignore` recomendado:

```gitignore
# Credenciales y configuración privada
.env
**/.env

# Entornos y cachés de Python
.venv/
venv/
__pycache__/
*.py[cod]
.ipynb_checkpoints/

# Archivos de compilación y registros
build/
dist/
*.log
```

Versionar los notebooks, el código fuente, los DDL revisados, `environment.yml`, `AGENTS.md` y las skills. Las contraseñas deben configurarse localmente. Si alguna credencial real se compartió o versionó, rotarla.

## 15. Resumen para levantar el proyecto desde cero

1. Instalar PostgreSQL, SQL Server, ODBC Driver 17, Conda y VS Code.
2. Preparar `environment.yml` y ejecutar `conda env create -f environment.yml`.
3. Activar el entorno mediante `conda activate etl`.
4. Crear la base `tienda_friki` y restaurar `database/tienda_friki_bk.sql` con `psql`.
5. Crear y verificar `Stage` y el esquema `tienda_friki` usando el DDL real del proyecto.
6. Ejecutar y validar el ETL PostgreSQL → Stage cuando esté disponible.
7. Crear y verificar `dw_tienda_friki` y sus tablas dimensionales mediante su DDL.
8. Configurar `etl/.env` con las conexiones locales.
9. Ejecutar los cuatro notebooks del Data Mart en orden.
10. Verificar conteos, relaciones y ausencia de nuevas inserciones en una segunda ejecución.
11. Si se requiere automatización, convertir los notebooks a `.py`, adaptar los scripts y validarlos antes de programar su ejecución.

---

**Alcance actual:** el respaldo PostgreSQL y los cuatro notebooks del Data Mart son los artefactos verificados. Los scripts DDL completos de SQL Server y el ETL de PostgreSQL a Stage se deben incorporar o confirmar para que este README sea una guía de instalación íntegramente ejecutable de principio a fin.
