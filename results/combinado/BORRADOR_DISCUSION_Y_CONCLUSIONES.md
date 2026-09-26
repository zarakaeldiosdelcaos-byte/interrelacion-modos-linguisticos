# Borrador de discusión y conclusiones

**Qué es este documento.** Es un borrador de discusión para el manuscrito del estudio, escrito contra los
resultados de la corrida completa del pipeline (`Experimento ALC_v5_corregido.R`) y contra el marco
conceptual del artículo de López Corral y colaboradores (2024). **No es el artículo**: es el material del
que se puede partir para redactarlo, con cada afirmación amarrada a un artefacto concreto.

**Qué no es.** No contiene narrativas de participantes (solo agregados), no introduce citas que no estén en
el artículo o en los artefactos del proyecto, y no convierte en resultado ningún cálculo que no se haya
ejecutado. Donde un análisis no se pudo hacer, se dice.

**Trazabilidad.** Todos los números provienen de `Analisis agosto v2/`, corrida del script
`Experimento ALC_v5_corregido.R`. Los informes por cohorte (`INFORME_PILOTO.md`, `INFORME_PRINCIPAL.md`,
`INFORME_COMBINADO.md`) llevan, cada uno, la lista de artefactos de los que sale cada cifra.

---

## 1. El artículo de referencia y su traducción al diseño de este estudio

El artículo que enmarca el trabajo es una **propuesta metodológica**, no un estudio empírico: revisa los
modelos cognoscitivos y conductuales de la escritura, desarrolla las nociones de *modos lingüísticos* y
*habilitación lingüística*, y propone la *alternación de modos lingüísticos* como vía para estudiar la
extensión del episodio de escritura y la conexión entre sus segmentos. Cierra esbozando las
características de una tarea experimental que permita evaluar distintos grados de molaridad–molecularidad
del escribir, entendido como actividad extensible en el tiempo y en el espacio, segmentable en múltiples
episodios interrelacionados (López Corral, Rey Murrieta, Acuña Meléndrez & Jiménez, 2024).

La consecuencia para la discusión es de fondo: **el artículo no formula hipótesis con umbrales ni
predicciones cuantitativas que este estudio pueda "confirmar" o "refutar"**. Lo que sí permite es leer los
resultados en sus términos y evaluar si la tarea produce información del tipo que el artículo reclama.
Conviene, por tanto, evitar la fórmula "los resultados confirman la propuesta" y usar en su lugar "los
resultados son compatibles con…" o "el diseño permitió observar…".

Traducción de cada constructo a una medida concreta de este estudio:

| Constructo del artículo | Cómo se operacionalizó aquí | Dónde está el número |
|---|---|---|
| Escribir como **modo lingüístico activo**, suplementado por modos reactivos (observar, escuchar, leer) | Condiciones experimentales **Imagen** (observar), **Audio** (escuchar), **Texto** (leer) | `n_palabras_calculado` por condición × tiempo |
| **Habilitación lingüística**: los modos reactivos anteceden y retroalimentan a los activos | T1 sin estímulo → T2 con un estímulo → T3 con tres estímulos acumulados | modelo `valor ~ condición × tiempo` por cohorte |
| **Alternación de modos** y **segmentación** del episodio (Segmento A → Segmento B, "Referente AB") | Tres textos sucesivos del mismo participante sobre el mismo referente (T1, T2, T3) | comparación de trayectorias; similitud semántica entre tiempos |
| **Extensión del episodio de escritura** | Número de palabras del texto | `n_palabras` (principal) y `n_palabras_calculado` (ambas cohortes) |
| **Conexión entre segmentos** | Similitud semántica (coseno sobre embeddings) T1–T2, T2–T3, T1–T3; cambio de proximidad a prototipos | `resultados/tablas/descriptivos_semantica.csv`, `cambios_prototipos.csv` |
| **Imaginar** como uso de lo previamente observado/escuchado/leído | Acumulación de los tres estímulos en T3 | medias de T3 frente a T1 por condición |

