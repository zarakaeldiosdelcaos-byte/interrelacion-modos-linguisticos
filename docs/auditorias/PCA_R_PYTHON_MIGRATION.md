
PCA R → Python: documentación técnica de migración y validación

Proyecto: experimento-nlp
Fecha de auditoría: 2026-09-07
Estado: PASS
Tipo de documento: especificación técnica y auditoría de equivalencia numérica

1. Propósito

Este documento formaliza la migración de la etapa de embeddings y análisis de componentes principales (PCA) desde el pipeline original en R hacia Python.

El objetivo no es sustituir retrospectivamente los resultados originales, sino demostrar que Python puede reproducirlos de manera numéricamente equivalente y establecer una representación operacional controlada.

La jerarquía de procedencia es:

R original
   ↓
artefactos RDS
   ↓
exportaciones CSV
   ↓
reconstrucción Python
   ↓
validación numérica
   ↓
artefacto PCA operacional

El PCA original de R permanece preservado.

2. Artefactos de entrada
2.1 Embeddings

Los tres conjuntos temporales tienen dimensión:

$$ 40 \times 384 $$

Por tanto:

$$ X_{T1},X_{T2},X_{T3}\in\mathbb{R}^{40\times384} $$

Cada fila representa un embedding semántico de 384 dimensiones.

2.2 Prototipos semánticos

Se dispone de:

$$ 20 $$

prototipos semánticos, cada uno con:

$$ 384 $$

dimensiones.

Los prototipos corresponden a categorías semánticas utilizadas por el pipeline original.

3. Construcción de la matriz conjunta

El código original en R realiza:

completos <- complete.cases(emb_t1, emb_t2, emb_t3)

emb_all <- rbind(
  emb_t1[completos, ],
  emb_t2[completos, ],
  emb_t3[completos, ]
)

Se identificaron:

$$ 40 $$

casos completos.

Por tanto:

$$ X= \begin{bmatrix} X_{T1}\\ X_{T2}\\ X_{T3} \end{bmatrix} $$

con:

$$ X\in\mathbb{R}^{120\times384} $$

El orden de filas es:

1–40    T1
41–80   T2
81–120  T3

Este orden fue preservado durante la reconstrucción Python.

4. Estandarización

La PCA original se calcula mediante:

prcomp(
    emb_all,
    center = TRUE,
    scale. = TRUE
)

Para cada variable \(j\):

$$ Z_{ij} = \frac{X_{ij}-\mu_j}{s_j} $$

donde:

\(X_{ij}\) es el valor original;
\(\mu_j\) es el centro calculado por R;
\(s_j\) es el factor de escala calculado por R.

La migración Python utiliza explícitamente los valores exportados por R:

pca_embeddings_center.csv
pca_embeddings_scale.csv

Esto es importante porque evita recalcular parámetros potencialmente diferentes durante la validación.

La matriz resultante es:

$$ Z\in\mathbb{R}^{120\times384} $$
5. PCA mediante descomposición en valores singulares

Conceptualmente, la PCA puede expresarse mediante la descomposición:

$$ Z=U\Sigma V^T $$

donde:

\(U\) contiene los vectores singulares izquierdos;
\(\Sigma\) contiene los valores singulares;
\(V\) contiene los vectores singulares derechos.

Los loadings de PCA corresponden a:

$$ V $$

Por tanto:

$$ \text{loadings}=V $$

Los scores se obtienen como:

$$ T=ZV $$

donde:

$$ T\in\mathbb{R}^{120\times120} $$

en la PCA completa.

6. Desviación estándar de los componentes

Los valores sdev de prcomp se relacionan con los valores singulares mediante:

$$ s_k= \frac{\sigma_k}{\sqrt{n-1}} $$

donde:

$$ n=120 $$

Por tanto:

$$ s_k= \frac{\sigma_k}{\sqrt{119}} $$

La implementación Python reproduce estos valores dentro de precisión de punto flotante.

