===============================================================
README — DATOS DEL PILOTO (EXTRACCIÓN PARA ARTÍCULO)
===============================================================

Fecha de generación: 2026-09-25 19:15:26
Carpeta: piloto/datos (ruta relativa a `Analisis agosto v2/`)

DESCRIPCIÓN GENERAL
---------------------------------------------------------------
Esta carpeta contiene todos los datos extraídos exclusivamente
del estudio piloto (17 participantes, 3 iteraciones cada uno).
Los datos han sido procesados a través del pipeline completo:
  - Limpieza de textos
  - Tokenización
  - Cálculo de métricas lingüísticas
  - Aplicación de diccionarios (Hopper y clínicos)
  - Generación de embeddings (modelo paraphrase-multilingual-MiniLM-L12-v2)
  - Cálculo de prototipos semánticos
  - Análisis de similitudes y cambios semánticos
  - Modelos lineales mixtos (resultados en carpeta 'modelos/')

Número de participantes: 17
Número de observaciones (filas en ancho): 17
Condiciones: Texto, Audio, Imagen
Iteraciones: T1, T2, T3 (3 por participante)

ARCHIVOS GENERADOS
---------------------------------------------------------------

📄 ancho_piloto.rds
    Archivo adicional no documentado. Revisar su contenido.

📄 ancho_piloto_completo.csv
    Versión CSV del dataframe ancho (mismo contenido que el RDS).

📄 ancho_piloto_completo.rds
    Dataframe en formato ancho (RDS) con todas las variables calculadas
    (lingüísticas, diccionarios, prototipos, PCA, etc.).

📄 embeddings_piloto_t1.rds
    Matriz de embeddings (normalizados) para el tiempo 1 (T1).
    Dimensiones: n_observaciones × 384.

📄 embeddings_piloto_t2.rds
    Matriz de embeddings (normalizados) para el tiempo 2 (T2).
    Dimensiones: n_observaciones × 384.

📄 embeddings_piloto_t3.rds
    Matriz de embeddings (normalizados) para el tiempo 3 (T3).
    Dimensiones: n_observaciones × 384.

📄 piloto_identificacion.csv
    Columnas de identificación: id_participante, participante, condicion, fuente.

📄 piloto_longitudinal.csv
    Archivo adicional no documentado. Revisar su contenido.

📄 piloto_metricas_linguisticas.csv
    Métricas lingüísticas básicas:
    n_palabras, ttr, n_oraciones, long_palabra, palabras_oracion
    (todas en T1, T2, T3).

📄 README_DATOS_PILOTO.txt
    Este mismo archivo (documentación).

INSTRUCCIONES DE USO
---------------------------------------------------------------
1. Los archivos .rds pueden leerse con readRDS() en R.
   Ejemplo: embeddings_t1 <- readRDS('embeddings_piloto_t1.rds')

2. Los archivos .csv son legibles con read_csv() o read.csv().
   Ejemplo: datos <- read_csv('ancho_piloto_completo.csv')

3. El dataframe 'ancho_piloto_completo' contiene TODAS las variables
   calculadas para el piloto. Es la base para análisis adicionales.

4. Para análisis longitudinales, se recomienda usar el formato largo
   (pivot_longer) usando las columnas *_t1, *_t2, *_t3.

5. Los embeddings están normalizados (norma L2) y listos para
   calcular similitudes coseno o para usar en modelos de ML.

METADATOS TÉCNICOS
---------------------------------------------------------------
Modelo de embeddings: paraphrase-multilingual-MiniLM-L12-v2
Dimensión de embeddings: 384
Normalización: L2 (cosine similarity ready)
Limpieza de texto: función limpiar_texto() (remoción de puntuación, números, etc.)
Tokenización: función tokenizar() (separación por espacios)
Diccionarios: Hopper (10 temas) + Clínicos (10 constructos)
Prototipos: 20 constructos, 5 frases cada uno
Corrección de p-valores: Holm (para contrastes múltiples)
Modelos mixtos: lmer (lme4) con Satterthwaite para grados de libertad

===============================================================
FIN DEL README
===============================================================