**Una brecha que hay que declarar.** El artículo insiste en disponer de **medidas directas e indirectas a lo
largo de todo el episodio**: antes de escribir (contacto con el referente), al escribir y después de
escribir, para transitar "de un análisis enfocado en los productos o resultados de la escritura hacia un
análisis centrado en la actividad misma de escribir". Este estudio **no** registra la actividad mientras se
escribe: captura tres productos sucesivos. Es decir, implementa la *segmentación* (A → B) pero no la
*alternación concurrente*. Cualquier conclusión sobre la alternación misma es, en este material,
una inferencia a partir de los productos, no una observación de la alternación.

---

## 2. Resultados: lo que muestran los modelos

### 2.1 Cohorte principal (23 participantes, 69 observaciones)

| Efecto | F | gl | p | Lectura |
|---|---|---|---|---|
| tiempo | 25.50 | 2, 40 | 7.2 × 10⁻⁸ | **sí**: el texto se extiende a lo largo del episodio |
| condición | 0.60 | 2, 20 | 0.559 | no |
| condición × tiempo | 0.075 | 4, 40 | 0.989 | no: las tres condiciones crecen igual |

R² marginal = 0.197; R² condicional = 0.787. Medias de extensión (`n_palabras`):

| Condición | T1 | T2 | T3 |
|---|---|---|---|
| Texto | 88.5 | 138.1 | 184.6 |
| Audio | 109.9 | 160.9 | 200.5 |
| Imagen | 74.4 | 115.3 | 155.0 |

Contrastes entre tiempos dentro de cada condición, con ajuste Holm
(`principal/tablas/principal_n_palabras_calculado_contrastes_tiempo.csv`):

| Condición | T1 → T2 | T1 → T3 | T2 → T3 |
|---|---|---|---|
| Texto | −49.6 (p = 0.048) | −96.1 (p = 1.5 × 10⁻⁴) | −46.5 (p = 0.048) |
| Audio | −51.0 (p = 0.041) | −90.6 (p = 3.3 × 10⁻⁴) | −39.6 (p = 0.068) |
| Imagen | −40.9 (p = 0.156) | −80.6 (p = 0.0029) | −39.7 (p = 0.156) |

Las tres condiciones muestran un incremento significativo de T1 a T3, y dos de ellas ya en el paso
intermedio. Diferencias de 81 a 96 palabras en el mismo sentido y con la misma magnitud aproximada.

**Lectura.** En el principal, la extensión del texto crece con cada segmento del episodio, y crece **por
igual** en las tres condiciones: no hay evidencia de que el modo reactivo (leer, escuchar, observar) module
la extensión de manera diferencial. En términos del artículo: lo que se observa es un efecto de la
**acumulación de contacto con el referente**, no del **tipo de modo** por el que se estableció ese contacto.

### 2.2 Cohorte piloto (17 participantes, 51 observaciones)

| Efecto | F | gl | p | Lectura |
|---|---|---|---|---|
| tiempo | 1.84 | 2, 28 | 0.177 | no |
| condición | 1.70 | 2, 14 | 0.218 | no |
| condición × tiempo | 3.64 | 4, 28 | **0.016** | sí, pero ver reservas |

R² marginal = 0.208; R² condicional = 0.800. Medias (`n_palabras_calculado`):

| Condición | T1 | T2 | T3 |
|---|---|---|---|
| Texto | 143.7 | 116.8 | 116.5 |
| Audio | 133.7 | 172.2 | 216.8 |
| Imagen | 97.8 | 103.2 | 110.6 |

Contrastes con ajuste Holm: en Audio, T1 → T3 = −83.2 palabras (p = 0.001); Audio frente a Texto en T3 =
106.2 (p = 0.072); Audio frente a Imagen en T3 = 106.2 (p = 0.072).

**Lectura.** En el piloto el patrón es el inverso: **no** hay efecto principal de tiempo, pero **sí** una
interacción, arrastrada por el crecimiento del grupo Audio (escuchar) mientras Texto se mantiene y hasta
retrocede. Es la única señal del material que apunta a que el **modo** importe: escuchar habilitaría más
extensión que leer o que observar. Con 6 participantes por celda, sin efecto principal y con dos contrastes
en el límite de la significación, esto debe presentarse como **exploratorio**, no como hallazgo.