La diferencia máxima observada fue:

$$ 8.882\times10^{-15} $$
7. Varianza explicada

La proporción de varianza explicada por el componente \(k\) es:

$$ VE_k= \frac{s_k^2} {\sum_j s_j^2} $$

En porcentaje:

$$ VE_k(\%)= 100 \frac{s_k^2} {\sum_j s_j^2} $$

La varianza acumulada hasta el componente \(K\) es:

$$ VE_{\text{cum}}(K) = \sum_{k=1}^{K}VE_k $$
8. Varianza explicada observada

Los primeros componentes presentan:

PCVarianza %Acumulada %
112.675012.6750
27.509020.1840
36.873127.0571
45.506832.5639
55.362037.9258
64.592342.5181
74.287346.8054
84.054150.8594
93.810154.6695
103.325157.9946
201.513678.7197
300.818489.5191
400.414994.9821
500.192497.6911
600.099799.0474
700.045699.6850
800.014499.9309
900.003099.9937
94~0.0009~100.0000

Umbrales operativos aproximados:

50%  → PC8
70%  → PC15
80%  → PC21
90%  → PC31
95%  → PC41
99%  → PC60

El valor calculado para PC60 es:

$$ 99.04740736560767\% $$
9. Rango numérico

La matriz estandarizada presenta:

$$ \operatorname{rank}(Z)=94 $$

utilizando una tolerancia numérica:

1e-12

La singularidad efectiva aparece después de PC94.

Por tanto:

PC1–PC94    → rango numéricamente identificable
PC95–PC120  → espacio numéricamente nulo

El valor de sdev máximo observado dentro de PC95–PC120 es aproximadamente:

$$ 1.346\times10^{-15} $$

La varianza relativa asociada a este bloque es:

$$ 2.596\times10^{-32} $$

Esto confirma que PC95–PC120 no contienen varianza numéricamente relevante.

10. Por qué R y Python pueden diferir después de PC94

Una PCA no determina una base única en un espacio donde los autovalores son cero o prácticamente cero.

Mientras que los primeros componentes poseen valores singulares claramente distintos de cero, después del rango efectivo las direcciones corresponden a un espacio nulo.

En ese espacio:

$$ \lambda_k\approx0 $$

por lo que diferentes implementaciones pueden producir diferentes bases ortonormales sin cambiar la información sustantiva contenida en los datos.

Por esta razón:

PC1–PC94

se comparan componente por componente.

En cambio:

PC95–PC120

se clasifican como numéricamente nulos y no se exige identidad vectorial individual.

11. Indeterminación de signo

Cada componente de PCA presenta una indeterminación de signo.

Si:

$$ v_k $$

es un vector propio válido, entonces:

$$ -v_k $$

también lo es.

Por tanto:

$$ v_k \quad\text{y}\quad -v_k $$

representan exactamente la misma dirección.

Para comparar R y Python se realizó alineación de signos de los componentes.

Esto permite una comparación directa de:

loadings;
scores.

sin interpretar una inversión de signo como una discrepancia sustantiva.

12. Validación de equivalencia

La validación produjo:

R scores:       (120, 120)
R rotation:     (384, 120)
Python scores:  (120, 120)
Python rotation:(384, 120)
12.1 Varianza explicada

Diferencia máxima:

$$ 1.665\times10^{-16} $$

Resultado:

PASS
12.2 SDEV

Diferencia máxima:

$$ 8.882\times10^{-15} $$

Resultado:

PASS
12.3 Loadings

Para PC1–PC94:

$$ \max|\Delta| = 5.185\times10^{-14} $$

Resultado:

PASS
12.4 Scores

Para PC1–PC94:

$$ \max|\Delta| = 5.241\times10^{-13} $$

Resultado:

PASS

Estos valores son compatibles con diferencias de representación de punto flotante y no indican divergencia metodológica.

