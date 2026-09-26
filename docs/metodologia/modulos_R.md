```markdown
# R/ — Módulos analíticos del experimento NLP

Este directorio contiene todos los módulos de análisis del pipeline del experimento.  
Cada archivo `.R` encapsula una etapa del procesamiento, desde la importación de datos hasta los análisis de sensibilidad.  
El flujo está diseñado para ser ejecutado desde el script principal `run_analysis.R` (ubicado en la raíz del repositorio), el cual carga secuencialmente estos módulos mediante `source()`.

---

## 1. Propósito de la carpeta

La carpeta `R/` agrupa las funciones y configuraciones necesarias para:

- Importar y normalizar los datos crudos (principal y piloto).
- Procesar textos (limpieza, tokenización, métricas lingüísticas).
- Analizar sentimiento con el léxico NRC-ES.
- Construir y aplicar diccionarios temáticos (Hopper).
- Generar embeddings semánticos y calcular prototipos.
- Calcular similitudes textuales (tokens) y semánticas (embeddings).
- Ajustar modelos lineales mixtos y realizar pruebas inferenciales.
- Generar figuras científicas y paneles.
- Ejecutar análisis de sensibilidad y robustez.

Cada módulo es autocontenido, con responsabilidades bien definidas, y depende únicamente de los módulos anteriores (o de configuraciones globales).

---

## 2. Arquitectura general

El flujo conceptual (y real) del pipeline es el siguiente:

```text
00_config.R          ← Configuración global, librerías, logging, Python
       ↓
01_import_data.R     ← Importación y normalización (principal + piloto)
       ↓
02_text_processing.R ← Limpieza, tokenización, métricas lingüísticas
       ↓
03_sentiment.R       ← Léxico NRC-ES y análisis de sentimiento
       ↓
04_dictionaries.R    ← Diccionarios Hopper (enriquecimiento y aplicación)
       ↓
05_embeddings.R      ← Embeddings, prototipos, PCA (funciones)
       ↓
06_similarity.R      ← Similitudes textuales (coseno y Jaccard)
       ↓
07_models.R          ← Modelos mixtos, pruebas inferenciales, bootstrap
       ↓
08_visualization.R   ← Figuras y temas gráficos
       ↓