### 2.3 Comparación de las dos cohortes (modelo conjunto, 120 observaciones)

| Efecto | F | gl | p |
|---|---|---|---|
| tiempo | 19.23 | 2, 68 | 2.4 × 10⁻⁷ |
| **fuente : tiempo** | **6.85** | **2, 68** | **0.0020** |
| fuente | 0.006 | 1, 34 | 0.939 |
| condición | 2.05 | 2, 34 | 0.145 |
| fuente : condición | 0.18 | 2, 34 | 0.838 |
| condición : tiempo | 1.65 | 4, 68 | 0.172 |
| fuente : condición : tiempo | 1.84 | 4, 68 | 0.131 |

**Lectura.** El nivel general de extensión **no** difiere entre cohortes (fuente: p = 0.939), pero **las
trayectorias sí** (fuente:tiempo: p = 0.002). Dicho de otro modo: lo que no replica entre el piloto y el
principal no es "cuánto se escribe", sino **cómo cambia a lo largo del episodio**. Ese es el resultado
central del informe combinado y la razón por la que no procede presentar n = 40 como una sola muestra.

### 2.4 Cuánta varianza se juega dónde

El R² condicional es ≈ 0.79 en las tres especificaciones (piloto 0.800, principal 0.787, conjunto 0.794),
mientras el marginal no pasa de 0.23. Traducido: **cerca de cuatro quintas partes de la variación en la
extensión es variación entre personas, no entre condiciones ni entre tiempos**. Cualquier afirmación sobre
el efecto del modo de contacto tiene que ser, por necesidad, intra-sujeto y con muestras grandes; con 17 y
23 participantes, la condición compite contra una heterogeneidad individual enorme.

---

## 3. El plano semántico y léxico

Estas medidas se calcularon sobre el **conjunto de 40** y **no** están desagregadas por cohorte: sirven para
describir el material, no para comparar cohortes.

**Continuidad entre segmentos.** Similitud semántica (coseno, n = 40): T1–T2 = 0.875; **T2–T3 = 0.932**;
T1–T3 = 0.839. El texto se parece más al inmediatamente anterior que al inicial, y esa cercanía creciente es
compatible con la idea del artículo de que los segmentos **pertenecen al mismo episodio** y se van
encadenando sobre un referente que ya se ha transformado en escrito (el "Referente AB"): el escritor no
vuelve al referente original, sino que trabaja sobre lo que ya escribió. Es el resultado más limpio del
plano semántico y el que mejor conversa con el marco.

**Desplazamiento de contenido.** Los cambios de proximidad a prototipos son pequeños en magnitud y con
desviaciones mayores que sus medias (el mayor: tristeza, media Δ = 0.025, DE = 0.072; soledad Δ = −0.014,
DE = 0.083). Con ese cociente **no hay evidencia de un desplazamiento semántico claro** hacia los
constructos clínicos o de la estética de Hopper. Presentarlos como tendencias requeriría prueba inferencial
y desagregación por cohorte, que no están hechas.

**Distancia semántica global (T1 → T3)**, por condición y sin prueba: Imagen 5.77 (DE 4.75) > Texto 3.33
(DE 3.27) > Audio 2.35 (DE 2.61). Es un descriptivo sugerente —quien observó la imagen cambiaría más su
texto— pero con esa dispersión y sin test no sostiene una afirmación.

**Diccionarios temáticos.** Las tasas por 1000 palabras muestran que el corpus **sí** contiene los temas
esperados (soledad ≈ 24 → 19 → 19, objetos ≈ 23 estable, espacio ≈ 26 → 20 → 20 en Audio), con dispersiones
del mismo orden que las medias: distribuciones muy asimétricas, con participantes que no activan el tema.
Dos temas del diccionario (**desconexión** e **incomunicación**) tienen tasa exactamente 0 en todas las
celdas: los términos elegidos no aparecen nunca en estos textos. Y la riqueza léxica (TTR) **baja** de T1 a
T3 (0.841 → 0.825 → 0.811), lo que es esperable por puro efecto de longitud del texto —el propio script lo
advierte en la figura— y no debe leerse como empobrecimiento.

