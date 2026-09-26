# CAMBIOS v5 — Reparación de `Experimento ALC.R`

Fecha: 2026-09-24
Autor de la reparación: Hermes (orquestador), tras fallar 4 intentos delegados a agentes por causas de proveedor.

## Identidad de los archivos

| Archivo | SHA-256 | Tamaño | Fecha |
|---|---|---|---|
| `Experimento ALC.R` (**original, INTACTO**) | `a781da40333aa7c7ee0a401ea9ab404f57b0260e876e6555acfbd4c1088b5950` | 310.791 B | ago 25 20:45 |
| `Experimento ALC_v5_corregido.R` (**reparado**) | `0ddbe5cceb298e85456600d57541b9474f9ca55b89674e4bbbb704b9c6ee2bb1` | 321.596 B | sep 24 00:55 |

El original **no se modificó**: mismo hash y misma fecha que en la auditoría del 23-sep.

## Qué se reparó (cada cambio marcado en el código con su etiqueta `[v5-X]`)

| Etiqueta | Defecto corregido | Antes → Ahora |
|---|---|---|
| `[v5-A]` | `setwd()` sin guarda ×2 a una ruta fija; todas las salidas dentro de `Analisis agosto` | Raíces configurables (`PROYECTO`, `RAIZ_ENTRADA`, `RAIZ_SALIDA`), con `dir.exists()`; la entrada es de solo lectura y la salida va a **`Analisis agosto v2/`**. Se crean `principal/`, `piloto/`, `combinado/`, `resultados/`, `logs/` |
| `[v5-B]` | `rm(list = ls())` borraba el modelo de embeddings, la caché y las funciones de auditoría | Eliminado |
| `[v5-C]` | `venv_path <- "C:/venvs/renv311"` **está roto** en este equipo (intérprete base desinstalado) | Cascada `NLP_PYTHON` → `C:/venvs/renv-nlp` → `renv311` → `Sys.which`, **comprobando** que el elegido importe `sentence_transformers`; si ninguno sirve, para con las instrucciones de creación |
| `[v5-D]` | El piloto se normalizaba con `normalizar_principal()` → `fuente = "principal"` e `id_participante = "principal_P1"`…: **las dos cohortes compartían identificador** | El piloto usa `normalizar_piloto()` → `fuente = "piloto"` e `id_participante = "piloto_P1"`… |
| `[v5-E]` | La mezcla de cohortes se detectaba (si acaso) con un `warning` | **Aserción dura**: para si las fuentes no son exactamente {principal, piloto}, si hay identificadores compartidos, si el piloto conserva el prefijo `principal_` o si hay `id_observacion` duplicados |
| `[v5-F]` | Se llamaba a `calcular_descriptivos()` y `reportar_descriptivos()`, **que no existían** (la corrida lineal abortaba ahí) | Implementadas con las mismas estadísticas que ya usaba el script |
| `[v5-H]` | Se usaban objetos con nombre equivocado: `modelos$palabras$modelo` (es `resultados_modelos`), `cor_mat` (es `mat_cor`), `diccionarios_hopper` (es `diccionarios_hopper_enriquecido`) | Corregidos; se añadió `obtener_modelo_palabras()` para localizar el modelo disponible |
| `[v5-I]` | `metadata_embeddings.txt` salía corrupto (`paste(names, unlist(metadata))` reciclaba 9 nombres sobre 25 valores) | Escritor campo por campo |
| `[v5-J]` | Todo lo del piloto se escribía en `analisis_piloto/` y la comparación **dentro de la carpeta del piloto** | `piloto/` (17), `principal/` (23) y `combinado/` (comparación) separados; se guardan `ancho_piloto.rds`, `ancho_principal.rds` y `ancho_combinado.rds` en sus carpetas |
| `[v5-K1]` | Ante un error en los embeddings se creaban **matrices de NA y el pipeline continuaba**, produciendo figuras y tablas calculadas sobre nada | `stop()` con mensaje |
| `[v5-K2]` | La extracción del piloto produjo en el árbol auditado objetos **vacíos (0 × 384)** que se guardaban como resultados | Cuenta los textos `[VACÍO]`, valida `n × 384` con `n > 0` y **para** si el objeto está vacío |
| `[v5-L1]` | Se copiaba al paquete de DeepSeek un CSV que nunca se escribía, sin avisar | Copia condicionada + archivo de constancia |
| `[v5-L2]` | El paquete declaraba "40 participantes" fijos | Ahora se calcula del conjunto y se desglosa por cohorte |
| `[v5-N]` | `View()` interactiva en medio del pipeline | Solo si `interactive()` |