09_sensitivity.R     ← Análisis de sensibilidad y robustez
```

**Nota:** El orden real de ejecución en `run_analysis.R` sigue este flujo.  
`05_embeddings.R` contiene funciones, pero la ejecución de embeddings, prototipos y PCA se realiza en el script principal (no dentro del módulo).  
`09_sensitivity.R` orquesta los análisis de sensibilidad, pero utiliza funciones definidas en `07_models.R`.

---

## 3. Tabla de módulos

| Módulo | Archivo | Responsabilidad | Entradas | Salidas | Dependencias | Estado |
| ------ | ------- | --------------- | -------- | ------- | ------------ | ------ |
| Configuración | `00_config.R` | Carga de librerías, opciones globales, logging, entorno Python | Ninguna | Objetos globales (opciones, funciones de logging, configuración Python) | Ninguna | **IMPLEMENTADO** |
| Importación | `01_import_data.R` | Importación de Excel, normalización a esquema canónico, validación, integración de fuentes, generación de formato ancho | Archivos Excel (principal y piloto) | `datos_maestros_long`, `datos_maestros_ancho` y funciones | `00_config.R` | **IMPLEMENTADO** |
| Procesamiento de texto | `02_text_processing.R` | Limpieza de texto, tokenización, cálculo de métricas lingüísticas (TTR, oraciones, etc.) | Objeto `datos` (con columnas de texto) | Objeto `datos` enriquecido con columnas `*_limpio`, `*_tokens` y métricas | `00_config.R` | **IMPLEMENTADO** |
| Sentimiento | `03_sentiment.R` | Descarga, validación y aplicación del léxico NRC-ES | Objeto `datos` (con columnas `t1_limpio`, etc.) | Objeto `datos` con columnas de emociones (joy, sadness, etc.) | `00_config.R`, `02_text_processing.R` | **IMPLEMENTADO** |
| Diccionarios Hopper | `04_dictionaries.R` | Definición de diccionarios base, enriquecimiento empírico (PMI), cálculo de cobertura, aplicación a datos | `datos_maestros_long`, diccionarios base | Diccionarios enriquecidos, `scores_long`, `scores_wide` | `00_config.R`, `02_text_processing.R` | **IMPLEMENTADO** |
| Embeddings | `05_embeddings.R` | Funciones para obtener embeddings, construir prototipos, calcular similitud coseno entre matrices | Textos (vectores de caracteres) | Matrices de embeddings, centroides de prototipos | `00_config.R`, entorno Python con `sentence-transformers` | **IMPLEMENTADO** (funciones) |
| Similitud textual | `06_similarity.R` | Cálculo de similitud coseno y Jaccard basados en frecuencia de tokens | Objeto `datos` con columnas `t1_tokens`, etc. | Objeto `datos` con columnas `cos_*`, `jac_*`, `div_*` | `00_config.R` | **IMPLEMENTADO** |
| Modelos mixtos | `07_models.R` | Cálculo de cambios, scores heurísticos, pruebas pareadas/Friedman, ajuste de LMM, bootstrap, diagnóstico | Objeto `datos$ancho` | Tablas de resultados, modelos ajustados, correlaciones | `00_config.R`, paquetes de modelado | **IMPLEMENTADO** |
| Visualización | `08_visualization.R` | Definición de paletas, temas y funciones para generar figuras científicas (15 figuras + paneles) | Datos, modelos, matrices de correlación, diccionarios | Objetos `ggplot` y archivos PNG/PDF | `00_config.R`, `07_models.R` (para emmeans) | **IMPLEMENTADO** |
| Sensibilidad | `09_sensitivity.R` | Ejecución de análisis de sensibilidad (modelos alternativos, outliers, robustez) | `datos$ancho` | Tablas de robustez, gráficos de diagnóstico, auditoría | `00_config.R`, `07_models.R`, `08_visualization.R` | **IMPLEMENTADO** |

---

## 4. Documentación individual de cada módulo

### 00_config.R

**Propósito:**  
Configurar el entorno de trabajo global: opciones, semilla, carga de librerías, sistema de logging y configuración del entorno Python (reticulate).

**Responsabilidades:**  
- Establecer opciones de R (`stringsAsFactors`, `scipen`, etc.) y semilla aleatoria.
- Definir e instalar paquetes necesarios (si faltan).
- Cargar todos los paquetes requeridos.
- Proveer una función `registrar_log()` para trazar la ejecución.
- Configurar la ruta del ejecutable de Python y activar el entorno virtual mediante `reticulate`.

**Paquetes utilizados:**  
`tidyverse`, `tidytext`, `readxl`, `stringr`, `stringi`, `tokenizers`, `stopwords`, `text2vec`, `proxy`, `tm`, `syuzhet`, `lme4`, `lmerTest`, `emmeans`, `performance`, `effectsize`, `rstatix`, `effsize`, `car`, `topicmodels`, `ggplot2`, `cowplot`, `viridis`, `corrplot`, `RColorBrewer`, `ggraph`, `igraph`, `wordcloud`, `readr`, `scales`, `writexl`, `ggpubr`, `gridExtra`, `broom.mixed`, `patchwork`, `see`, `FSA`, `rcompanion`.

**Opciones globales:**  
- `stringsAsFactors = FALSE`  
- `scipen = 999`  
- `max.print = 1000`  
- `warn = 1`  
- `digits = 4`  
- `set.seed(20260526)`

**Objetos creados:**  
- `instalar_paquetes` (función)  
- `paquetes_necesarios` (vector)  
- `registrar_log` (función)  
- Variables de entorno Python: `venv_path`, `python_exe` (configuradas, pero no se usa el modelo de embeddings en este archivo).

**Funciones definidas:**  
- `instalar_paquetes(pkgs, repo)`  
- `registrar_log(mensaje, nivel = "INFO", archivo = "experimento_log.txt")`

**Parámetros relevantes:**  
- `venv_path`: ruta al entorno virtual de Python (por defecto `"C:/venvs/renv311"`).  
- `python_exe`: ruta al ejecutable de Python dentro de ese entorno.

**Dependencias:**  
Ninguna (es el primer módulo).

**Archivos de entrada:**  
Ninguno (solo dependencias de sistema).

**Archivos de salida:**  
Archivo de log (opcional, `experimento_log.txt`).

**Relación con otros módulos:**  
Todos los módulos dependen de este archivo, ya que proporciona las librerías y el logging.

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- La ruta de Python (`venv_path`) es absoluta y puede no existir en otros sistemas. Se recomienda parametrizarla mediante variables de entorno o un archivo de configuración.
- La instalación de paquetes al inicio puede ser lenta y no siempre funciona en entornos restringidos.

---

### 01_import_data.R

**Propósito:**  
Importar y normalizar los datos crudos (principal y piloto) a un esquema canónico común, integrar ambas fuentes y generar formato ancho.

**Responsabilidades:**  
- Derivar `n_estimulos` a partir de la iteración.
- Importar el dataset principal (Excel) y el piloto (Excel en formato largo).
- Normalizar ambos datasets al esquema canónico (columnas: `fuente`, `participante`, `id_participante`, `id_observacion`, `condicion`, `demora`, `iteracion`, `texto`, `n_palabras`, `n_palabras_calculado`, `n_estimulos`).
- Validar la estructura y consistencia de los datos.
- Integrar múltiples fuentes en un único dataframe largo.
- Generar el formato ancho (columnas por iteración).

**Paquetes utilizados:**  
`dplyr`, `tidyr`, `purrr`, `readxl`, `stringr` (heredados de 00_config).

**Objetos creados:**  
Funciones (no objetos de datos).

**Funciones definidas:**  
- `derivar_n_estimulos(iteracion)`  
- `importar_principal(ruta, hoja = "Datos_Largo")`  
- `importar_piloto(ruta, hoja = "Hoja1")`  
- `normalizar_principal(raw)`  
- `normalizar_piloto(raw)`  
- `validar_esquema(df, nombre = "dataset")`  
- `validar_dataset_maestro(df)`  
- `integrar_fuentes(lista_dfs)`  
- `generar_ancho(df_long)`  
- `validar_datos(datos)`

**Parámetros relevantes:**  
- `ruta`: ruta al archivo Excel.  
- `hoja`: nombre de la hoja dentro del Excel.

**Dependencias:**  
`00_config.R` (para `registrar_log` y librerías).

**Archivos de entrada:**  
- `Datos Exp Interrelacion.xlsx` (principal).  
- `piloto_interrelacion_formato_largo.xlsx` (piloto).

**Archivos de salida:**  
Ninguno (los datos se devuelven como objetos R).

**Relación con otros módulos:**  
Es el segundo módulo; sus salidas (`datos$largo` y `datos$ancho`) serán utilizadas por todos los módulos posteriores.

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- La función `importar_piloto` asume una estructura fija de columnas (A, E:K, etc.) que puede variar si el Excel cambia.  
- `validar_esquema` contiene comprobaciones que detienen la ejecución si fallan, lo que es adecuado para QA, pero puede ser demasiado estricto en algunos casos.

---

### 02_text_processing.R

**Propósito:**  
Procesar los textos: limpieza, tokenización y cálculo de métricas lingüísticas básicas.

**Responsabilidades:**  
- Limpiar texto (minúsculas, transliteración ASCII, eliminación de dígitos y puntuación).  
- Tokenizar eliminando stopwords en español y palabras cortas (< 3 caracteres).  
- Aplicar limpieza y tokenización a las columnas de texto en formato ancho (T1, T2, T3).  
- Calcular métricas lingüísticas: número de tokens, número de oraciones, TTR (type‑token ratio), longitud media de palabra, palabras por oración.

**Paquetes utilizados:**  
`dplyr`, `stringr`, `stringi`, `purrr`, `stopwords`.

**Objetos creados:**  
Funciones.

**Funciones definidas:**  
- `limpiar_texto(texto)`  
- `tokenizar(texto, min_chars = 3)`  
- `preprocesar_textos(datos)`  
- `calcular_metricas_linguisticas(texto_orig, tokens)`  
- `agregar_metricas(datos)`

**Parámetros relevantes:**  
- `min_chars`: longitud mínima de token (por defecto 3).

**Dependencias:**  
`00_config.R` (librerías y `registrar_log`).

**Archivos de entrada:**  
Objeto `datos` con columnas `texto_t1`, `texto_t2`, `texto_t3`.

**Archivos de salida:**  
Objeto `datos` con columnas `*_limpio`, `*_tokens` y métricas (`n_tokens_*`, `ttr_*`, etc.).

**Relación con otros módulos:**  
Es consumido por `03_sentiment.R`, `04_dictionaries.R`, `05_embeddings.R`, `06_similarity.R`, entre otros.

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- La función `limpiar_texto` usa `iconv(..., to="ASCII//TRANSLIT")`, que puede perder tildes y caracteres especiales; aunque es coherente con el léxico NRC-ES.  
- El cálculo de oraciones con `stri_count_boundaries` puede no ser perfecto para textos con abreviaturas.

---

### 03_sentiment.R

**Propósito:**  
Gestionar el léxico NRC-ES (descarga, validación, almacenamiento local) y realizar análisis de sentimiento sobre los textos.

**Responsabilidades:**  
- Definir constantes (URL, rutas, emociones).  
- Proporcionar una normalización específica para el léxico.  
- Descargar el archivo ZIP oficial, extraer el Excel, procesar las traducciones al español y construir el léxico.  
- Validar la integridad del léxico.  
- Inicializar el léxico (cargar desde local o descargar si no existe).  
- Analizar el sentimiento de un texto (conteo de palabras por emoción).  
- Aplicar el análisis a todo el dataset (columnas `t1_limpio`, etc.) y añadir columnas de emociones.

**Paquetes utilizados:**  
`readxl`, `curl`, `dplyr`, `tidyr` (además de los ya cargados en 00_config).

**Objetos creados:**  
- Constantes (`RUTA_LEXICO_LOCAL`, `URL_NRC_ZIP`, `EMOCIONES_NRC`, etc.).  
- Función `.lexico_nrc_es` (global, creada por `inicializar_lexico`).

**Funciones definidas:**  
- `normalizar_palabra_lexico(palabra)`  
- `validar_lexico_nrc_es(lexico, detener = TRUE)`  
- `preparar_lexico_nrc_es()`  
- `inicializar_lexico()`  
- `analizar_sentimiento_es(texto)`  
- `calcular_sentimientos(datos)`

**Parámetros relevantes:**  
- `detener`: si la validación falla, detiene la ejecución.  
- `RUTA_LEXICO_LOCAL`: por defecto `"data/lexicons/nrc_es.rds"`.

**Dependencias:**  
`00_config.R`, `02_text_processing.R` (para `limpiar_texto` y `tokenizar`).

**Archivos de entrada:**  
- Archivo ZIP descargado de internet (primera vez).  
- Objeto `datos` con columnas `t1_limpio`, `t2_limpio`, `t3_limpio`.

**Archivos de salida:**  
- Léxico guardado en `data/lexicons/nrc_es.rds` (para uso offline).  
- Objeto `datos` enriquecido con columnas de emociones (`joy_*`, `sadness_*`, etc.).

**Relación con otros módulos:**  
Los resultados (columnas de emociones) son utilizados por `07_models.R` (para scores heurísticos) y por `08_visualization.R` (figuras emocionales).

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- Dependencia de conexión a internet para la primera descarga; si falla, el pipeline se detiene.  
- La ruta `data/lexicons/` debe existir o el módulo la crea, pero depende de permisos de escritura.  
- El léxico construido puede tener palabras normalizadas que no coincidan exactamente con los tokens generados por `tokenizar` (aunque ambas usan transliteración).

---

### 04_dictionaries.R

**Propósito:**  
Definir y enriquecer diccionarios temáticos basados en la estética de Hopper, y aplicarlos a los datos.

**Responsabilidades:**  
- Proveer diccionarios base (10 temas).  
- Preparar un corpus tokenizado a partir de los datos largos.  
- Extraer candidatos a nuevas palabras para cada tema usando PMI y filtros de frecuencia.  
- Enriquecer los diccionarios con términos seleccionados manualmente (simulados en el script principal).  
- Calcular cobertura y detectar solapamientos entre temas.  
- Aplicar diccionarios al dataset largo, generando scores (conteos brutos) y tasas normalizadas por 1000 palabras.

**Paquetes utilizados:**  
`dplyr`, `tidyr`, `purrr`, `stringr`.

**Objetos creados:**  
- `diccionarios_hopper_base` (lista de vectores).  
- Funciones.

**Funciones definidas:**  
- `preparar_corpus(datos_long)`  
- `extraer_candidatos(corpus, diccionarios, min_freq = 5, min_doc = 3, min_part = 2)`  
- `enriquecer_diccionarios(base_dict, candidatos_aceptados)`  
- `calcular_cobertura(corpus, diccionario, nombre)`  
- `detectar_solapamientos(diccionarios)`  
- `aplicar_diccionarios_long(datos_long, diccionarios)`

**Parámetros relevantes:**  
- `min_freq`, `min_doc`, `min_part`: umbrales para considerar candidatos.  
- `candidatos_aceptados`: lista de términos añadidos manualmente (definida en `run_analysis.R`).

**Dependencias:**  
`00_config.R`, `02_text_processing.R` (para `limpiar_texto` y `tokenizar`).

**Archivos de entrada:**  
- `datos_maestros_long` (dataframe largo).  
- Diccionarios base.

**Archivos de salida:**  
- Diccionarios enriquecidos (objeto R).  
- `scores_long` y `scores_wide` (dataframes con conteos y tasas).  
- Archivos guardados (opcionalmente) en `data/processed/`.

**Relación con otros módulos:**  
Los scores generados son utilizados por `07_models.R` (para modelos) y `08_visualization.R` (figuras de diccionarios).

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- La extracción de candidatos puede ser computacionalmente costosa para corpus grandes.  
- La selección manual de candidatos (`candidatos_aceptados`) está simulada en el script principal; en un pipeline real debería externalizarse a un archivo de configuración.  
- La función `aplicar_diccionarios_long` asume que `n_palabras_calculado` existe; si no, falla.

---

### 05_embeddings.R

**Propósito:**  
Proveer funciones para obtener embeddings (mediante sentence-transformers), construir prototipos semánticos y calcular similitudes coseno entre matrices de embeddings.

**Responsabilidades:**  
- Cargar el modelo de embeddings en Python a través de `reticulate`.  
- Definir una función con caché para obtener embeddings de textos (normalizados).  
- Definir listas de frases prototípicas (Hopper y clínicas).  
- Definir función para construir centroides a partir de frases.  
- Definir función para calcular similitud coseno entre dos matrices de embeddings.

**Nota:** La ejecución real (generación de embeddings, cálculo de prototipos, PCA) se realiza en `run_analysis.R` utilizando estas funciones.

**Paquetes utilizados:**  
`reticulate` (para Python), `digest` (para caché), `dplyr`, etc.

**Objetos creados:**  
- `embedding_model` (referencia al modelo Python).  
- `.emb_cache` (entorno para caché).  
- `prototipos_hopper`, `prototipos_clinicos`, `prototipos` (listas de frases).  
- Funciones.

**Funciones definidas:**  
- `obtener_embeddings(textos, normalize = TRUE, batch_size = 32L)`  
- `construir_centroide(frases, model = embedding_model, normalize = TRUE)`  
- `calcular_similitud_coseno(emb1, emb2)`  
- (opcional) `calcular_proximidad_prototipos(emb_mat, centroides)` (definida, pero no se usa directamente en el flujo).

**Parámetros relevantes:**  
- `normalize`: normalización L2 de embeddings.  
- `batch_size`: tamaño de lote para el modelo.  
- `model`: modelo de embeddings (por defecto el cargado).

**Dependencias:**  
`00_config.R` (para `reticulate` y configuración de Python).  
Además, requiere que el entorno Python tenga instalado `sentence-transformers` y que el modelo `paraphrase-multilingual-MiniLM-L12-v2` esté disponible (se descarga automáticamente).

**Archivos de entrada:**  
Textos (vectores de caracteres) proporcionados desde `run_analysis.R`.

**Archivos de salida:**  
Matrices de embeddings (objetos R) y centroides (listas de vectores).

**Relación con otros módulos:**  
Proporciona herramientas para el bloque de embeddings en `run_analysis.R`. Los resultados (embeddings, prototipos) se guardan y luego se usan en `08_visualization.R` para figuras PCA, etc.

**Estado de implementación:** **IMPLEMENTADO** (funciones).  
La ejecución de PCA y la actualización de `datos$ancho` no están dentro de este módulo, sino en el script principal.

**Problemas o riesgos detectados:**  
- Dependencia de Python y reticulate; la configuración de `venv_path` es absoluta y puede no funcionar en otros equipos.  
- El modelo de embeddings es grande (~500 MB) y la primera ejecución descarga varios archivos; puede fallar sin conexión a internet.  
- La caché `obtener_embeddings` usa `digest`; si el paquete no está instalado, usa una clave menos robusta.

---

### 06_similarity.R

**Propósito:**  
Calcular similitudes textuales basadas en frecuencias de tokens (coseno y Jaccard) entre los textos de diferentes iteraciones.

**Responsabilidades:**  
- Definir función de similitud coseno (usando frecuencias de tokens).  
- Definir función de similitud Jaccard (intersección/unidad).  
- Aplicar ambas medidas a las columnas `t1_tokens`, `t2_tokens`, `t3_tokens` del dataset ancho, añadiendo columnas `cos_*`, `jac_*` y `div_*` (distancia coseno).

**Paquetes utilizados:**  
`dplyr`, `tidyr` (y `registrar_log`).

**Objetos creados:**  
Funciones.

**Funciones definidas:**  
- `similitud_coseno(t1, t2)`  
- `similitud_jaccard(t1, t2)`  
- `calcular_similitudes(datos)`

**Parámetros relevantes:**  
Ninguno.

**Dependencias:**  
`00_config.R` (librerías y logging).

**Archivos de entrada:**  
Objeto `datos` con columnas `t1_tokens`, `t2_tokens`, `t3_tokens`.

**Archivos de salida:**  
Objeto `datos` con columnas adicionales (`cos_t1_t2`, `jac_t1_t2`, `div_t1_t2`, etc.).

**Relación con otros módulos:**  
Utilizado por `08_visualization.R` para generar figuras de similitud textual.

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- Las funciones `similitud_coseno` y `similitud_jaccard` trabajan con listas de tokens; si alguna está vacía, devuelven `NA`.  
- El cálculo es por filas (con `rowwise`), lo que puede ser lento para conjuntos grandes.

---

### 07_models.R

**Propósito:**  
Realizar análisis estadísticos avanzados: cálculo de cambios, scores heurísticos, pruebas pareadas y Friedman, ajuste de modelos lineales mixtos (LMM), bootstrap y diagnósticos.

**Responsabilidades:**  
- Calcular cambios (diferencias y porcentajes) entre iteraciones para variables numéricas.  
- Calcular scores heurísticos de influencia (ponderados) si existen columnas de emociones y diccionarios.  
- Realizar pruebas pareadas (t‑test o Wilcoxon) y Friedman con correcciones.  
- Ajustar modelos mixtos (`lmer`) con estructura `condicion * tiempo + (1 | id_participante)` (y opcionalmente `demora`).  
- Extraer ANOVA (Satterthwaite), R², y contrastes post‑hoc (Tukey).  
- Calcular correlaciones de Spearman entre cambios parciales.  
- Detectar outliers (residuos estandarizados > 2.5).  
- Ejecutar bootstrap de coeficientes (percentil 95%).  
- Generar tablas resumen de efectos y contrastes.

**Paquetes utilizados:**  
`lme4`, `lmerTest`, `emmeans`, `performance`, `effectsize`, `rlang`, `dplyr`, `tidyr`, `purrr`, `stringr`, `effsize`.

**Objetos creados:**  
- `config_scores_default` (función que devuelve pesos para scores).  
- Funciones.

**Funciones definidas:**  
- `config_scores_default()`  
- `calcular_cambios_y_scores(ancho, config_scores = config_scores_default())`  
- `realizar_pruebas_pareadas(ancho, variables = NULL, metodo_ajuste = "holm")`  
- `realizar_friedman(ancho, variables = NULL, metodo_ajuste = "bonferroni")`  
- `realizar_pruebas_inferenciales(ancho, config = NULL)`  
- `construir_largo(ancho, variable_base, incluir_demora = TRUE)`  
- `ajustar_modelo(ancho, variable_base, incluir_demora = TRUE)`  
- `extraer_resultados(modelo_obj)`  
- `calcular_correlaciones_cambios(ancho)`  
- `diagnostico_outliers(modelo_obj, umbral_resid = 2.5)`  
- `bootstrappear(modelo_obj, nsim = 500, seed = 123)`  
- `diagnosticar(modelo_obj, nombre = "")`  
- `tabla_resumen(resultados)`  
- `tabla_contrastes(resultados)`  
- (Además, funciones auxiliares para sensibilidad: `construir_largo_para_modelo`, `ajustar_modelo_sensibilidad`, `extraer_info_modelo` – utilizadas por `09_sensitivity.R`).

**Parámetros relevantes:**  
- `umbral_resid`: umbral para outliers (2.5).  
- `nsim`: número de réplicas bootstrap (500).  
- `metodo_ajuste`: para corrección de p‑valores (holm, bonferroni, fdr).  
- `config_scores`: pesos para scores heurísticos.

**Dependencias:**  
`00_config.R` (librerías y logging).  
Opcionalmente `08_visualization.R` (para temas, aunque no es estricto).

**Archivos de entrada:**  
Objeto `datos$ancho` (con todas las columnas numéricas y de emociones/diccionarios).

**Archivos de salida:**  
- Tablas de efectos y contrastes (dataframes).  
- Objetos modelo (`lmer`).  
- Matriz de correlaciones.  
- Resultados de bootstrap.  
- Diagnósticos.

**Relación con otros módulos:**  
Los modelos ajustados se utilizan en `08_visualization.R` (figuras de emmeans) y en `09_sensitivity.R` (para comparaciones).

**Estado de implementación:** **IMPLEMENTADO** (completo).

**Problemas o riesgos detectados:**  
- Los modelos mixtos pueden no converger si los datos son muy desbalanceados (grupos pequeños).  
- La corrección FDR se aplica a los p‑valores de los efectos fijos; el código asume que los nombres de los efectos coinciden.  
- Las funciones de sensibilidad (`ajustar_modelo_sensibilidad`, etc.) se encuentran en este módulo, pero son utilizadas por `09_sensitivity.R`, lo que crea una dependencia circular leve (aunque funcional).

---

### 08_visualization.R

**Propósito:**  
Generar figuras científicas para el manuscrito, con soporte para español e inglés, y con alta calidad de impresión.

**Responsabilidades:**  
- Definir paletas de colores (accesibles para daltónicos).  
- Definir temas gráficos (`tema_cientifico`, `theme_q1`).  
- Definir funciones auxiliares: guardar figura, exportar bilingüe, obtener IC de modelo.  
- Definir 15 funciones de creación de figuras (`crear_fig1` a `crear_fig15`), cada una toma los objetos necesarios y devuelve un `ggplot` (o `NULL` si faltan datos).  
- Función `generar_todas_figuras` que orquesta la generación de todas las figuras, incluyendo paneles combinados y guardado de archivos.

**Paquetes utilizados:**  
`ggplot2`, `cowplot`, `viridis`, `RColorBrewer`, `corrplot`, `emmeans`, `dplyr`, `tidyr`, `purrr`, `scales`, `patchwork`, `gridExtra`.

**Objetos creados:**  
- Paletas: `paleta_condicion`, `paleta_demora`, `paleta_emocion`.  
- Temas: `tema_cientifico`, `theme_q1`.  
- Funciones.

**Funciones definidas:**  
- `tema_cientifico(base_size = 11)`  
- `theme_q1(base_size = 12)`  
- `guardar_figura(plot, filename, width = 8, height = 6, dpi = 300)`  
- `crear_figura_bilingue(p_es, p_en, nombre_base, ancho = 8, alto = 6, res = 300)`  
- `obtener_ic_modelo(modelo, nuevo_datos = NULL)`  
- `crear_fig1(datos_ancho)` ... `crear_fig15(datos_ancho)`  
- `generar_todas_figuras(datos, modelos, cor_mat, diccionarios_hopper)`

**Parámetros relevantes:**  
- `base_size`: tamaño de fuente base.  
- `width`, `height`, `dpi`: para guardado.  
- `nombre_base`: prefijo para archivos bilingües.

**Dependencias:**  
`00_config.R` (librerías).  
`07_models.R` (para `emmeans` y modelos).  
Además, requiere que los objetos (datos, modelos, etc.) estén disponibles.

**Archivos de entrada:**  
- `datos$ancho` (todas las métricas).  
- `modelos` (resultados de `07_models.R`).  
- `cor_mat` (matriz de correlaciones).  
- `diccionarios_hopper` (lista de diccionarios).

**Archivos de salida:**  
Archivos PNG y PDF en `resultados/figuras/`, `resultados/graficos español/`, `resultados/graficos ingles/`.

**Relación con otros módulos:**  
Utiliza los resultados de todos los módulos anteriores para generar visualizaciones.

**Estado de implementación:** **IMPLEMENTADO** (completo).  
Las funciones están definidas; la ejecución se delega a `run_analysis.R` (o a la función `generar_todas_figuras`).

**Problemas o riesgos detectados:**  
- Algunas figuras (ej. figura 7, correlaciones) requieren que `cor_mat` no sea `NULL`; si falta, se omiten.  
- Las figuras que usan bootstrap (fig1, fig4, fig8, fig11) simulan réplicas dentro de la función; el tiempo de ejecución puede ser alto.  
- La función `generar_todas_figuras` asume que `modelos$palabras$modelo` existe; si no, omite figuras 5 y 10.

---

### 09_sensitivity.R

**Propósito:**  
Ejecutar el análisis de sensibilidad y robustez (Bloque 14 del experimento) para evaluar la estabilidad de los resultados frente a diferentes especificaciones del modelo.

**Responsabilidades:**  
- Ajustar modelos alternativos: con demora, logarítmico, con n_tokens, con n_estimulos.  
- Reajustar el modelo excluyendo outliers (|residuo estandarizado| > 2.5).  
- Generar gráficos de diagnóstico (residuos vs ajustados, Q-Q, histograma de efectos aleatorios).  
- Construir una tabla maestra de robustez con AIC, BIC, R² y efectos de tiempo/condición/interacción para cada modelo.  
- Extraer la comparación específica del efecto de tiempo.  
- Documentar la replicabilidad piloto vs principal (leyendo archivos existentes).  
- Generar una auditoría metodológica final (registro de decisiones, casos excluidos, etc.).

**Paquetes utilizados:**  
`dplyr`, `tidyr`, `lme4`, `lmerTest`, `performance`, `emmeans`, `ggplot2`, `purrr`, `broom.mixed`, `stringr`.

**Objetos creados:**  
Función principal `ejecutar_analisis_sensibilidad`.

**Funciones definidas:**  
- `ejecutar_analisis_sensibilidad(ancho, VD = "n_palabras_calculado", output_dir = "outputs")`

**Parámetros relevantes:**  
- `VD`: variable dependiente (por defecto `"n_palabras_calculado"`).  
- `output_dir`: directorio donde se guardan los resultados.

**Dependencias:**  
`00_config.R` (librerías).  
`07_models.R` (funciones `ajustar_modelo_sensibilidad`, `extraer_info_modelo`, etc.).  
`08_visualization.R` (para `tema_cientifico` en los gráficos de diagnóstico).

**Archivos de entrada:**  
- `datos$ancho` (dataframe con todas las variables).  
- Opcionalmente, archivos de resultados de comparación piloto-principal (`analisis_piloto/modelos/modelos_comparativos.rds`).

**Archivos de salida:**  
- Tablas CSV en `outputs/tablas/`.  
- Modelos y resúmenes en `outputs/modelos/`.  
- Gráficos de diagnóstico en `outputs/diagnosticos/`.  
- Auditoría final (`auditoria_analisis_final.txt`) y `sessionInfo.txt`.

**Relación con otros módulos:**  
Utiliza funciones de `07_models.R` para ajustar modelos y extraer información. También usa el tema de `08_visualization.R` para los gráficos.

**Estado de implementación:** **IMPLEMENTADO** (completo).  
La función está definida y se espera que sea llamada desde `run_analysis.R`.

**Problemas o riesgos detectados:**  
- Depende de que las funciones `ajustar_modelo_sensibilidad` y `extraer_info_modelo` estén disponibles en `07_models.R`.  
- Si `VD` contiene ceros, el modelo logarítmico falla; el código lo detecta y omite la transformación.  
- El análisis de outliers utiliza un umbral fijo (2.5) que puede no ser apropiado para todos los conjuntos de datos.  
- La ruta `analisis_piloto/modelos/modelos_comparativos.rds` es fija; si no existe, se salta la sección de replicabilidad.

---

## 5. Funciones existentes por módulo

| Función | Archivo | Propósito | Parámetros | Retorno | Dependencias |
| ------- | ------- | --------- | ---------- | ------- | ------------ |
| `instalar_paquetes` | 00_config.R | Instala paquetes faltantes | `pkgs`, `repo` | NULL | – |
| `registrar_log` | 00_config.R | Escribe mensajes de log | `mensaje`, `nivel`, `archivo` | NULL | – |
| `derivar_n_estimulos` | 01_import_data.R | Deriva número de estímulos desde iteración | `iteracion` | entero | – |
| `importar_principal` | 01_import_data.R | Importa dataset principal desde Excel | `ruta`, `hoja` | dataframe | `registrar_log` |
| `importar_piloto` | 01_import_data.R | Importa dataset piloto (estructura especial) | `ruta`, `hoja` | dataframe | `registrar_log` |
| `normalizar_principal` | 01_import_data.R | Normaliza principal al esquema canónico | `raw` | dataframe | `derivar_n_estimulos` |
| `normalizar_piloto` | 01_import_data.R | Normaliza piloto al esquema canónico | `raw` | dataframe | `derivar_n_estimulos` |
| `validar_esquema` | 01_import_data.R | Valida columnas y tipos del esquema | `df`, `nombre` | lista (invisible) | – |
| `validar_dataset_maestro` | 01_import_data.R | Auditoría completa del dataset integrado | `df` | lista (invisible) | – |
| `integrar_fuentes` | 01_import_data.R | Integra múltiples dataframes normalizados | `lista_dfs` | dataframe | `validar_esquema` |
| `generar_ancho` | 01_import_data.R | Genera formato ancho desde largo | `df_long` | dataframe | – |
| `validar_datos` | 01_import_data.R | Valida objeto `datos` (largo y ancho) | `datos` | NULL (imprime) | – |
| `limpiar_texto` | 02_text_processing.R | Limpia un texto | `texto` | texto limpio | – |
| `tokenizar` | 02_text_processing.R | Tokeniza eliminando stopwords | `texto`, `min_chars` | vector de tokens | – |
| `preprocesar_textos` | 02_text_processing.R | Aplica limpieza y tokenización al dataset | `datos` | `datos` modificado | `limpiar_texto`, `tokenizar`, `registrar_log` |
| `calcular_metricas_linguisticas` | 02_text_processing.R | Calcula métricas de un texto y sus tokens | `texto_orig`, `tokens` | lista con métricas | – |
| `agregar_metricas` | 02_text_processing.R | Agrega métricas al dataset ancho | `datos` | `datos` modificado | `calcular_metricas_linguisticas`, `registrar_log` |
| `normalizar_palabra_lexico` | 03_sentiment.R | Normaliza palabra para el léxico | `palabra` | palabra normalizada | – |
| `validar_lexico_nrc_es` | 03_sentiment.R | Valida estructura del léxico | `lexico`, `detener` | TRUE/FALSE | – |
| `preparar_lexico_nrc_es` | 03_sentiment.R | Descarga, procesa y guarda el léxico | Ninguno | léxico (lista) | `normalizar_palabra_lexico`, `validar_lexico_nrc_es` |
| `inicializar_lexico` | 03_sentiment.R | Carga o descarga el léxico | Ninguno | NULL (asigna variable global) | `preparar_lexico_nrc_es` |
| `analizar_sentimiento_es` | 03_sentiment.R | Analiza sentimiento de un texto | `texto` | vector con scores y estado | `limpiar_texto`, `tokenizar`, `.lexico_nrc_es` |
| `calcular_sentimientos` | 03_sentiment.R | Aplica análisis a todo el dataset | `datos` | `datos` modificado | `analizar_sentimiento_es`, `registrar_log` |
| `preparar_corpus` | 04_dictionaries.R | Tokeniza y agrupa textos por observación | `datos_long` | tibble con lista de tokens | `limpiar_texto`, `tokenizar` |
| `extraer_candidatos` | 04_dictionaries.R | Extrae candidatos por PMI | `corpus`, `diccionarios`, `min_freq`, `min_doc`, `min_part` | lista de candidatos por tema | – |
| `enriquecer_diccionarios` | 04_dictionaries.R | Añade candidatos a diccionarios base | `base_dict`, `candidatos_aceptados` | diccionarios enriquecidos | – |
| `calcular_cobertura` | 04_dictionaries.R | Calcula cobertura de un diccionario | `corpus`, `diccionario`, `nombre` | tibble con coberturas | – |
| `detectar_solapamientos` | 04_dictionaries.R | Detecta términos en múltiples temas | `diccionarios` | tibble con solapamientos | – |
| `aplicar_diccionarios_long` | 04_dictionaries.R | Aplica diccionarios a datos largos | `datos_long`, `diccionarios` | dataframe con scores y tasas | `limpiar_texto`, `tokenizar` |
| `obtener_embeddings` | 05_embeddings.R | Obtiene embeddings de textos (con caché) | `textos`, `normalize`, `batch_size` | matriz de embeddings | `embedding_model` (Python), `.emb_cache` |
| `construir_centroide` | 05_embeddings.R | Construye centroide de un conjunto de frases | `frases`, `model`, `normalize` | vector (centroide) | `obtener_embeddings` |
| `calcular_similitud_coseno` | 05_embeddings.R | Similitud coseno entre matrices de embeddings | `emb1`, `emb2` | vector de similitudes | – |
| `similitud_coseno` | 06_similarity.R | Similitud coseno entre tokens (frecuencias) | `t1`, `t2` | numérico | – |
| `similitud_jaccard` | 06_similarity.R | Similitud Jaccard entre conjuntos de tokens | `t1`, `t2` | numérico | – |
| `calcular_similitudes` | 06_similarity.R | Calcula similitudes textuales para todo el dataset | `datos` | `datos` modificado | `similitud_coseno`, `similitud_jaccard`, `registrar_log` |
| `config_scores_default` | 07_models.R | Proporciona pesos para scores heurísticos | Ninguno | lista de pesos | – |
| `calcular_cambios_y_scores` | 07_models.R | Calcula cambios y scores heurísticos | `ancho`, `config_scores` | dataframe con cambios/scores | `config_scores_default` |
| `realizar_pruebas_pareadas` | 07_models.R | Pruebas pareadas (t o Wilcoxon) | `ancho`, `variables`, `metodo_ajuste` | dataframe con resultados | – |
| `realizar_friedman` | 07_models.R | Prueba de Friedman con post-hoc | `ancho`, `variables`, `metodo_ajuste` | lista con resultados | – |
| `realizar_pruebas_inferenciales` | 07_models.R | Integra pareadas y Friedman | `ancho`, `config` | lista con resultados | `realizar_pruebas_pareadas`, `realizar_friedman` |
| `construir_largo` | 07_models.R | Convierte ancho a largo para un modelo | `ancho`, `variable_base`, `incluir_demora` | dataframe largo | – |
| `ajustar_modelo` | 07_models.R | Ajusta modelo mixto | `ancho`, `variable_base`, `incluir_demora` | lista con modelo y diagnóstico | `construir_largo` |
| `extraer_resultados` | 07_models.R | Extrae ANOVA, R², post-hoc | `modelo_obj` | lista | `emmeans` |
| `calcular_correlaciones_cambios` | 07_models.R | Correlaciones de Spearman entre cambios | `ancho` | matriz de correlación | – |
| `diagnostico_outliers` | 07_models.R | Identifica outliers por residuo estandarizado | `modelo_obj`, `umbral_resid` | lista de índices | – |
| `bootstrappear` | 07_models.R | Bootstrap de coeficientes (percentil) | `modelo_obj`, `nsim`, `seed` | lista con IC | `bootMer` |
| `diagnosticar` | 07_models.R | Diagnóstico del modelo (performance) | `modelo_obj`, `nombre` | NULL (imprime) | `check_model` |
| `tabla_resumen` | 07_models.R | Genera tabla de efectos (ANOVA) | `resultados` | dataframe | – |
| `tabla_contrastes` | 07_models.R | Genera tabla de contrastes post-hoc | `resultados` | dataframe | – |
| `construir_largo_para_modelo` | 07_models.R | Largo para modelo (incluye fuente) | `ancho`, `variable` | dataframe largo | – |
| `ajustar_modelo_sensibilidad` | 07_models.R | Ajusta modelo para sensibilidad | `ancho`, `variable`, `formula`, `nombre_modelo` | lista con diagnóstico | `construir_largo_para_modelo` |
| `extraer_info_modelo` | 07_models.R | Extrae info para tabla de robustez | `modelo_obj`, `nombre` | dataframe | – |
| `tema_cientifico` | 08_visualization.R | Tema gráfico para figuras | `base_size` | theme object | – |
| `theme_q1` | 08_visualization.R | Tema alternativo | `base_size` | theme object | – |
| `guardar_figura` | 08_visualization.R | Guarda figura en PNG | `plot`, `filename`, `width`, `height`, `dpi` | NULL | – |
| `crear_figura_bilingue` | 08_visualization.R | Guarda versiones ES/EN | `p_es`, `p_en`, `nombre_base`, `ancho`, `alto`, `res` | NULL | `guardar_figura` |
| `obtener_ic_modelo` | 08_visualization.R | Obtiene emmeans e IC | `modelo`, `nuevo_datos` | dataframe | `emmeans` |
| `crear_fig1` a `crear_fig15` | 08_visualization.R | Crean figuras individuales | diversos (datos, modelos, etc.) | objeto `ggplot` o `NULL` | `tema_cientifico`, `paleta_*` |
| `generar_todas_figuras` | 08_visualization.R | Orquesta la generación de todas las figuras | `datos`, `modelos`, `cor_mat`, `diccionarios_hopper` | lista de figuras (invisible) | funciones `crear_fig*`, `guardar_figura` |
| `ejecutar_analisis_sensibilidad` | 09_sensitivity.R | Ejecuta análisis de sensibilidad completo | `ancho`, `VD`, `output_dir` | lista (invisible) | funciones de 07_models y 08_visualization |

---

## 6. Flujo de datos entre módulos

El flujo real de datos, según el código de `run_analysis.R` (que utiliza estos módulos), es el siguiente:

```text
Archivos Excel (raw)
      ↓
