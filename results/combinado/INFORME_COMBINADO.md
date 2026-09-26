# Informe de resultados — comparación PILOTO vs PRINCIPAL

**Generado:** 2026-09-25 19:16  
**Cohorte:** las dos cohortes (17 + 23 = 40 observaciones-participante)  
**Datos de origen:** `Analisis agosto v2/` (corrida del script `Experimento ALC_v5_corregido.R`)  
**Contenido:** solo agregados (n, medias, desviaciones, efectos, p-valores). Este informe **no contiene narrativas** de participantes.  
**Muestra:** 17 piloto + 23 principal  

---


## 1. Advertencia imprescindible

> El piloto y el principal son **dos muestras distintas**, no dos olas del mismo estudio: 17 y 23
> participantes capturados en momentos diferentes, con instrumentos distintos (`demora` y `n_palabras`
> solo existen en el principal). Cualquier cifra agregada de «n = 40» mezcla cohortes y debe leerse
> con esa reserva. La columna `fuente` es la que permite separarlas.

- Participantes: **40**
- Observaciones por participante: **3** (T1, T2, T3) → total 120 observaciones

Reparto por condición:

| condición | participantes |
| --- | --- |
| Audio | 14 |
| Imagen | 12 |
| Texto | 14 |

Reparto por demora:

| demora | participantes |
| --- | --- |
| (no capturada) | 17 |
| D | 11 |
| ND | 12 |



## 2. Modelo de comparación

Se ajustó, para cada variable disponible en ambas cohortes, un modelo
`valor ~ fuente × condición × tiempo + (1 | participante)`.
La pregunta que responde la interacción `fuente:tiempo` es: **¿cambian igual a lo largo del
episodio las dos cohortes?**

| variable | efecto | F | df1 | df2 | p | p_ajustada |
| --- | --- | --- | --- | --- | --- | --- |
| n_palabras_calculado | fuente:tiempo | 6.8477 | 2.0000 | 68.0000 | 0.0020 | 0.0020 |

- **n_palabras_calculado**: F = 6.848 (p ajustada Holm = 0.0020) → la trayectoria difiere entre cohortes: **sí**.

### Efectos fijos del modelo de comparación, por variable

**n_palabras_calculado**

| efecto | Sum Sq | Mean Sq | NumDF | DenDF | F value | Pr(>F) |
| --- | --- | --- | --- | --- | --- | --- |
| fuente | 9.5662 | 9.5662 | 1.0000 | 34.0000 | 0.0060 | 0.9386 |
| condicion | 6495.0871 | 3247.5435 | 2.0000 | 34.0000 | 2.0463 | 0.1448 |
| tiempo | 61033.6545 | 30516.8273 | 2.0000 | 68.0000 | 19.2286 | 2.41e-07 |
| fuente:condicion | 565.6753 | 282.8376 | 2.0000 | 34.0000 | 0.1782 | 0.8375 |
| fuente:tiempo | 21735.1715 | 10867.5858 | 2.0000 | 68.0000 | 6.8477 | 0.0020 |
| condicion:tiempo | 10478.8815 | 2619.7204 | 4.0000 | 68.0000 | 1.6507 | 0.1717 |
| fuente:condicion:tiempo | 11690.6814 | 2922.6703 | 4.0000 | 68.0000 | 1.8416 | 0.1309 |


## 3. Replicabilidad: lectura de la interacción

Criterio explícito: si `fuente:tiempo` **no** es significativa, la trayectoria temporal es
estadísticamente compatible entre cohortes (lo que apoyaría la replicabilidad del patrón);
si es significativa, las cohortes **no** se comportan igual y el patrón del piloto no se replica
en el principal. La significación no mide magnitud: revisar F y R² junto al p-valor.


## 4. Descriptivos conjuntos (n = 40) — cohortes mezcladas

Estas tablas se calcularon sobre el conjunto completo; **no** están separadas por cohorte.


### Métricas lingüísticas

| variable | n | media | desv | mediana | iqr | ic95_inf | ic95_sup | min | max |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| n_palabras_t1 | 23.000 | 91.652 | 59.079 | 81.000 | 75.500 | 66.104 | 117.200 | 28.000 | 227.000 |
| n_palabras_t2 | 23.000 | 139.087 | 73.320 | 122.000 | 105.000 | 107.381 | 170.793 | 28.000 | 311.000 |
| n_palabras_t3 | 23.000 | 181.130 | 102.238 | 153.000 | 161.500 | 136.919 | 225.341 | 42.000 | 401.000 |
| ttr_t1 | 40.000 | 0.841 | 0.104 | 0.844 | 0.158 | 0.808 | 0.875 | 0.624 | 1.000 |
| ttr_t2 | 40.000 | 0.825 | 0.089 | 0.830 | 0.129 | 0.796 | 0.853 | 0.627 | 1.000 |
| ttr_t3 | 40.000 | 0.811 | 0.099 | 0.830 | 0.111 | 0.779 | 0.842 | 0.561 | 1.000 |


