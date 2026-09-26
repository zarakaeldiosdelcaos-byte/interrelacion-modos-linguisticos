# Cuaderno de decisiones

Este documento registra **por qué** el repositorio está armado así, y qué decisiones siguen
pendientes. Es el archivo que un revisor metodológico lee primero después del `README.md`.

---

## D1. La cohorte piloto y la cohorte principal son **muestras distintas**, no dos olas

El manuscrito las presenta juntas (`N = 40`). Los datos dicen otra cosa:

| Cohorte | Participantes | Observaciones (3 por persona) | Condiciones (Texto / Audio / Imagen) | `demora` | `n_palabras` |
|---|---|---|---|---|---|
| Principal | **23** | 69 | 8 / 8 / 7 | D / ND | informada |
| Piloto | **17** | 51 | **6 / 6 / 5** | ausente | **vacía** (se calcula) |

Consecuencias aplicadas en el código:

- Los identificadores **no se solapan**: `principal_P1…` y `piloto_P1…`. En la versión auditada
  el piloto viajaba como `principal_P1…principal_P17`, de modo que un `merge` por identificador
  producía un producto cartesiano silencioso (40 filas con 23 identificadores únicos).
- La columna `fuente` se escribe siempre y **el script se detiene** si las cohortes comparten
  identificadores (`code/01_pipeline_nlp.R`, bloque `[v5-E]`).
- Toda tabla publicada lleva `fuente` y `n`. Las tablas comparativas van a `results/combinado/`,
  nunca dentro de `results/piloto/`.

## D2. `n_palabras` frente a `n_palabras_calculado`

- El Excel del piloto trae la columna de conteo **vacía**; el análisis usa el conteo **calculado
  desde el texto** (`n_palabras_calculado`, `str_count(texto, "\\S+")`).
- En la cohorte principal las dos columnas coinciden (correlación ≈ 1), por eso el modelo
  conserva `n_palabras` y descarta la redundante.
- Regla de lectura: **un número de palabras del piloto es siempre calculado**, nunca provisto por
  el instrumento de captura.

## D3. Corrección de multiplicidad

- El script del estudio (`code/01_pipeline_nlp.R`) aplica **FDR** a los efectos fijos y **Holm** a
  los contrastes post-hoc de los modelos de la cohorte.
- El pipeline modular aplica **Holm** en los contrastes de `emmeans`.
- Se declaran ambos: no son intercambiables y el manuscrito debe decir cuál respalda cada tabla.

## D4. Qué se publica y qué no

| Contenido | Decisión | Motivo |
|---|---|---|
| Código, especificaciones, tablas agregadas, figuras | **sí** | Es el método y la evidencia numérica |
| Narrativas de participantes (Excel de captura, `*_completo.csv`, `*_longitudinal.csv`, `scores_diccionarios_long.csv` de 32 MB) | **no** | Texto libre de personas en contexto clínico |
| `.rds` de modelos | sí, **como anexo** | Un binario no es revisable en un *pull request*; la evidencia es su tabla |
| PDF de editorial | no se redistribuyen | Se enlazan por DOI |
| `files.zip`, `Experimento ALC.md`, artefactos LaTeX intermedios | no | Duplicados o regenerables |

Los patrones correspondientes están en `.gitignore`; `bash tests/check_hashes.sh` comprueba que
ningún microdato quede rastreado.

## D5. Estructura del repositorio y sus desviaciones declaradas

Estructura adoptada: `code/`, `data_spec/`, `results/{piloto,principal,combinado,figuras}`,
`manifests/`, `tests/`, `docs/`.

Desviaciones respecto del esquema mínimo, y por qué:

| Elemento añadido | Motivo |
|---|---|
| `code/R/`, `code/python/`, `code/scripts/` | El pipeline reproducido es **modular** (10 módulos R + utilidades Python). Aplanarlos a un único archivo habría roto las rutas `source()`. |
| `docs/metodologia/`, `docs/auditorias/`, `docs/assets/` | Documentación extensa preexistente (figuras, modelos, embeddings, migración R↔Python). Se conserva íntegra. |
| `data/raw/lexicons/nrc_es.rds` | Dependencia necesaria para reproducir; no es microdato y está versionada. |
| `results/tablas/`, `results/modelos/`, `results/diagnosticos/` | Agrupan artefactos agregados. La separación por cohorte se hace en `results/piloto/`, `results/principal/` y `results/combinado/`. |
| `requirements.txt` | Fija el entorno Python validado (torch CPU + sentence-transformers). |