13. Integridad de los artefactos RDS

Se realizó una comparación SHA-256 de los archivos originales y sus copias organizadas.

Resultado:

OK embeddings_t1.rds
OK embeddings_t2.rds
OK embeddings_t3.rds
OK prototipos_semanticos.rds
OK pca_embeddings.rds

Las copias son byte-identical respecto de los originales.

La migración no sobrescribió los archivos RDS de origen.

14. PCA operacional

Aunque la PCA completa contiene 120 componentes, solamente 94 poseen rango numérico efectivo.

Se definió una representación operacional de:

$$ K=60 $$

componentes.

Por tanto:

$$ T_{\text{operacional}} = T_{[:,1:60]} $$

con:

$$ VE_{\text{cum}}(60) = 99.047407\% $$

Esta decisión tiene tres propiedades:

conserva prácticamente toda la varianza;
evita incorporar componentes numéricamente nulos;
produce una representación considerablemente menor que 384 dimensiones.

15. Justificación de PC1–PC60

PC1–PC60 no se presentan como una verdad matemática universal.

Es una decisión operacional basada en:

$$ VE_{\text{cum}}(60)\approx99.05\% $$

La selección puede cambiar dependiendo del objetivo.

Visualización
    ↓
PC1–PC2

Exploración / clustering
    ↓
PC1–PC21
o
PC1–PC31

Modelado conservador
    ↓
PC1–PC41

Máxima conservación práctica
    ↓
PC1–PC60

Para modelos predictivos futuros, la cantidad óptima de componentes debe evaluarse mediante validación cruzada.

16. Arquitectura de procedencia

flowchart TD
    A[R pipeline original]

    A --> B[Embeddings T1]
    A --> C[Embeddings T2]
    A --> D[Embeddings T3]
    A --> E[Prototipos semánticos]
    A --> F[PCA R completa]

    B --> G[Reconstrucción emb_all]
    C --> G
    D --> G

    F --> H[Center / Scale R]

    G --> I[Pipeline de validación Python]
    H --> I

    I --> J[PC1-PC94]
    I --> K[PC95-PC120]

    J --> L[Equivalencia numérica]
    K --> M[Componentes numéricamente nulos]

    J --> N[PCA operacional]
    N --> O[PC1-PC60]

    O --> P[99.047407% varianza]

17. Flujo matemático

flowchart LR

    A["Embeddings<br/>120 × 384"]
    --> B["Center / Scale"]
    --> C["Z<br/>120 × 384"]
    --> D["SVD<br/>Z = UΣVᵀ"]
    --> E["Loadings<br/>V"]
    --> F["Scores<br/>ZV"]
    --> G["Varianza explicada"]
    --> H["Selección operacional"]

18. Frontera del rango

flowchart LR

    A[PC1]
    --> B["..."]
    --> C[PC94]
    --> D["Rango numérico = 94"]
    --> E[PC95]
    --> F["..."]
    --> G[PC120]
    --> H["Varianza numéricamente nula"]

19. Selección operacional

flowchart TD

    A[PCA completa]

    A --> B[PC1-PC94]

    B --> C{Objetivo}

    C --> D["Visualización<br/>PC1-PC2"]
    C --> E["Exploración<br/>PC1-PC21 / PC31"]
    C --> F["Modelado conservador<br/>PC1-PC41"]
    C --> G["Máxima conservación práctica<br/>PC1-PC60"]

    G --> H["99.047407% varianza"]

20. Artefactos generados

La PCA operacional Python se encuentra en:

data/processed/embeddings/python/pca/

Archivos:

pca_embeddings_pc60_scores.csv
pca_embeddings_pc60_loadings.csv
pca_embeddings_pc60_sdev.csv
pca_embeddings_pc60_center.csv
pca_embeddings_pc60_scale.csv
pca_embeddings_pc60_variance.csv
metadata.json

El archivo metadata.json registra:

origen R;
matriz utilizada;
dimensiones;
algoritmo;
alineación de signos;
rango;
componentes informativos;
componentes nulos;
número de componentes operacionales;
varianza acumulada;
preservación del PCA original.
21. Scripts de validación
Construcción de PCA operacional
scripts/validation/build_operational_pca.py
Validación R → Python
scripts/validation/validate_r_python_embeddings.py

La validación debe ejecutarse desde la raíz:

python scripts/validation/validate_r_python_embeddings.py
22. Criterios de aceptación

La migración se considera validada cuando se cumplen simultáneamente:

[PASS] dimensiones de embeddings
[PASS] checksums
[PASS] prototipos
[PASS] reconstrucción de emb_all
[PASS] center / scale
[PASS] rango numérico
[PASS] explained variance
[PASS] sdev
[PASS] loadings PC1–PC94
[PASS] scores PC1–PC94
[PASS] clasificación PC95–PC120
[PASS] PCA operacional PC1–PC60
[PASS] preservación PCA R original
23. Tolerancias

Las comparaciones utilizan tolerancias numéricas debido a la representación de números reales en punto flotante.

Resultados observados:

ElementoDiferencia máxima
Explained variance1.665e-16
SDEV8.882e-15
Loadings PC1–PC945.185e-14
Scores PC1–PC945.241e-13

Estas magnitudes son muy inferiores a niveles que indicarían una diferencia metodológica.

El checksum T2 utiliza una tolerancia de:

1e-7

porque el valor de referencia R utilizado en la auditoría estaba redondeado:

Python = 0.670081264633
R       = 0.6700813

La diferencia observada es aproximadamente:

$$ 3.54\times10^{-8} $$

y corresponde al redondeo del valor de referencia.

24. Limitaciones

Esta validación demuestra equivalencia numérica de la etapa de embeddings/PCA.

No demuestra por sí misma:

validez clínica;
validez predictiva;
generalización fuera de la muestra;
optimalidad universal de PC1–PC60;
equivalencia de módulos NLP todavía no auditados;
equivalencia de modelos posteriores que utilicen los embeddings.

La equivalencia aquí demostrada es específicamente:

R embeddings / PCA
        ↓
Python embeddings / PCA

dentro del rango numéricamente identificable.

25. Decisión metodológica final

Se establece como regla de la migración:

Los artefactos originales de R se conservan sin modificación. Python reproduce el procedimiento y genera artefactos derivados. La equivalencia se evalúa componente por componente únicamente dentro del rango numéricamente identificable.

En consecuencia:

PCA R completa
      │
      ├── preservada
      │
      ├── PC1–PC94
      │      └── equivalencia validada
      │
      └── PC95–PC120
             └── numéricamente nulos

PCA Python operacional
      │
      └── PC1–PC60
             └── 99.047407% varianza
26. Resultado final de auditoría
======================================================================
VALIDACIÓN R → PYTHON
======================================================================

PASS — equivalencia R → Python validada para PC1–PC94.

PASS — PCA operacional PC1–PC60 validada.

INFO — PC95–PC120 clasificados como componentes
       numéricamente nulos.

INFO — PCA R original preservada como fuente de verdad.

Fecha de auditoría: 2026-09-07
Estado: PASS
======================================================================
27. Cierre de la etapa

La etapa de migración de embeddings y PCA queda formalmente cerrada.

La infraestructura resultante proporciona:

proveniencia, porque se preservan los artefactos originales;
reproducibilidad, porque la reconstrucción Python está automatizada;
equivalencia numérica, porque PC1–PC94 coinciden dentro de tolerancias;
control de degeneración numérica, porque PC95–PC120 se identifican como nulos;
representación operacional, mediante PC1–PC60;
trazabilidad, mediante metadata.json y los scripts de validación;
auditabilidad, mediante checksums, dimensiones, tolerancias y resultados registrados.

Estado final: PASS

Fecha: 2026-09-07