01_import_data.R  →  datos_maestros_long, datos_maestros_ancho
      ↓
02_text_processing.R  →  datos (con t1_limpio, t1_tokens, métricas)
      ↓
03_sentiment.R  →  datos (con columnas de emociones)
      ↓
04_dictionaries.R  →  scores_long, scores_wide (y diccionarios enriquecidos)
      ↓                     (los scores se integran en datos$ancho)
05_embeddings.R  (funciones)  →  emb_t1, emb_t2, emb_t3, prototipos_centroides
      ↓
06_similarity.R  →  datos (con cos_*, jac_*, div_*)
      ↓
07_models.R  →  cambios_scores, resultados_inferenciales, resultados_modelos, mat_cor
      ↓
08_visualization.R  →  figuras (objetos ggplot) y archivos PNG/PDF
      ↓
09_sensitivity.R  →  tablas de robustez, gráficos de diagnóstico, auditoría
```

**Notas:**
- `05_embeddings.R` no modifica `datos$ancho` directamente; la actualización se realiza en `run_analysis.R` utilizando las funciones del módulo.
- Los resultados de `07_models.R` (modelos, correlaciones) se utilizan en `08_visualization.R` para generar figuras.
- `09_sensitivity.R` lee el objeto `datos$ancho` y produce resultados en `outputs/`.

---

## 7. Dependencias entre módulos

| Módulo | Depende de |
| ------ | ----------- |
| `00_config.R` | Ninguno |
| `01_import_data.R` | `00_config.R` (logging, librerías) |
| `02_text_processing.R` | `00_config.R` |
| `03_sentiment.R` | `00_config.R`, `02_text_processing.R` |
| `04_dictionaries.R` | `00_config.R`, `02_text_processing.R` |
| `05_embeddings.R` | `00_config.R` (reticulate y configuración Python) |
| `06_similarity.R` | `00_config.R` |
| `07_models.R` | `00_config.R` |
| `08_visualization.R` | `00_config.R`, `07_models.R` (para emmeans) |
| `09_sensitivity.R` | `00_config.R`, `07_models.R`, `08_visualization.R` |

**Observaciones:**
- No hay dependencias circulares.
- `05_embeddings.R` es independiente de `02_text_processing.R`, aunque en la práctica se usa con textos ya limpiados.
- `09_sensitivity.R` reutiliza funciones de `07_models.R`, por lo que depende de él.

---

## 8. Contrato de entradas y salidas

Cada módulo espera recibir ciertos objetos y produce otros. A continuación se detalla el contrato:

### 00_config.R
- **Entrada:** Ninguna (configuración de sistema).
- **Transformación:** Carga librerías, opciones, logging y Python.
- **Salida:** Funciones y objetos globales (ej. `registrar_log`, `venv_path`, etc.).
- **Consumidores:** Todos los demás módulos.

### 01_import_data.R
- **Entrada:** Archivos Excel (rutas).
- **Transformación:** Importación, normalización, validación, integración, generación de ancho.
- **Salida:** Objeto `datos` (lista con `largo` y `ancho`).
- **Consumidores:** `run_analysis.R` (que pasa el objeto a los siguientes módulos).

### 02_text_processing.R
- **Entrada:** `datos` (con `texto_t1`, `texto_t2`, `texto_t3`).
- **Transformación:** Limpieza, tokenización, métricas.
- **Salida:** `datos` enriquecido con `*_limpio`, `*_tokens`, métricas.
- **Consumidores:** `03_sentiment.R`, `04_dictionaries.R`, `06_similarity.R`, `run_analysis.R`.

### 03_sentiment.R
- **Entrada:** `datos` (con `t1_limpio`, `t2_limpio`, `t3_limpio`).
- **Transformación:** Análisis de sentimiento (léxico NRC-ES).
- **Salida:** `datos` con columnas de emociones.
- **Consumidores:** `07_models.R`, `08_visualization.R`.

### 04_dictionaries.R
- **Entrada:** `datos_maestros_long` (largo) y diccionarios base.
- **Transformación:** Enriquecimiento y aplicación.
- **Salida:** `scores_long`, `scores_wide` (dataframes) y diccionarios enriquecidos.
- **Consumidores:** `run_analysis.R` (integra los scores en `datos$ancho`).

### 05_embeddings.R
- **Entrada:** Textos (vectores de caracteres) y listas de frases prototípicas.
- **Transformación:** Generación de embeddings y centroides (funciones).
- **Salida:** Matrices de embeddings y centroides (objetos R).
- **Consumidores:** `run_analysis.R` (para actualizar `datos$ancho` y guardar).

### 06_similarity.R
- **Entrada:** `datos` (con `t1_tokens`, `t2_tokens`, `t3_tokens`).
- **Transformación:** Cálculo de similitudes coseno y Jaccard.
- **Salida:** `datos` con columnas `cos_*`, `jac_*`, `div_*`.
- **Consumidores:** `08_visualization.R`.

### 07_models.R
- **Entrada:** `datos$ancho` (con todas las variables numéricas y de emociones/diccionarios).
- **Transformación:** Cálculo de cambios, pruebas inferenciales, modelos mixtos, bootstrap.
- **Salida:** `resultados_modelos`, `tabla_efectos`, `tabla_contrastes`, `mat_cor`, etc.
- **Consumidores:** `08_visualization.R`, `09_sensitivity.R`.

### 08_visualization.R
- **Entrada:** `datos`, `modelos`, `cor_mat`, `diccionarios_hopper`.
- **Transformación:** Generación de figuras (ggplot) y guardado en archivos.
- **Salida:** Archivos PNG/PDF en `resultados/figuras/`, `resultados/graficos español/`, `resultados/graficos ingles/`.
- **Consumidores:** Usuario final / manuscrito.

### 09_sensitivity.R
- **Entrada:** `datos$ancho` (y opcionalmente archivos de comparación).
- **Transformación:** Análisis de sensibilidad (modelos alternativos, outliers, etc.).
- **Salida:** Archivos en `outputs/` (tablas, modelos, gráficos, auditoría).
- **Consumidores:** Usuario final / manuscrito (sección de robustez).

---

## 9. Pipeline reproducible

El archivo `run_analysis.R` (en la raíz del repositorio) es el orquestador principal.  
Este script realiza `source()` de cada módulo en el orden establecido, y luego ejecuta los pasos del pipeline:

1. Configuración (carga `00_config.R`).
2. Importación y normalización (usa funciones de `01_import_data.R`).
3. Procesamiento de texto (usa `02_text_processing.R`).
4. Análisis de sentimiento (usa `03_sentiment.R`).
5. Diccionarios Hopper (usa `04_dictionaries.R`).
6. Embeddings y prototipos (usa funciones de `05_embeddings.R`).
7. Similitudes textuales (usa `06_similarity.R`).
8. Modelos mixtos (usa `07_models.R`).
9. Visualizaciones (usa `08_visualization.R`).
10. Análisis de sensibilidad (usa `09_sensitivity.R`).

El script `run_analysis.R` está completamente implementado y hace uso de todos los módulos.  
Por lo tanto, el pipeline es reproducible siempre que se respeten las rutas de archivos y las configuraciones de Python.

**Estado actual:**  
El pipeline es ejecutable y produce los resultados esperados (siempre que los datos de entrada estén disponibles).

---

## 10. Convenciones de desarrollo

### Convenciones existentes en el código

- **Nombres de funciones:** verbos en minúsculas y snake_case (ej. `limpiar_texto`, `importar_principal`).
- **Nombres de objetos:** minúsculas y snake_case (ej. `datos_maestros_long`, `diccionarios_hopper_base`).
- **Argumentos:** con nombres descriptivos, a menudo con valores predeterminados.
- **Comentarios:** se utilizan secciones con `# ──` para separar bloques lógicos; algunas funciones tienen documentación en estilo `#'` (roxygen2).
- **Manejo de errores:** se utilizan `tryCatch` y `stop` con mensajes informativos; en algunos casos se emplean `warning`.
- **Logging:** se usa la función `registrar_log` para trazar la ejecución.
- **Rutas:** se utilizan rutas absolutas (ej. `"C:/Users/..."`) en algunos casos, aunque se recomienda usar `here::here()` en el script principal.
- **Semillas:** se fija `set.seed(20260526)` al inicio.