## D6. El script del estudio se publica **sin reescribir**

`code/01_pipeline_nlp.R` es el script del estudio con las correcciones de ejecutabilidad y de
separación de cohortes aplicadas (`[v5-A]` … `[v5-N]`, cada marca comentada en el propio archivo).
Se publica **byte a byte** como quedó reparado, para que su hash sea verificable; por eso conserva
nombres propios de su corrida original (`resultados/`, `outputs/`, `Estructura 14`), que no
coinciden con la nomenclatura del repositorio. Los usuarios del repositorio deben ejecutar
`code/run_analysis.R`, no el script histórico.

## D7. Pendientes que **no** puede resolver quien mantiene el repositorio

1. **Autoría y citación**: `CITATION.cff` está completo salvo nombres, ORCID y año, que solo el
   autor del estudio puede confirmar.
2. **Licencia**: `LICENSE` propone MIT para el código y CC BY 4.0 para documentación y figuras
   (el autor del script puede preferir GPL-3).
3. **Aval del comité de ética**: el procedimiento de solicitud de microdatos debe citarlo.
4. **Números del manuscrito**: las tablas del artículo están escritas a mano en el `.tex` (sin
   `\input` desde los CSV). Mientras no se generen desde estos archivos, el manuscrito no es
   verificable contra los datos.
5. **Recalcular la extracción del piloto** (prototipos y semántica) usando los embeddings 17×384
   que sí existen en `data/processed/piloto/`: hoy el piloto no tiene esos análisis.

## D8. Lo que se decidió **no** hacer

- No reescribir los Excel de captura para "corregir" encabezados: son el original.
- No fusionar piloto y principal en un único `n = 40` sin la columna `fuente`.
- No publicar objetos vacíos (0 × 384) como si fueran resultados: la versión auditada guardaba
  tres artefactos vacíos del piloto.
- No re-ejecutar el pipeline completo para este empaquetado: los resultados publicados son los de
  la corrida auditada, y así se declara en el `README.md`.

---

## D6 — Resultados integrados: qué entra al repositorio y qué no (2026-09-25)

**Decisión.** El repositorio incorpora los artefactos de la corrida verificada del pipeline, pero **no
todo**: entra lo que describe resultados, no lo que reproduce a las personas.

**Entra**: informes y documentos; figuras (PNG y PDF, ES/EN); tablas **agregadas** (por grupo, por modelo o
por efecto); objetos de modelo **sin** los slots de una fila por participante; centroides de prototipos;
registros de ejecución; inventarios.

**No entra**: cualquier archivo con texto escrito por participantes; cualquier tabla con una fila por
observación o por participante, aunque sea numérica (`*_longitudinal.csv`, `*_metricas_*`,
`scores_diccionarios*`, `ancho_*.rds`, `embeddings_*`); los insumos crudos (`.xlsx` de captura, léxico NRC);
los volcados `.RData`; los árboles duplicados de copias (`articulo_1/`, `para_articulos/`); los residuos de
sesión (`Rplots.pdf`) y las corridas fallidas anteriores.

**Por qué.** El repositorio es privado, pero la regla del proyecto es que los datos de las personas no
viajan con el código. Un repositorio que crece con tablas por participante acaba conteniendo el corpus sin
que nadie lo decida; la política se aplica **por contenido**, no por confianza en el nombre del archivo.

**Cómo se verifica.** Cada archivo candidato pasa por una comprobación de contenido (ninguna celda de texto
superior a 200 caracteres); los `.rds` de modelo, por otra (ninguna cadena de más de 120 caracteres); y
`tests/check_hashes.sh` revisa lo mismo sobre lo ya rastreado, además del interior de los `.xlsx`. La lista
completa de exclusiones, con su motivo, está en `docs/resultados_integrados.md`, generada por el propio
integrador (`integrar_resultados.py`).

**Desviaciones de la estructura acordada** (declaradas, no silenciosas):
`results/combinado/revision/` (el paquete para revisión independiente),
`results/combinado/sensibilidad/` (los seis modelos de robustez),
`results/diagnosticos/` (diagnósticos y registros) y `results/logs/` (el log de la corrida final).