### Similitud semántica entre tiempos

| comparacion | n | media | desv | mediana | iqr | min | max |
| --- | --- | --- | --- | --- | --- | --- | --- |
| sim_sem_t1_t2 | 40.0000 | 0.8747 | 0.1670 | 0.9633 | 0.1697 | 0.3391 | 1.0000 |
| sim_sem_t1_t3 | 40.0000 | 0.8391 | 0.1836 | 0.8975 | 0.2075 | 0.3010 | 1.0000 |
| sim_sem_t2_t3 | 40.0000 | 0.9317 | 0.1177 | 0.9870 | 0.1009 | 0.4443 | 1.0000 |


### Cambio de proximidad a prototipos (T1→T3)

| prototipo | media_delta | sd_delta | mediana_delta |
| --- | --- | --- | --- |
| tristeza | 0.0250 | 0.0715 | 0.0162 |
| duda | 0.0195 | 0.0595 | 0.0028 |
| esperanza | 0.0160 | 0.0621 | 0.0055 |
| soledad | -0.0143 | 0.0828 | 0.0005 |
| agencia | 0.0135 | 0.0667 | 0.0028 |
| incertidumbre | 0.0119 | 0.0482 | 0.0045 |
| miedo | 0.0114 | 0.0586 | 0.0059 |
| control | 0.0096 | 0.0541 | 0.0018 |
| evitacion | 0.0075 | 0.0554 | 0.0000 |
| afrontamiento | 0.0062 | 0.0702 | 0.0000 |
| confianza | 0.0057 | 0.0477 | 0.0053 |
| espera | 0.0048 | 0.0479 | 0.0025 |
| pasividad | -0.0029 | 0.0547 | 0.0000 |
| espacio | -0.0023 | 0.0749 | 0.0000 |
| desconexion | -0.0016 | 0.0564 | 0.0000 |
| objetos | -0.0011 | 0.0651 | 0.0000 |
| incomunicacion | 0.0002 | 0.0406 | 0.0048 |


### Cambio semántico global (distancia euclidiana)

| condicion | media | desv | mediana |
| --- | --- | --- | --- |
| Audio | 2.3452 | 2.6063 | 1.1179 |
| Imagen | 5.7681 | 4.7463 | 4.6750 |
| Texto | 3.3311 | 3.2743 | 2.7828 |


### Diccionarios temáticos (tasas por 1000 palabras)

| condicion | iteracion | tema | n | media | desv | mediana | iqr |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Audio | 1.000 | rate_desconexion | 14.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Audio | 1.000 | rate_duda | 14.000 | 1.196 | 3.474 | 0.000 | 0.000 |
| Audio | 1.000 | rate_emociones_negativas | 14.000 | 0.900 | 2.406 | 0.000 | 0.000 |
| Audio | 1.000 | rate_espacio | 14.000 | 26.251 | 33.638 | 11.281 | 23.631 |
| Audio | 1.000 | rate_espera | 14.000 | 1.872 | 5.135 | 0.000 | 0.000 |
| Audio | 1.000 | rate_incomunicacion | 14.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Audio | 1.000 | rate_luz_sombra | 14.000 | 1.548 | 3.999 | 0.000 | 0.000 |
| Audio | 1.000 | rate_objetos | 14.000 | 22.870 | 29.982 | 10.457 | 18.402 |
| Audio | 1.000 | rate_pasividad | 14.000 | 3.199 | 9.414 | 0.000 | 0.000 |
| Audio | 1.000 | rate_soledad | 14.000 | 24.009 | 20.684 | 20.050 | 23.260 |
| Audio | 2.000 | rate_desconexion | 14.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Audio | 2.000 | rate_duda | 14.000 | 0.750 | 1.964 | 0.000 | 0.000 |
| Audio | 2.000 | rate_emociones_negativas | 14.000 | 3.412 | 5.545 | 0.000 | 4.273 |
| Audio | 2.000 | rate_espacio | 14.000 | 20.459 | 14.803 | 13.564 | 22.611 |
| Audio | 2.000 | rate_espera | 14.000 | 2.023 | 4.379 | 0.000 | 0.000 |
| Audio | 2.000 | rate_incomunicacion | 14.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Audio | 2.000 | rate_luz_sombra | 14.000 | 2.738 | 4.870 | 0.000 | 4.630 |
| Audio | 2.000 | rate_objetos | 14.000 | 22.868 | 19.593 | 14.908 | 21.941 |
| Audio | 2.000 | rate_pasividad | 14.000 | 2.012 | 3.654 | 0.000 | 3.261 |
| Audio | 2.000 | rate_soledad | 14.000 | 22.177 | 14.854 | 17.783 | 21.063 |
| Audio | 3.000 | rate_desconexion | 14.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Audio | 3.000 | rate_duda | 14.000 | 0.581 | 1.580 | 0.000 | 0.000 |
| Audio | 3.000 | rate_emociones_negativas | 14.000 | 3.551 | 4.699 | 0.000 | 6.642 |
| Audio | 3.000 | rate_espacio | 14.000 | 20.508 | 17.376 | 13.947 | 26.283 |
| Audio | 3.000 | rate_espera | 14.000 | 2.540 | 5.158 | 0.000 | 0.000 |
| Audio | 3.000 | rate_incomunicacion | 14.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Audio | 3.000 | rate_luz_sombra | 14.000 | 3.125 | 6.087 | 0.000 | 4.688 |
| Audio | 3.000 | rate_objetos | 14.000 | 23.397 | 19.854 | 14.005 | 32.021 |
| Audio | 3.000 | rate_pasividad | 14.000 | 0.997 | 2.155 | 0.000 | 0.000 |
| Audio | 3.000 | rate_soledad | 14.000 | 18.782 | 13.719 | 13.614 | 17.722 |