### Recomendaciones futuras

- **Rutas relativas:** migrar todas las rutas a `here::here()` para mejorar la portabilidad.
- **Documentación roxygen2:** completar la documentación de todas las funciones con `@param`, `@return`, `@examples`.
- **Testing:** incorporar pruebas unitarias (testthat) para las funciones críticas.
- **Gestión de dependencias:** utilizar `renv` para fijar versiones de paquetes.
- **Separación de configuración:** externalizar parámetros (como `venv_path`, umbrales) a un archivo `config.yml`.
- **Manejo de errores:** homogeneizar el uso de `tryCatch` y proporcionar mensajes más claros.
- **Consistencia en nombres:** unificar los nombres de columnas generadas (ej. `_t1`, `_t2` vs `_T1`).
- **Eliminación de código muerto:** revisar funciones no utilizadas (ej. `calcular_proximidad_prototipos` no se usa en el flujo principal).

---

## 11. Estado de implementación

| Módulo | Estado actual | Funcionalidad existente | Pendientes |
| ------ | ------------- | ----------------------- | ---------- |
| `00_config.R` | IMPLEMENTADO | Carga de librerías, logging, Python | Migrar a `renv`; externalizar rutas |
| `01_import_data.R` | IMPLEMENTADO | Importación, normalización, validación | Mejorar robustez ante cambios en Excel |
| `02_text_processing.R` | IMPLEMENTADO | Limpieza, tokenización, métricas | Optimizar para grandes volúmenes |
| `03_sentiment.R` | IMPLEMENTADO | Léxico NRC-ES, análisis | Externalizar URL y ruta local |
| `04_dictionaries.R` | IMPLEMENTADO | Diccionarios Hopper, enriquecimiento, aplicación | Externalizar candidatos_aceptados |
| `05_embeddings.R` | IMPLEMENTADO | Funciones de embeddings y prototipos | Mejorar caché y manejo de errores Python |
| `06_similarity.R` | IMPLEMENTADO | Similitudes coseno y Jaccard | Optimizar con operaciones vectorizadas |
| `07_models.R` | IMPLEMENTADO | Modelos mixtos, pruebas, bootstrap | Revisar convergencia en datos desbalanceados |
| `08_visualization.R` | IMPLEMENTADO | Figuras y temas | Reducir tiempo de bootstrap en figuras |
| `09_sensitivity.R` | IMPLEMENTADO | Análisis de sensibilidad | Externalizar umbrales y rutas |