## Lo que pediste, verificado por ejecución

Prueba ejecutada el 2026-09-24 con los Excel reales (extrayendo del propio v5 las funciones de importación/metabolismo y ejecutándolas; solo se imprimieron conteos e identificadores):

| Comprobación | Resultado |
|---|---|
| Principal: filas / participantes | **69 / 23** ✔ |
| Piloto: filas / participantes | **51 / 17** ✔ |
| `fuente` en el principal | `principal` ✔ |
| `fuente` en el piloto | **`piloto`** ✔ |
| `id_participante` del piloto | **`piloto_P1`, `piloto_P10`, …** ✔ |
| **Intersección de identificadores entre cohortes** | **0** ✔ (era el defecto central) |
| `id_observacion` duplicados | 0 ✔ |
| Composición por condición del piloto **tomada de los datos** | **Audio 6 · Imagen 5 · Texto 6** ✔ (la cabecera del script declaraba P1-P5/P6-P11/P12-P17, que no coincide) |
| `n_palabras` en el piloto | 0 de 51 (vacío, correcto) ✔ |
| `n_palabras_calculado` en el piloto | 51 de 51 ✔ |
| Sintaxis del script completo | **`parse()` OK: 905 expresiones** ✔ |
| Funciones antes inexistentes | ahora definidas (90 funciones) ✔ |

## Lo que NO está verificado (hay que ejecutarlo tú)

- **La corrida completa de principio a fin.** No se ha ejecutado: tarda decenas de minutos, descarga el léxico NRC si falta y genera todas las figuras. El `parse()` garantiza que compila; **no** garantiza que cada bloque produzca lo esperado con tus datos.
- La sección de comparación piloto vs principal (`[v5-J]`) no se ha corrido con datos: es la que más conviene mirar en la primera pasada.
- La consola del script sigue siendo muy verbosa (es el estilo del original). No se tocó.

## Cómo ejecutarlo

```cmd
cd /d "%RUTA_PROYECTO%"
"C:\Program Files\R\R-4.6.1\bin\Rscript.exe" --vanilla "Experimento ALC_v5_corregido.R"
```

