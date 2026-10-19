---
name: notebook-tutorial-es
description: Crea o modifica notebooks Jupyter orientados a enseñanza, con explicaciones sencillas en español, secciones Markdown claras y código fácil de seguir. Usar cuando se cree un notebook educativo, tutorial o práctica guiada.
---

# Skill: Notebook Tutorial en Español

## Objetivo

Crear o modificar notebooks Jupyter para que funcionen como tutoriales
didácticos, claros y fáciles de seguir para estudiantes.

Esta skill debe aplicarse cuando el notebook tenga fines de enseñanza,
demostración o práctica guiada.

---

## Idioma

Todo el contenido explicativo debe estar en español.

Los nombres técnicos, librerías, funciones y comandos deben conservar
su nombre original.

Ejemplos:

- pandas
- SQLAlchemy
- DataFrame
- read_sql
- merge
- to_sql

---

## Enfoque didáctico

El notebook debe enseñar el proceso paso a paso.

Cada sección debe responder:

1. ¿Qué vamos a hacer?
2. ¿Por qué lo hacemos?
3. ¿Cómo se realiza?
4. ¿Qué resultado debemos obtener?

Las explicaciones deben ser breves y sencillas.

Evitar explicaciones demasiado teóricas.

---

## Estructura del notebook

Organizar el notebook con secciones numeradas.

Ejemplo:

# ETL FactVentas

## Objetivo

## 1. Importar librerías

## 2. Configurar conexiones

## 3. Extraer datos

## 4. Transformar datos

## 5. Buscar claves sustitutas

## 6. Calcular medidas

## 7. Cargar datos

## 8. Validar resultados

---

## Celdas Markdown

Antes de cada bloque importante de código agregar una celda Markdown.

La explicación debe ser corta.

Ejemplo:

### 3. Extraer ventas

En este paso obtenemos las ventas desde Stage.

Solo necesitamos los campos que serán utilizados posteriormente
para construir la tabla de hechos.

Después de ejecutar la consulta revisaremos una pequeña muestra
de los datos obtenidos.

---

## Celdas de código

Las celdas de código deben ser pequeñas y realizar una tarea clara.

Evitar colocar muchas operaciones diferentes dentro de una sola celda.

Preferir:

```python
df_ventas = pd.read_sql(query, engine_stage)

print("Registros extraídos:", len(df_ventas))

df_ventas.head()