## 5. Análisis de sensibilidad y robustez

Modelos alternativos para comprobar si el efecto de tiempo depende de una sola especificación.

**Tres advertencias para leer la tabla siguiente** (son propiedades de la tabla, no de los datos):

1. La fila `primario` **no** es del conjunto de 40: es el modelo de `n_palabras` del BLOQUE 10, que
   solo puede usar el principal (**N = 69, 23 participantes**) porque en el piloto esa columna está
   vacía. Las demás filas usan las 120 observaciones de 40 participantes. Compárense solo dentro de
   cada bloque de N.
2. `efecto_tiempo` / `p_tiempo` y `efecto_condicion` / `p_condicion` son el **coeficiente del primer
   contraste** (T2 frente a T1, y la primera condición frente a la de referencia), **no** la prueba
   ómnibus del factor. Las pruebas ómnibus están en `piloto/tablas/resumen_modelos_validos.csv`
   (por cohorte) y en `combinado/tablas/comparacion_*_ANOVA.csv`.
3. La fila `sin_outliers` no existe: el criterio del script (|residuo| > 2.5) marca 115 de 120
   observaciones y el reajuste no se pudo estimar. No hay resultados corregidos por outliers.

Con esas reservas, el patrón de la tabla es: el efecto de tiempo se mantiene al añadir `demora`
y en el modelo de exposición, pero **no** sobrevive a la transformación logarítmica (ver informe
de discusión).

| modelo | N | participantes | AIC | BIC | R2_marginal | R2_condicional | efecto_tiempo | p_tiempo | efecto_condicion | p_condicion | interaccion | p_interaccion | conclusion |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| primario | 69.0000 | 23.0000 | 777.9514 | 804.7607 | 0.2261 | 0.7936 | 49.6250 | 0.0153 | 21.3750 | 0.5790 | 1.3750 | 0.9609 | efecto tiempo significativo |
| con_demora | 120.0000 | 40.0000 | 697.4782 | 724.2875 | 0.1958 | 0.7944 | 49.6250 | 0.0238 | 21.3750 | 0.6131 | 1.3750 | 0.9635 | efecto tiempo significativo |
| log_n_palabras | 120.0000 | 40.0000 | 191.3958 | 222.0582 | 0.1783 | 0.7382 | 0.1443 | 0.2577 | 0.0374 | 0.8681 | 0.2953 | 0.1030 | sin efecto |
| log_n_tokens | 120.0000 | 40.0000 | 184.6349 | 215.2973 | 0.1714 | 0.7436 | 0.1586 | 0.1975 | 0.0182 | 0.9343 | 0.3016 | 0.0844 | sin efecto |
| n_estimulos | 120.0000 | 40.0000 | 1296.6072 | 1318.9071 | 0.1642 | 0.7351 | — | — | 13.9592 | 0.6170 | — | — | sin efecto |


## 6. Figuras comparativas

- `C:/Users/saraq/Downloads/Experimento Alfonso Lopez Corral/Analisis agosto v2/combinado/graficas_es/COMPARACION_n_palabras_calculado_ES.pdf`
- `C:/Users/saraq/Downloads/Experimento Alfonso Lopez Corral/Analisis agosto v2/combinado/graficas_es/COMPARACION_n_palabras_calculado_ES.png`

- `C:/Users/saraq/Downloads/Experimento Alfonso Lopez Corral/Analisis agosto v2/combinado/figures_en/COMPARISON_n_palabras_calculado_EN.pdf`
- `C:/Users/saraq/Downloads/Experimento Alfonso Lopez Corral/Analisis agosto v2/combinado/figures_en/COMPARISON_n_palabras_calculado_EN.png`


## 7. Lo que este informe NO permite afirmar

- **No** autoriza a tratar n = 40 como una sola muestra.
- **No** establece causalidad de la condición sobre el cambio: no hay asignación aleatoria
  documentada ni manipulación del orden de los estímulos.
- Las diferencias entre cohortes pueden deberse al instrumento (el principal añade `demora`), al
  momento de captura o a las personas, no al diseño del estímulo.