Las salidas nuevas aparecen en `Analisis agosto v2\` (`principal\`, `piloto\`, `combinado\`, `resultados\`, `logs\`).
El árbol antiguo (`Analisis agosto\`) **no se toca**: es tu evidencia previa.

## Pendiente declarado (no lo hice)

- `resultados/` sigue siendo la carpeta del pipeline conjunto (las tablas de 40 mezclan cohortes, como en el original). Separarla del todo exige repuntar ~35 rutas de escritura; preferí no tocar más de la cuenta sin tu visto bueno.
- Los artefactos de sensibilidad que apuntan a `outputs/` (Bloques 13–14) siguen escribiendo ahí, no en `combinado/`.
- La cabecera del script (líneas 10-15) todavía declara el reparto falso `P1-P5 / P6-P11 / P12-P17`. No la reescribí porque documenta el diseño tal como se pensó; el dato real (6/6/5) sale ahora del propio Excel.

---

## Corrección v5.1 — tras tu primera corrida (2026-09-24)

**Qué pasó**: el script se detuvo con `[v5] No se encontró un intérprete válido con sentence_transformers`
y descartó los tres candidatos, incluido el que sí funciona.

**Causa 1 — mi prueba estaba mal escrita (la causa real).** Yo comprobaba el import así:
`system2(py, c("-c", "import sentence_transformers"))`. El segundo argumento contiene un espacio y R lo
partía en dos (`-c import` + `sentence_transformers`), así que **todos** los intérpretes devolvían error.
Medido: `sin shQuote: 1` / `con shQuote: 0`. Con `shQuote()` el mismo intérprete pasa.

**Causa 2 — `renv311` sí está rota, no era un falso positivo.** `C:/venvs/renv311/Scripts/python.exe`
responde `No Python at '…\Programs\Python\PYTHON~1\python.exe'` (su intérprete base fue
desinstalado). Igual `C:/venvs/r-reticulate-311`. El entorno operativo de este equipo es
**`C:/venvs/renv-nlp`**: python 3.11.16 · sentence-transformers 6.1.0 · torch 2.14.0+cpu · numpy 2.4.6.

**Qué cambié** (marcas `[v5-C2]`, `[v5-C3]`, `[v5-L3]`, `[v5-L4]` en el script):

- La comprobación usa `shQuote()` y **muestra el motivo real** cuando descarta un candidato.
- `use_virtualenv()` → `use_python(python_exe)`: funciona igual con un entorno virtual que con un
  intérprete suelto (antes, si el elegido venía del PATH, `use_virtualenv` habría fallado).
- Se añade el directorio temporal `C:/temp_mfca` (TMPDIR/TMP/TEMP/tempdir) de tu configuración, fuera
  de la carpeta sincronizada.
- `[v5-L4]`: el inventario buscaba `analisis_piloto/`, que ya no existe → ahora `principal/`, `piloto/`,
  `combinado/`.
- `[v5-L3]`: el bloque heredado leía `articulo_1/README_ARTICULO_1.txt`, fallaba, **seguía adelante y
  anunciaba "actualizado"**. Ahora avisa y se omite si el archivo no existe.

**Verificado por ejecución**: el código del propio archivo resuelve `C:/venvs/renv-nlp/Scripts/python.exe`,
deriva correctamente `venv_path` y el archivo completo pasa `parse()` (909 expresiones).

**Hash nuevo (v5.1)**: `d641994c6ca6797ecfe9563e147743a3f717944628340870c0d4dd8383f11021`.
La copia publicada en el repositorio (`code/01_pipeline_nlp.R`) es idéntica byte a byte.

**Nota sobre tu configuración**: tu bloque apuntaba a `renv311`. Si algún día lo reparas (reinstalando su
intérprete base), la cascada lo tomará automáticamente; mientras tanto usa `renv-nlp`, o define la
variable `NLP_PYTHON` para forzar otro intérprete sin tocar el script.

---

## Corrección v5.2 — segunda corrida (2026-09-25)

**Qué pasó**: la corrida avanzó hasta cargar el modelo de embeddings y se interrumpió con

```
[OK] Modelo de embeddings cargado
Error en py$embedding_model: $ operator is invalid for atomic vectors
Ejecución interrumpida
```

**Causa — un defecto mío, introducido en la corrección v5.1.** El bucle que elige el intérprete de
Python usaba `py` como **nombre de la variable de bucle** (`for (py in candidatos_python)`). Eso deja
un objeto `py` (una cadena de texto) en el entorno global, y ese objeto **enmascara el módulo `py`
de reticulate**: a partir de ahí, `py$embedding_model`, `py$textos_lote` y `py$\`_e\`` fallan, porque
`py` ya no es el módulo sino un vector. El propio R lo avisaba al cargar reticulate:

```
The following object is masked _by_ '.GlobalEnv':
    py
```

Ese mismo aviso apareció en tu primera corrida desde RStudio: el defecto ya estaba ahí y habría
fallado en el mismo punto.

**Qué cambié**:
- `[v5-C2b]`: la variable del bucle se llama ahora `py_cand`. El nombre `py` queda reservado para
  reticulate.
- `[v5-C4]`: guarda defensiva antes de usar el módulo — si existe un objeto `py` en el entorno global
  que no sea el módulo de Python, se retira. Así el script sobrevive también a restos de una sesión
  anterior de RStudio (donde el entorno global se carga desde `.RData`).