**Advertencia sobre los diccionarios.** En este material, el enriquecimiento de los diccionarios usa una
lista de términos aceptados fijada en el código, no derivada de los datos (el propio script lo etiqueta como
"selección manual (simulada)"). Si el manuscrito reporta esos diccionarios, hay que decir de dónde salen.

---

## 4. Sensibilidad: qué aguanta y qué no

| Especificación | p del contraste de tiempo | Qué implica |
|---|---|---|
| Modelo primario (n_palabras, 23 participantes) | 0.0153 | significativo |
| Con `demora` (120 obs, 40 participantes) | 0.0238 | significativo: la demora no lo explica |
| Logarítmico (log n_palabras) | 0.258 | **no** significativo |
| Log de tokens | 0.198 | **no** significativo |
| Exposición acumulada (`n_estimulos`) | — | no estimable como efecto de tiempo (es función del tiempo) |
| Sin outliers | — | **no existe**: el criterio marca 115 de 120 observaciones |

Tres cosas que hay que decir en voz alta:

1. **El efecto de tiempo no sobrevive a la transformación logarítmica.** En escala cruda el crecimiento es
   claro; en escala logarítmica, no. Eso apunta a que la diferencia entre T1 y T3 está dominada por los
   textos largos: el efecto está en la cola, no en el cuerpo de la distribución. Es exactamente el tipo de
   resultado que una prueba de robustez existe para detectar, y debe entrar al manuscrito.
2. **El análisis de outliers no se pudo hacer.** Un criterio de |residuo| > 2.5 marca 115 de 120
   observaciones: con ese umbral no se identifica un caso raro, se identifica el conjunto. No hay
   resultados corregidos por outliers y conviene decirlo antes de que lo pregunte un revisor.
3. **La tabla de robustez del script tiene tres propiedades que hay que leer con cuidado**: su fila
   "primario" es del principal (N = 69, 23 participantes) porque `n_palabras` está vacía en el piloto; las
   columnas `p_tiempo`/`p_condicion` son el **coeficiente del primer contraste**, no la prueba ómnibus del
   factor; y las pruebas ómnibus están en `resumen_modelos_validos.csv` (por cohorte) y en
   `comparacion_*_ANOVA.csv` (conjunto). El informe combinado lo advierte en su sección 5.

---

## 5. Límites

1. **No es un experimento con asignación aleatoria documentada.** La condición es entre sujetos y no hay
   registro de cómo se asignó cada participante a Texto, Audio o Imagen, ni de la manipulación del orden de
   los estímulos. Sin eso, ninguna diferencia entre condiciones admite lectura causal.
2. **Son dos muestras distintas, no dos olas.** El piloto (17) y el principal (23) se capturaron en
   momentos diferentes y con instrumentos diferentes: `demora` y `n_palabras` existen **solo** en el
   principal. La columna `fuente` es lo único que permite separarlas, y las tablas conjuntas de 40 **no**
   están desagregadas.
3. **Los grupos son pequeños.** 6/6/5 en el piloto y 8/8/7 en el principal, con celdas de condición ×
   demora de 2 a 5 participantes. La ausencia de diferencias no es evidencia de ausencia de efecto, y la
   interacción triple no es estimable con estabilidad.
4. **Se miden productos, no actividad.** Como se dijo en §1: no hay registro del episodio mientras ocurre.
   El artículo propone precisamente lo contrario, y esa distancia debe estar declarada en el manuscrito.
5. **La lectura se apoya en medidas automáticas.** Emociones (léxico NRC-ES), diccionarios temáticos y
   embeddings no sustituyen la evaluación de jueces sobre los textos. El propio material de auditoría del
   proyecto describía la necesidad de valoración humana; aquí no se hizo.

---

## 6. Conclusiones (borrador)

1. **La tarea propuesta produce información utilizable.** Ocho bloques de análisis se ejecutan de forma
   reproducible sobre textos reales y devuelven, para cada segmento del episodio, medidas de extensión,
   estructura, contenido emocional, contenido temático y posición semántica. La propuesta del artículo es
   viable en términos de implementación.