**Nota:** Todos los módulos están implementados y son funcionales según el código revisado. No se han detectado archivos vacíos o esqueletos.

---

## 12. Riesgos técnicos

| Riesgo | Descripción | Impacto |
| ------ | ----------- | ------- |
| **Rutas absolutas** | En `00_config.R` y en algunos `source()` se usan rutas absolutas. | Bajo (si se ajustan) |
| **Dependencia de Python** | `05_embeddings.R` requiere `reticulate` y el entorno virtual configurado. Si no existe, falla. | Alto |
| **Modelo de embeddings grande** | La descarga del modelo puede fallar sin internet y ocupa ~500 MB. | Medio |
| **Datos desbalanceados** | Los grupos de condición×demora tienen pocos participantes (n < 4). | Alto (poder estadístico) |
| **Funciones pesadas** | Cálculo de embeddings, bootstrap y extracción de candidatos son lentos. | Medio |
| **Objetos globales** | `03_sentiment.R` usa `.lexico_nrc_es` como variable global. | Bajo (pero puede causar conflictos) |
| **Código duplicado** | Algunas funciones de limpieza se repiten (p.ej. `normalizar_palabra_lexico`). | Bajo |
| **Falta de pruebas** | No hay pruebas unitarias; errores pueden pasar desapercibidos. | Alto |
| **Manejo de errores inconsistente** | Algunos `tryCatch` capturan errores y otros no. | Medio |
| **Outputs no versionados** | Los archivos generados (figuras, tablas) no se controlan con Git. | Bajo |

