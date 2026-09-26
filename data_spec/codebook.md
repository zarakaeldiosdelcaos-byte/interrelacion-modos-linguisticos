# Codebook

Especificación de las variables capturadas. Origen: hoja **`Codebook`** del archivo de captura
`datos_experimento.xlsx` (6 variables). Los microdatos **no** se publican: este archivo documenta
qué significa cada columna para quien reciba los datos por solicitud.

## 1. Variables capturadas (verbatim del `Codebook`)

| Variable | Tipo | Valores posibles | Descripción |
|---|---|---|---|
| `participante` | Factor | P1 – P23 | Identificador único del participante |
| `condicion` | Factor | Texto / Audio / Imagen | Tipo de estímulo recibido (variable entre sujetos) |
| `demora` | Factor | D / ND | D = con valencia de demora; ND = sin valencia de demora |
| `iteracion` | Numérico (ordinal) | 1 / 2 / 3 | Número de iteración: 1 = sin estímulo, 2 = un estímulo, 3 = texto-audio-imagen |
| `n_palabras` | Numérico (conteo) | Entero ≥ 0 | Número de palabras en la redacción (variable dependiente cuantitativa) |
| `texto` | Caracter | Texto libre | Redacción completa del participante en esa iteración |

Hojas del archivo de captura: `Datos_Largo` (una fila por participante × iteración),
`Datos_Ancho` (una fila por participante, columnas `texto_it1…texto_it3`), `Codebook`, `Codigo_R`.

## 2. Esquema canónico del pipeline

Ambas cohortes se normalizan al mismo esquema antes de cualquier análisis:

| Columna | Origen | Nota |
|---|---|---|
| `fuente` | derivada | `"principal"` (23) o `"piloto"` (17) |
| `participante` | captura | tal cual viene del Excel |
| `id_participante` | derivada | `fuente` + `_` + `participante` → `principal_P3`, `piloto_P3` |
| `id_observacion` | derivada | `id_participante` + `_` + `iteracion` |
| `condicion` | captura | Texto / Audio / Imagen |
| `demora` | captura | **NA en toda la cohorte piloto** (no se capturó) |
| `iteracion` | captura | 1, 2, 3 |
| `texto` | captura | narrativa |
| `n_palabras` | captura | **NA en toda la cohorte piloto** (columna vacía en el Excel) |
| `n_palabras_calculado` | derivada | `str_count(texto, "\\S+")` — la única disponible en el piloto |
| `n_estimulos` | derivada | 0 (T1), 1 (T2), 3 (T3) |

## 3. Diferencias entre cohortes que hay que tener presentes

| Aspecto | Principal (23) | Piloto (17) |
|---|---|---|
| Observaciones | 69 | 51 |
| Condiciones | Texto 8 · Audio 8 · Imagen 7 | **Texto 6 · Audio 6 · Imagen 5** |
| `demora` | D / ND | ausente |
| `n_palabras` (captura) | informada | **vacía** → usar `n_palabras_calculado` |
| Prototipos, semántica y diccionarios calculados | presentes | **ausentes** en la versión auditada |

> La cabecera del script histórico declara para el piloto `Texto P1-P5`, `Audio P6-P11`,
> `Imagen P12-P17`. El reparto real, leído del propio Excel, es **6 / 6 / 5**. El pipeline toma la
> condición de los datos, no del rango de identificadores.

## 4. Convenciones de nomenclatura

- `*_t1`, `*_t2`, `*_t3` = valor de la variable en cada iteración (formato ancho).
- `cambio_*_t1t2`, `_t2t3`, `_t1t3` = diferencia entre iteraciones.
- `proto_<constructo>_t<k>` = similitud coseno con el centroide del prototipo (ver
  `data_spec/prototipos.csv`).
- `score_<tema>` = conteo bruto de términos del diccionario; `rate_<tema>` = conteo por 1000
  palabras.