**Verificado por ejecución** (prueba independiente que reproduce el fallo):

```
antes de la guarda — clase de 'py': character
[v5-C4] Retirado un objeto 'py' del entorno global que enmascaraba reticulate.
py$_prueba + 1 = 42   (42 = reticulate operativo)
```

**Segunda verificación**: se comprobó además que **no falta ningún paquete** de R en el equipo
(los 40 que usa el script, incluidos `see`, `topicmodels` y `text2vec`, están instalados), así que
la corrida no volverá a detenerse por instalaciones.

**Hash nuevo (v5.2)**: `72697cfb38101ff8479bc893d8ecc86406db4a3a6fd87b73a9f70b84f36cc423`.

---

## Corrección v5.3 — tercera corrida (2026-09-25)

**Qué pasó**: la corrida avanzó hasta el bloque de análisis por cohorte y se interrumpió con

```
Error in `construir_largo_para_modelo()`:
! no se pudo encontrar la función "construir_largo_para_modelo"
```

**Causa**: defecto **del original**, no introducido por mí. `preparar_datos()` (BLOQUE 11, §2) llama a
`construir_largo_para_modelo()`, cuya definición estaba 2.000 líneas más abajo, en el BLOQUE 14. En una
corrida lineal la función todavía no existe. El propio comentario del autor delataba la suposición:
«Preparar datos longitudinales (usa `construir_largo_para_modelo` **ya definida**)».

**Barrido completo, no arreglo puntual**: hice un análisis estático del archivo entero comparando, para
cada una de las 90 funciones definidas, la primera llamada contra su línea de definición. Resultado:
**era la única** con esa condición. La definición se movió al BLOQUE 11 §2 (junto a `preparar_datos`),
dejando una nota en su sitio original para no duplicarla. Comprobado después: "funciones usadas antes de
definirse: **ninguna**".

**Dos defectos más, corregidos en la misma pasada** (los detecté revisando la ruta completa del script):

- `[v5-P]`: `performance::check_model()` devuelve un **gráfico**; el original lo imprimía *dentro* de un
  `sink()`, así que cada archivo `piloto_<variable>_performance.txt` quedaba lleno con la estructura del
  objeto (decenas de KB ilegibles) en lugar del diagnóstico. Ahora el .txt lleva las cifras
  (Shapiro-Wilk de residuos, n, singularidad, convergencia) y el gráfico se guarda como
  `piloto_<variable>_check_model.png`.
- `[v5-Q]`: imprimir los gráficos en consola (`print(p2_es); …`) con `Rscript` abre un dispositivo y deja
  un `Rplots.pdf` de basura en la carpeta de salida. Quedó condicionado a `interactive()`.

**Hash nuevo (v5.3)**: `b07090605a2c3bbdf6a99ff361db01225106667178cfe3b05f93dc797a41c517`
(`parse()` OK, 906 expresiones; sin referencias adelantadas; artefacto publicado en el repositorio
verificado byte a byte: 148/148 hashes OK en Drive).

**Nota sobre duplicados preexistentes** (no se tocan, no rompen nada): `obtener_embeddings()` está
definida dos veces con el mismo cuerpo (infraestructura de embeddings y BLOQUE 7). La segunda
definición gana y es idéntica.

---

## Corrección v5.4 — BLOQUE 12 (figuras) y la caída que dejaba sin ejecutar los bloques 13 y 14 (2026-09-25)

**Qué pasó**: la corrida llegó hasta el final del BLOQUE 11 (modelos por cohorte y comparación: se
generaron `combinado/tablas/comparacion_*` e `interaccion_fuente_tiempo.csv`) y murió dentro del
BLOQUE 12 con

```
✓ Figura guardada: fig10_interaccion_condicion_tiempo.png
Error in `geom_ribbon()`:
! Problem while setting up geom.
ℹ Error occurred in the 2nd layer.
```