---

## 13. Relación con Python

El módulo `05_embeddings.R` es el único que interactúa con Python a través de `reticulate`.  

**Configuración:**  
- Se espera que `00_config.R` haya definido `venv_path` y `python_exe`, y activado el entorno virtual.
- El módulo carga el modelo `SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')` desde Python.
- La función `obtener_embeddings` envía lotes de texto a Python, los codifica y devuelve matrices numéricas a R.

**Intercambio de objetos:**  
- R envía vectores de caracteres a Python mediante `py$textos_lote`.
- Python devuelve arrays NumPy que se convierten a matrices R.

**Posibles problemas:**  
- El entorno Python debe tener instalado `sentence-transformers` y `torch`.
- La primera ejecución descarga el modelo, lo que puede ser lento y requiere conexión a internet.
- Si `reticulate` no encuentra el entorno, el módulo falla.

**Archivo `python/embeddings_setup.py`:**  
No existe en el repositorio según la estructura proporcionada. Se recomienda crearlo para instalar las dependencias Python de forma reproducible.

---

## 14. Relación con outputs

Los módulos generan resultados que se almacenan en las siguientes carpetas:

- **`resultados/figuras/`**: Figuras individuales (PNG) generadas por `08_visualization.R`.
- **`resultados/graficos español/` y `resultados/graficos ingles/`**: Versiones bilingües de las figuras (PNG y PDF).
- **`resultados/tablas/`**: Archivos CSV con descriptivos, efectos de modelos, contrastes, correlaciones, etc. Generados por `run_analysis.R` y `07_models.R`.
- **`resultados/modelos/`**: Objetos RDS de modelos mixtos (`modelos_mixtos.rds`) y prototipos (`prototipos_semanticos.rds`).
- **`outputs/`**: Resultados del análisis de sensibilidad (tablas, modelos, gráficos de diagnóstico, auditoría) generados por `09_sensitivity.R`.
- **`data/processed/`**: Datos intermedios (scores, diccionarios enriquecidos, embeddings) guardados por `run_analysis.R`.

