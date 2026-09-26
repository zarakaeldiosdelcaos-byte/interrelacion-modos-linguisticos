# Embeddings — organización, exportación y trazabilidad

**Proyecto:** Análisis NLP de textos en 3 tiempos  
**Fecha de consolidación:** 2026-09-07  
**Estado:** Migración R → Python validada

---

## 1. Propósito

Este directorio contiene los artefactos derivados y de referencia asociados al procesamiento de embeddings semánticos y al análisis de componentes principales (PCA).

La organización separa explícitamente:

- objetos originales en formato RDS;
- exportaciones tabulares en CSV;
- artefactos derivados para Python.

El objetivo es preservar la trazabilidad del pipeline original de R y permitir su reproducción controlada en Python.

---

## 2. Estructura final

```text
data/
└── processed/
    └── embeddings/
        ├── rds/
        │   ├── embeddings/
        │   │   ├── embeddings_t1.rds
        │   │   ├── embeddings_t2.rds
        │   │   └── embeddings_t3.rds
        │   ├── semantic_prototypes/
        │   │   └── prototipos_semanticos.rds
        │   └── pca/
        │       └── pca_embeddings.rds
        │
        ├── csv/
        │   ├── embeddings/
        │   │   ├── embeddings_t1.csv
        │   │   ├── embeddings_t2.csv
        │   │   └── embeddings_t3.csv
        │   ├── semantic_prototypes/
        │   │   └── prototipos_semanticos.csv
        │   └── pca/
        │       ├── pca_embeddings_center.csv
        │       ├── pca_embeddings_loadings.csv
        │       ├── pca_embeddings_metadata.csv
        │       ├── pca_embeddings_scale.csv
        │       ├── pca_embeddings_scores.csv
        │       ├── pca_embeddings_sdev.csv
        │       └── pca_embeddings_var_exp.csv
        │
        └── python/
            └── pca/
                ├── pca_embeddings_pc60_scores.csv
                ├── pca_embeddings_pc60_loadings.csv
                ├── pca_embeddings_pc60_sdev.csv
                ├── pca_embeddings_pc60_center.csv
                ├── pca_embeddings_pc60_scale.csv
                ├── pca_embeddings_pc60_variance.csv
                └── metadata.json
3. Embeddings originales

Se conservaron tres matrices de embeddings correspondientes a tres momentos temporales:

T1 = 40 × 384
T2 = 40 × 384
T3 = 40 × 384

Cada fila representa una observación y cada columna una dimensión del embedding.

Los objetos originales RDS se encuentran actualmente en:

rds/embeddings/

Las copias fueron verificadas mediante SHA-256 antes de eliminar las copias redundantes que existían directamente en la raíz de data/processed/embeddings/.

Por tanto, la reorganización no implicó pérdida ni modificación de los objetos RDS.

4. Prototipos semánticos

El objeto:

prototipos_semanticos.rds

contiene:

20 prototipos
×
384 dimensiones

Los prototipos identificados son:

soledad
espera
incomunicacion
objetos
emociones_negativas
luz_sombra
pasividad
desconexion
duda
espacio
tristeza
miedo
ansiedad_malestar
esperanza
confianza
agencia
control
incertidumbre
evitacion
afrontamiento

El RDS se conserva en:

rds/semantic_prototypes/prototipos_semanticos.rds

y su representación tabular en:

csv/semantic_prototypes/prototipos_semanticos.csv
5. PCA original de R

El PCA original se conserva íntegramente como:

rds/pca/pca_embeddings.rds

El objeto contiene un objeto prcomp y metadatos asociados.

Las dimensiones principales son:

pca$x         = 120 × 120
pca$rotation  = 384 × 120
pca$sdev      = 120
pca$center    = 384
pca$scale     = 384

Los casos completos son:

40
6. Construcción del PCA

El PCA original de R se construyó concatenando los tres momentos:

T1 = 40 × 384
T2 = 40 × 384
T3 = 40 × 384

produciendo:

emb_all = 120 × 384

El orden de las observaciones es:

1–40    → T1
41–80   → T2
81–120  → T3

La construcción original utiliza:

prcomp(
    emb_all,
    center = TRUE,
    scale. = TRUE
)

La estandarización se expresa como:

Z_ij = (X_ij - μ_j) / s_j

donde μ_j y s_j corresponden a pca$center y pca$scale del objeto original de R.

7. Exportaciones PCA

Para facilitar interoperabilidad y validación se exportaron individualmente los componentes relevantes del objeto prcomp.

Scores
pca_embeddings_scores.csv

Dimensiones:

120 × 120
Loadings / rotation
pca_embeddings_loadings.csv

Dimensiones:

384 × 120
Desviaciones estándar
pca_embeddings_sdev.csv

Dimensión:

120
Centro
pca_embeddings_center.csv

Dimensión:

384
Escala
pca_embeddings_scale.csv

Dimensión:

384
Varianza explicada
pca_embeddings_var_exp.csv

Incluye la referencia de varianza explicada utilizada por el pipeline original.

Metadatos
pca_embeddings_metadata.csv
8. Integridad de los RDS

Las copias clasificadas de los cinco RDS fueron comparadas mediante SHA-256 con sus archivos de referencia.

Resultado:

OK embeddings_t1.rds
OK embeddings_t2.rds
OK embeddings_t3.rds
OK prototipos_semanticos.rds
OK pca_embeddings.rds

La comparación de embeddings_t1.rds, por ejemplo, produjo el mismo SHA-256 para original y copia:

77C2483300A3B91197037E2F30770AAAD9A58037EB6B8748B0A66E9CF738150A

Conclusión:

RDS original
     │
     ├── SHA-256
     │
     ▼
RDS clasificado
     │
     └── SHA-256 idéntico

Los archivos clasificados constituyen las copias preservadas de los objetos R originales.

9. Equivalencia R → Python

La auditoría automatizada se encuentra en:

scripts/validation/validate_r_python_embeddings.py

La validación comprobó:

dimensiones de T1, T2 y T3;
checksums numéricos;
prototipos semánticos;
dimensiones del PCA;
reconstrucción de emb_all;
center;
scale;
rango numérico;
desviaciones estándar;
varianza explicada;
loadings;
scores;
componentes numéricamente nulos;
PCA operacional.

Resultado:

PASS — equivalencia R → Python validada
       para el rango numéricamente identificable PC1–PC94.
10. Rango numérico

La matriz estandarizada presenta:

rango numérico = 94

Por tanto:

PC1–PC94

constituyen el rango numéricamente identificable.

A partir de:

PC95–PC120

las desviaciones estándar son numéricamente próximas a cero.

El máximo observado para esas componentes fue aproximadamente:

1.346 × 10⁻¹⁵

con una varianza relativa residual de aproximadamente:

2.596 × 10⁻³²

Estas componentes se clasifican como numéricamente nulas.

No se exige equivalencia vectorial individual entre R y Python para PC95–PC120, debido a la indeterminación numérica de la base dentro del espacio nulo.

11. Varianza explicada

Algunos puntos de referencia son:

ComponentesVarianza acumulada aproximada
PC850.86%
PC2178.72%
PC3189.52%
PC4195.00%
PC6099.0474%
PC94100%

La representación operacional seleccionada conserva:

PC1–PC60

con:

99.0474073656%

de la varianza total.

La selección de PC60 es una decisión operacional, no una afirmación de que 60 componentes sean universalmente óptimos para todos los modelos futuros.

12. PCA operacional Python

El artefacto operacional se encuentra en:

python/pca/

y fue generado mediante:

scripts/validation/build_operational_pca.py

La representación conserva:

scores:
120 × 60

loadings:
384 × 60

Además se conservan:

sdev
center
scale
variance
metadata

La PCA operacional utiliza los parámetros center y scale provenientes del PCA original de R.

Los signos de los componentes se alinean con los loadings de R para permitir la comparación numérica.

13. Validación del PCA operacional

La comparación independiente de scores R frente a Python para PC1–PC60 produjo:

max_abs_diff  = 5.24094656562113e-13
mean_abs_diff = 3.851946650944486e-14

Número de componentes con diferencia superior a:

1e-10

Resultado:

0

La varianza acumulada en PC60 es:

99.0474073656%

Por tanto:

PASS — PCA operacional PC1–PC60 validada.
14. Regla de conservación

La fuente histórica de verdad del PCA permanece en:

rds/pca/pca_embeddings.rds

Los CSV son representaciones derivadas destinadas a:

interoperabilidad;
inspección;
validación;
trazabilidad;
reproducción controlada.

Los artefactos Python son derivados operacionales y no sustituyen al objeto R original.

La PCA R original:

NO fue modificada.
15. Eliminación de duplicados

Antes de la consolidación existían copias redundantes directamente en:

data/processed/embeddings/

Las copias duplicadas fueron comparadas mediante SHA-256.

Los duplicados fueron byte-a-byte idénticos a los archivos organizados correspondientes.

Por esta razón se eliminaron únicamente las copias redundantes de la raíz.

La estructura organizada:

rds/
csv/
python/

permanece intacta.

No se eliminaron los objetos RDS preservados dentro de:

rds/
16. Scripts de validación

Los scripts relacionados con la migración y validación se encuentran en:

scripts/validation/

Entre ellos:

build_operational_pca.py
validate_r_python_embeddings.py

Estos scripts constituyen parte de la trazabilidad técnica de la migración.

Los artefactos de respaldo temporales no forman parte del pipeline operacional.

17. Documentación principal

La documentación técnica completa de la migración PCA se encuentra en:

docs/PCA_R_PYTHON_MIGRATION.md

Ese documento contiene:

metodología;
fórmulas;
dimensiones;
resultados;
tolerancias;
análisis del rango;
tratamiento de la indeterminación de signos;
tratamiento de componentes numéricamente nulos;
selección operacional;
diagramas de procedencia;
resultados de validación.
18. Estado final

La auditoría R → Python de embeddings y PCA se considera cerrada.

EMBEDDINGS
├── T1 40 × 384                 PASS
├── T2 40 × 384                 PASS
├── T3 40 × 384                 PASS
└── Prototipos 20 × 384         PASS

PCA R
├── Scores 120 × 120            PASS
├── Loadings 384 × 120          PASS
├── Center 384                  PASS
├── Scale 384                   PASS
└── Sdev 120                    PASS

EQUIVALENCIA
├── Rango = 94                  PASS
├── PC1–PC94                    PASS
├── PC95–PC120                  NUMÉRICAMENTE NULOS
└── PC1–PC60                    PASS

PCA OPERACIONAL
└── 60 componentes              99.0474% varianza

RESULTADO
└── PASS
19. Historial
2026-09-07
Auditoría estructural de los cinco objetos RDS.
Confirmación de T1, T2 y T3 como matrices 40 × 384.
Identificación de 20 prototipos semánticos de 384 dimensiones.
Identificación del objeto PCA prcomp.
Confirmación de PCA 120 × 120.
Exportación de componentes PCA a CSV.
Creación de estructura rds/.
Creación de estructura csv/.
Creación de estructura python/.
Verificación SHA-256 de los cinco RDS.
Confirmación de equivalencia R → Python para PC1–PC94.
Identificación de rango numérico 94.
Clasificación de PC95–PC120 como numéricamente nulos.
Generación de PCA operacional PC1–PC60.
Confirmación de 99.047407% de varianza acumulada.
Creación de scripts automatizados de validación.
Eliminación de copias duplicadas de la raíz.
Conservación de los objetos RDS clasificados.
Cierre de la auditoría de equivalencia R → Python.