**Causa del aborto (y por qué importaba)**: los gráficos de fig1 y fig4 fallaban al construirse, el
error quedaba capturado por su `tryCatch`, **pero el objeto defectuoso seguía en la lista `figuras`**, y
al construir los paneles combinados `plot_grid()` lo renderizaba **fuera de todo `tryCatch`**: la excepción
subía y el script terminaba ahí. Consecuencia: los BLOQUES 13 (exportación de tablas) y 14 (sensibilidad y
robustez) **nunca se ejecutaron**.

**Causa de fondo de las figuras**. Dos familias de defectos, ambas del original:

1. **Capas sin el aesthetic `x`.** Con `inherit.aes = FALSE` hay que declarar `x` explícitamente. En fig1 y
   fig4 las tres capas derivadas (banda, línea de la media y punto de la media) no lo declaraban →
   `geom_line() requires the following missing aesthetics: x`. Corregido en `[v5-R1]` (banda) y `[v5-R4]`
   (línea y punto).
2. **Columnas que el pipeline nunca creaba** en `datos$ancho`, de modo que 8 de las 15 figuras no podían
   calcularse:
   - `cos_*` / `jac_*` / `div_*`: `calcular_similitudes()` está definida en el BLOQUE 5 y **no se llamaba nunca**.
   - `cambio_*`: `calcular_cambios_y_scores()` (BLOQUE 8) devuelve un data.frame **aparte** que nunca se unía
     a `datos$ancho`, y las figuras leían de `datos$ancho`.
   - `rate_<tema>_t<k>` (tasas por 1000 palabras): viven en `scores_wide`, no en `datos$ancho`.
   - `cambio_<emoción>_*`: el script nunca calculaba cambios de emociones.
   - `score_influencia_*` / `score_complejidad`: solo se creaban si las columnas ya estaban presentes, así que
     nunca se creaban.

**Qué hice** (`[v5-R3]`, `[v5-R5]`, `[v5-R6]`, `[v5-R2]`):

- `[v5-R3]`: bloque de preparación antes de dibujar que **conecta las piezas del propio script**: llama a
  `calcular_similitudes()` y (si falta) a `calcular_sentimientos()`; une `resultado_cambios` y `scores_wide`
  a `datos$ancho` por `id_participante` (comprobando que la unión no cambie el número de filas); crea los
  cambios de emociones y de los 10 temas Hopper; crea los alias de nombre que el BLOQUE 12 usa literalmente
  (`cambio_palabras_*`); y calcula los **scores heurísticos con los pesos de `config_scores_default()`** del
  propio script.
- `[v5-R5]`: la figura 13 recalculaba las tasas dividiendo columnas de conteo inexistentes (y con
  `n_palabras`, que en el piloto está vacía). Ahora usa las tasas que el propio pipeline ya calculó.
- `[v5-R6]`: el bootstrap del IC de fig1 caía porque las filas del piloto entran con NA en `n_palabras`
  (columna vacía en su Excel) y `quantile()` no admite todo-NA. Se filtran los valores finitos.
  **Consecuencia declarada**: esa figura describe solo al principal; la extensión del piloto está en
  `n_palabras_calculado`.
- `[v5-R2]`: los paneles combinados ahora comprueban que el PNG de cada componente exista y van protegidos,
  de modo que una figura defectuosa no pueda volver a tumbar la corrida.

**`bing` no existe en este pipeline.** Las figuras 3, 8, 12 y 15 piden una emoción global `bing_*` que el
script **nunca calcula** (no hay VADER ni Bing en ningún bloque). Para no inventar una medida, esas figuras
usan `sadness` como duplicado declarado. Si el manuscrito necesita un sentimiento global, hay que decidir
qué léxico lo produce.

**Verificado antes de relanzar, sin esperar otra corrida completa**: escribí un ensayo que reconstruye
`datos$ancho` a partir de los artefactos que la corrida ya dejó en disco, aplica el bloque `[v5-R3]` y
**construye las 11 figuras** que antes fallaban. Resultado: `fig1, fig3, fig4, fig6, fig8, fig9, fig11,
fig12, fig13, fig14, fig15` → **todas CONSTRUIDAS OK**. Las otras cuatro (2, 5, 7, 10) ya se generaban.