**Estado:**  
Todos los módulos que deberían escribir archivos lo hacen (a través de `run_analysis.R` o de sus propias funciones).  
No se detectaron outputs no controlados.

---

## 15. Diagrama de arquitectura

```text
                     ┌─────────────────┐
                     │  Datos crudos    │
                     │  (Excel)         │
                     └────────┬────────┘
                              ▼
                     ┌─────────────────┐
                     │ 01_import_data   │
                     │ Importación y    │
                     │ normalización    │
                     └────────┬────────┘
                              ▼
                     ┌─────────────────┐
                     │ 02_text_processing│
                     │ Limpieza, tokens,│
                     │ métricas         │
                     └────────┬────────┘
                              ▼
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│03_sentiment   │    │04_dictionaries│    │06_similarity  │
│NRC-ES         │    │Hopper         │    │Coseno/Jaccard │
└───────┬───────┘    └───────┬───────┘    └───────┬───────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
                     ┌─────────────────┐
                     │ 05_embeddings   │
                     │ (funciones)     │
                     └────────┬────────┘
                              ▼
                     ┌─────────────────┐
                     │ 07_models       │
                     │ Modelos mixtos, │
                     │ pruebas         │
                     └────────┬────────┘
                              ▼
                     ┌─────────────────┐
                     │ 08_visualization│
                     │ Figuras         │
                     └────────┬────────┘
                              ▼
                     ┌─────────────────┐
                     │ 09_sensitivity  │
                     │ Robustez        │
                     └─────────────────┘
```

