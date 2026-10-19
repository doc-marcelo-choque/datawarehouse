---
name: notebook-a-ejecutable
description: Convierte notebooks Jupyter de ETL (.ipynb) en scripts Python ejecutables (.py). Utilizar cuando se solicite convertir, automatizar o preparar notebooks ETL para su ejecución sin Jupyter.
---

# Conversión de notebooks ETL

## Dependencias de instrucciones

Antes de comenzar, leer `AGENTS.md` y aplicar sus reglas generales. Este documento no las sustituye ni las redefine.

## Procedimiento

1. Leer completamente el notebook solicitado.
2. Identificar las etapas de extracción, transformación, carga y validación.
3. Convertir el código a Python estándar, eliminando elementos exclusivos de Jupyter.
4. Organizar el proceso en funciones reutilizables y definir un punto de entrada `main()`.
5. Adaptar la ubicación del archivo `.env` para que el script pueda ejecutarse independientemente del directorio de trabajo.
6. Conservar las consultas SQL, transformaciones, reglas de negocio y comportamiento incremental del notebook.
7. Verificar la sintaxis y las importaciones del script generado.

## Criterios de conversión

- El notebook original debe permanecer sin modificaciones.
- No introducir abstracciones que no aporten valor.
- Eliminar visualizaciones y expresiones utilizadas únicamente para exploración interactiva.
- Incorporar manejo de excepciones y códigos de salida adecuados para ejecución automática.
- No cambiar el comportamiento del proceso ETL sin autorización.
- No ejecutar cargas contra la base de datos durante la conversión.

## Resultado

Entregar un archivo `.py` ejecutable desde la terminal, sin depender de Jupyter.

Informar brevemente los cambios realizados, las verificaciones ejecutadas y cualquier problema detectado.