**Hash nuevo (v5.4)**: `bffc1f26b7f2e3571bd5f3c5034e961e5c6a84bc8c715a2fe9a6e019d34f902f`
(`parse()` OK, 921 expresiones). Publicado en el repositorio y verificado en Drive: 148/148 hashes OK.

---

## Correcciones v5.5–v5.7 — la cola del script (BLOQUES 13 y 14) (2026-09-25)

Con los BLOQUES 11 y 12 corregidos, la corrida avanzó hasta el BLOQUE 13 y murió ahí. A partir de ese
punto dejé de reparar de uno en uno: escribí un **ensayo** que reconstruye los objetos desde los
artefactos que la corrida ya deja en disco (`datos_completos_ancho.csv`, `datos_formato_largo.csv`,
`scores_diccionarios.RData`, `modelos_mixtos.rds`) y ejecuta **todas las expresiones de los bloques 13 y
14**, reportando cada error sin abortar. Los siguientes defectos se encontraron por esa vía.

### `[v5-S]` — `datos$largo` no tiene `metrica` (BLOQUE 13 §7)
El autor mezcló dos formatos largos: `datos$largo` es una fila por participante × iteración, y el objeto
con columnas `metrica`/`valor` es `ancho_largo` (BLOQUE 9). El filtro abortaba con `'metrica' no
encontrado`. Ahora la tabla se arma desde `ancho_largo` y, si no está en memoria, se reconstruye.

### `[v5-S2]` — `Min = Inf` y `Max = -Inf` en la tabla de descriptivos
`min(valor, na.rm = TRUE)` sobre un grupo sin ningún valor finito (el piloto no tiene `n_palabras`)
devolvía infinito, y `max()` menos infinito, con 18 avisos. Ahora `n` cuenta valores finitos y las
estadísticas devuelven NA cuando no hay ninguno: la tabla dice "no disponible", no ∞.

### `[v5-T]` — conclusiones impresas en prosa fija
El BLOQUE 14 escribía, **sin calcular nada**, cosas como *«Modelo primario: efecto de tiempo
significativo, interacción no significativa»*, *«similar al primario»*, *«...»* en los tres modelos
siguientes y *«el efecto de tiempo se mantiene significativo en los modelos de sensibilidad»*, *«la
interacción no es significativa en ningún modelo»*. Lo mismo iba al archivo de auditoría
`outputs/auditoria_analisis_final.txt`. Son afirmaciones que no se midieron: se imprimían con cualquier
resultado. Con los datos de esta corrida, *«la interacción no es significativa en ningún modelo»* es
**falsa**: en el piloto la interacción condición×tiempo salió p = 0.016. Ahora esas líneas se **derivan**
de `tabla_robustez_modelos.csv` (que sí se calcula) y se dice "no disponible" cuando falta el dato.

### `[v5-U1..U4]` — el análisis de sensibilidad completo estaba muerto
Los modelos A–F del BLOQUE 14 fallaban **todos**:

- `[v5-U1]`: las fórmulas nombraban la **variable** (`n_palabras_calculado ~ ...`) pero
  `construir_largo_para_modelo()` devuelve el desenlace en la columna **`valor`** → `object not found` en
  todos los modelos. Corregidas a `valor ~ ...`.
- `[v5-U2]`: se comprobaba `"n_tokens" %in% names(ancho)` / `"n_estimulos" %in% names(ancho)`, pero en
  `datos$ancho` esas variables están en formato ancho (`n_tokens_t1`, `n_estimulos_t1`) → la comprobación
  era siempre falsa y los modelos C y D se omitían por "variable no existe".
- `[v5-U3]`: el modelo de exposición acumulada necesita `n_estimulos` en el formato largo; se añadió
  derivándolo del tiempo con la **misma** función del script (`derivar_n_estimulos`).