---

## 16. Próximos pasos

### CRÍTICO
- **Externalizar rutas y parámetros** a un archivo de configuración (ej. `config.yml`) para evitar rutas absolutas y facilitar la portabilidad.
- **Crear un entorno Python reproducible** (ej. `requirements.txt` o `environment.yml`) para garantizar que las dependencias de Python se instalen correctamente.
- **Añadir pruebas unitarias** para las funciones clave (especialmente importación, procesamiento de texto y modelos).

### ALTO
- **Optimizar el cálculo de embeddings y bootstrap** (usar paralelización, reducir el número de réplicas en bootstrap para exploración).
- **Mejorar el manejo de errores** en los módulos que dependen de Python (capturar excepciones específicas y proporcionar mensajes claros).
- **Documentar con roxygen2** todas las funciones para facilitar su uso y mantenimiento.

### MEDIO
- **Revisar y unificar los nombres de columnas** generadas por los diferentes módulos para evitar confusiones.
- **Incorporar un sistema de logging más estructurado** (por niveles, con salida a archivo y consola).
- **Añadir comprobaciones de consistencia** entre los datasets (por ejemplo, verificar que `id_participante` coincida entre `datos$largo` y `datos$ancho`).

### BAJO
- **Eliminar código duplicado** (p.ej., normalización de palabras en `03_sentiment` y `02_text_processing`).
- **Crear un script de limpieza** para borrar resultados intermedios antes de una nueva ejecución.
- **Añadir un `Makefile` o script de automatización** para ejecutar el pipeline completo con un solo comando.

---

*Este README documenta el estado actual de la carpeta `R/` basado en el código existente.  
Para cualquier duda o sugerencia, consultar el archivo `run_analysis.R` o los comentarios en los propios módulos.*
```