2. **La extensión del episodio crece con la acumulación de contacto con el referente.** En el principal,
   T1 → T3 es un incremento robusto y de tamaño considerable (F(2, 40) = 25.50, p < 0.001), con las tres
   condiciones creciendo por igual. En los términos del artículo: el episodio se **extiende** al pasar del
   Segmento A al Segmento B, y lo hace sin que el modo de contacto marque la diferencia.
3. **No hay evidencia de que el modo reactivo module la extensión en la muestra principal.** La interacción
   condición × tiempo es prácticamente nula (F(4, 40) = 0.075, p = 0.989). La única señal en sentido
   contrario está en el piloto (escuchar crece más, p = 0.016) y **no replica** en el principal.
4. **Lo que no replica es la forma de la trayectoria, no el nivel.** La interacción `fuente:tiempo` es
   significativa (p = 0.002) mientras el efecto principal de cohorte no lo es (p = 0.939).
5. **La continuidad semántica entre segmentos es el resultado que mejor conversa con el marco.** El texto
   se parece más a su versión inmediatamente anterior (T2–T3 = 0.932) que al punto de partida (T1–T3 =
   0.839), consistente con la idea de segmentos encadenados de un mismo episodio.
6. **No hay desplazamiento semántico claro** hacia los constructos evaluados con prototipos: los cambios
   son pequeños y con dispersión mayor que su media.
7. **El cambio hay que leerlo dentro de cada persona.** Con R² condicional ≈ 0.79, la mayor parte de la
   varianza es individual; el diseño actual, con 17 y 23 participantes, tiene poca capacidad de aislar
   efectos de condición.
8. **Nada de esto autoriza a presentar n = 40 como una sola muestra ni a atribuir el cambio a la
   condición.** Es la conclusión más importante de este borrador y la que más fácilmente se pierde al
   redactar.

---

## 7. Lo que falta para cerrar el manuscrito

1. **Decidir el estado del piloto**: ¿validación metodológica previa, o parte del análisis principal? El
   resultado 2.3 (trayectorias distintas) obliga a elegir y justificarlo.
2. **Decidir el sentimiento global.** Las figuras 3, 8, 12 y 15 del pipeline piden una medida `bing_*` que
   **nunca se calculó**; hoy usan `sadness` como duplicado declarado. Si el manuscrito quiere un
   sentimiento global, hay que decidir qué léxico lo produce y volver a correr.
3. **Desagregar por cohorte** las tablas semánticas, de prototipos y de diccionarios, hoy solo de n = 40.
4. **Intervalos de confianza** del efecto de tiempo en escala cruda y logarítmica (bootstrap), que la tabla
   de robustez no trae (sus columnas de IC están vacías).
5. **Revisar el criterio de outliers** antes de reportarlo: con |residuo| > 2.5 se marcan 115 de 120
   observaciones; conviene un criterio que discrimine (p. ej. distancia de Cook o influencia por
   participante) o declarar que no se hizo.
6. **Valoración humana de los textos** (jueces), si el manuscrito va a hablar de contenido y no solo de
   extensión y posición semántica.
7. **El experimento tal como lo propone el artículo**: registro *durante* el episodio (alternación
   concurrente), que es lo que permitiría hablar de alternación y no solo de segmentación.

---

## 8. Referencia del artículo enmarcante

López Corral, A., Rey Murrieta, P., Acuña Meléndrez, K., & Jiménez, M. Y. (2024). ¿Qué sucede al escribir?
Interrelación de modos lingüísticos como propuesta metodológica para el estudio de la escritura.
*Revista Mexicana de Análisis de la Conducta*, *50*(2), 185–207. https://doi.org/10.5514/rmac.v50.i2.90353

*(Los autores figuran en el orden y con la afiliación del encabezado del artículo: Universidad de Sonora,
Laboratorio de Ciencia y Comportamiento Humano. Las obras que el artículo cita —Fuentes & Ribes, 2001;
López et al., 2019, 2020, 2022; Pacheco et al., 2007, entre otras— se mencionan en este borrador **como
citadas en el artículo**, no como fuentes verificadas aquí.)*