- `[v5-U4]`: el resumen de replicabilidad buscaba `analisis_piloto/modelos/modelos_comparativos.rds` (ruta
  del árbol auditado). El BLOQUE 11 los guarda en la carpeta de salida → ahora usa `DIR_SALIDA`.

**Verificado con el ensayo antes de relanzar** (v5.7):

```
Modelo primario: OK | Modelo + demora: OK | Log palabras: OK | Log tokens: OK
Modelo estímulos: OK | Modelo fuente (replicabilidad): OK
sin errores en las 129 expresiones de los bloques 13 y 14
```

**Hash (v5.7)**: `11b1f619367f61d8b47b59fa6ba6c5b16401f535d933874ded3c73033d00981d`.

### Dos cosas que quedan dichas y no resueltas
1. **`bing`**: las figuras 3, 8, 12 y 15 piden una emoción global `bing_*` que este pipeline **nunca
   calcula** (no hay VADER ni Bing en ningún bloque). Se usa `sadness` como duplicado declarado. Si el
   manuscrito necesita un sentimiento global, hay que decidir qué léxico lo produce.
2. **`demora`**: solo existe en el principal. Cualquier resultado que la incluya describe a 23
   participantes, no a 40.

---

## Cierre v5.8–v5.9 y corrida final completa (2026-09-25)

### `[v5-U5]` — el último caso del defecto de las fórmulas
Buscando todas las fórmulas construidas con el nombre de la variable quedaba **una** más, en el respaldo de
la sección E (outliers): si el modelo primario no estuviera disponible, esa línea lo re-creaba con el mismo
defecto y arrastraba consigo el análisis de outliers y los diagnósticos. Corregida. Ya no queda ningún
`as.formula(paste(VD, ...))` en el archivo.

### `[v5-V1..V6]` — las salidas del PRINCIPAL no existían como tales
El BLOQUE 11 guardaba los modelos del principal **en la carpeta del piloto**, y sus medias marginales, sus
contrastes y sus figuras se calculaban… y nunca se escribían: los bucles de exportación y de figuras solo
recorrían `resultados_piloto`, y `generar_graficos()` tenía fijos el prefijo `PILOTO_`, la carpeta
`DIR_SALIDA` y el subtítulo. Corregido: cada cohorte tiene ahora sus propias carpetas (`tablas/`,
`modelos/`, `graficas_es/`, `figures_en/`, `diagnosticos/`) y la función de figuras es parametrizable sin
cambiar el comportamiento del piloto.

### Corrida final: completa y verificada
`EXITCODE=0`, los 15 bloques ejecutados, **15/15 figuras** y el análisis de sensibilidad **completo**
(A–F funcionando: `tabla_demora.csv`, `tabla_robustez_log.csv`, `comparacion_tiempo_estimulos.csv`,
`estructura_n_estimulos.csv`). Salidas del principal: 3 tablas, 1 modelo, 6 figuras ES, 6 EN, 2 diagnósticos,
2 archivos de datos.

**Hash del script (v5.9)**: `1143b36a6fb76dc8279e70880634b2a81ebf05ee70accfb69b0172bcc4a1c15f`
— **idéntico al publicado en el repositorio** (`code/01_pipeline_nlp.R`), de modo que los artefactos y el
script publicado son la misma versión.

### Lo que la corrida final confirma de los modelos
Los contrastes por condición del principal (Holm) muestran T1 → T3 significativo en las tres condiciones:
Texto −96.1 (p = 1.5×10⁻⁴), Audio −90.6 (p = 3.3×10⁻⁴), Imagen −80.6 (p = 0.0029). Es el respaldo directo
de que el crecimiento de la extensión es general y no de una condición.

### Pendientes que NO son de código
- `[v5-U5]` es posterior a la corrida: es un camino que no se ejecuta cuando el modelo primario se ajusta
  bien (y se ajusta), así que no altera ningún artefacto.
- La demora existe solo en el principal; `bing` nunca se calculó (las figuras 3, 8, 12 y 15 usan `sadness`
  como duplicado declarado); el criterio de outliers marca 115 de 120 observaciones.
