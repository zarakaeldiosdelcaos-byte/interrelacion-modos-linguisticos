# Producción escrita y alternación de modos lingüísticos: resultados del estudio piloto

> **Nota de procedencia** (no forma parte del manuscrito). Todos los estadísticos provienen de la corrida
> completa y verificada del pipeline (`Experimento ALC_v5_corregido.R`, v5.9, SHA-256 `1143b36a…`).
> Las tablas de origen se identifican mediante rutas relativas al directorio de análisis `Analisis agosto v2/`:
>
> - `piloto/tablas/resumen_modelos_validos.csv` — ANOVA del modelo mixto
> - `piloto/tablas/piloto_n_palabras_calculado_EMM.csv` — medias marginales
> - `piloto/tablas/piloto_n_palabras_calculado_contrastes_{tiempo,cond}.csv` — contrastes Holm
> - `piloto/tablas/descriptivos_condicion_tiempo.csv` — medias y desviaciones
> - `resultados/tablas/datos_completos_ancho.csv` — filtrando `fuente == "piloto"` para TTR,
>   similitud semántica, prototipos y temas
>
> **La cohorte piloto (n = 17) es una muestra independiente de la principal (n = 23)**: no es una ola del
> mismo estudio. No hay datos de `demora` y la columna `n_palabras` está vacía en el archivo de captura
> (0 de 17), de modo que la variable dependiente es el conteo `n_palabras_calculado`.
> Versión LaTeX compilable: `resultados_piloto.tex` (14 páginas, compila sin errores ni citas sin resolver).

## 1. Resultados

### 1.1 Participantes y muestra analítica

El estudio piloto incluyó **17 participantes**, distribuidos en tres condiciones experimentales según el
modo reactivo habilitante: Texto (n = 6; modo leer), Audio (n = 6; modo escuchar) e Imagen (n = 5; modo
observar). Cada participante produjo tres textos sucesivos sobre el mismo referente: T1, línea base sin
estímulo; T2, tras un estímulo según la condición asignada; y T3, tras la acumulación de los tres
estímulos. El diseño produjo **51 observaciones** (17 × 3).

Dos características de esta cohorte condicionan todas las lecturas posteriores y se declaran desde el
inicio. Primero, el piloto es una **muestra independiente**, capturada en un momento distinto y con un
instrumento distinto del estudio principal (n = 23): no constituye una primera ola del mismo diseño.
Segundo, la columna `n_palabras` del archivo de captura está **vacía en la totalidad de los casos del
piloto** (0 de 17), de modo que la variable dependiente utilizada es el conteo verificado sobre el texto,
`n_palabras_calculado`. No se dispone de la variable `demora`, que solo existe en la cohorte principal; en
consecuencia, ningún resultado de este documento informa sobre el efecto de la demora.

### 1.2 Extensión del texto a través de las iteraciones

**Tabla 1.** Extensión del texto (`n_palabras_calculado`): media (DE) y mediana por condición y momento.
Estudio piloto, n = 17.

| Condición | Momento | n | M (DE) | Mediana |
|---|---|---|---|---|
| Texto | T1 | 6 | 143.67 (53.40) | 140.00 |
| Texto | T2 | 6 | 116.83 (60.65) | 95.50 |
| Texto | T3 | 6 | 116.50 (65.81) | 110.50 |
| Audio | T1 | 6 | 133.67 (62.04) | 116.50 |
| Audio | T2 | 6 | 172.17 (60.02) | 160.50 |
| Audio | T3 | 6 | 216.83 (114.97) | 171.00 |
| Imagen | T1 | 5 | 97.80 (77.35) | 90.00 |
| Imagen | T2 | 5 | 103.20 (80.35) | 80.00 |
| Imagen | T3 | 5 | 110.60 (47.28) | 86.00 |

*Nota*: las desviaciones estándar son del mismo orden que las medias en casi todas las celdas, con la
condición Imagen en T1 como caso extremo. La mediana se incluye porque las distribuciones son asimétricas.

**Tabla 2.** ANOVA de tipo III (Satterthwaite) del modelo mixto para `n_palabras_calculado`.
51 observaciones de 17 participantes.

| Efecto | F | gl num. | gl den. | p |
|---|---|---|---|---|
| Condición | 1.701 | 2 | 14 | .218 |
| Tiempo | 1.845 | 2 | 28 | .177 |
| Condición × tiempo | **3.642** | 4 | 28 | **.016** |

*Nota*: R² marginal = .208; R² condicional = .800. La interacción es el único efecto que alcanza el umbral
convencional.

El modelo explicó el **20.8 %** de la varianza atribuible a los efectos fijos (R² marginal) y el
**80.0 %** de la varianza explicada al incorporar el intercepto aleatorio (R² condicional). Es decir,
cuatro quintas partes de la variación en la extensión se deben a diferencias *entre* participantes, no a la
condición ni al momento del episodio.

A diferencia de lo que se observa en la cohorte principal, en el piloto **no hay un efecto principal de
tiempo**: la extensión no aumenta de manera general con la repetición (F(2, 28) = 1.845, p = .177). Lo que
sí aparece es una **interacción condición × tiempo** (F(4, 28) = 3.642, p = .016), es decir, la trayectoria
de la extensión depende del modo reactivo por el que se estableció el contacto con el referente. Las medias
marginales estimadas (Tabla 3) muestran que ese efecto procede de una sola condición.

**Tabla 3.** Medias marginales estimadas (EM), error estándar (SE) e IC del 95 %, por condición y momento.

| Condición | Momento | EM | SE | IC 95 % inf. | IC 95 % sup. |
|---|---|---|---|---|---|
| Texto | T1 | 143.67 | 29.30 | 82.52 | 204.82 |
| Texto | T2 | 116.83 | 29.30 | 55.68 | 178.00 |
| Texto | T3 | 116.50 | 29.30 | 55.35 | 177.65 |
| Audio | T1 | 133.67 | 29.30 | 72.52 | 194.82 |
| Audio | T2 | 172.17 | 29.30 | 111.02 | 233.32 |
| Audio | T3 | 216.83 | 29.30 | 155.68 | 278.00 |
| Imagen | T1 | 97.80 | 32.10 | 30.81 | 164.79 |
| Imagen | T2 | 103.20 | 32.10 | 36.21 | 170.19 |
| Imagen | T3 | 110.60 | 32.10 | 43.61 | 177.59 |

*Nota*: estimaciones obtenidas con `emmeans` sobre el modelo ajustado con `lmerTest` (gl ≈ 19.85). Los
intervalos son amplios: con 5 o 6 participantes por condición, el modelo no permite estimaciones precisas.

Los contrastes *a posteriori* con ajuste de Holm precisan el patrón. **Entre momentos dentro de cada
condición**, la condición Audio mostró un aumento significativo de T1 a T3 (Δ = −83.17 palabras, p = .001),
con los dos pasos parciales —T1 a T2 y T2 a T3— en el límite de la significación (Δ = −38.50 y −44.67,
ambos p = .082). En Texto y en Imagen ningún contraste alcanzó significación (Texto: T1–T2 p = .610,
T1–T3 p = .610, T2–T3 p = .987; Imagen: los tres p = 1.000); de hecho, la tendencia en Texto fue de
*disminución* de T1 a T2 y a T3. **Entre condiciones en cada momento**, no se observaron diferencias
significativas: en T1 y T2 todos los contrastes fueron claramente no significativos (p entre .385 y .912);
en T3, las comparaciones Audio–Texto (Δ = 106.23) y Audio–Imagen (Δ = 106.23) quedaron en p = .072.

En síntesis, la extensión del texto en el piloto se comporta de forma **heterogénea según el modo reactivo y
no de forma general**: la condición Audio es la única que muestra un crecimiento claro y sostenido a lo
largo de los tres momentos, mientras que Texto se mantiene o retrocede e Imagen permanece prácticamente
plana. Dado que el contraste directo Audio–Texto en T3 no alcanza significación y que el tamaño de cada
grupo es de 5 o 6 participantes, este patrón debe leerse como **exploratorio**: señala una dirección, no
establece una diferencia entre modos.

### 1.3 Diversidad léxica

El Type-Token Ratio (TTR) del piloto fue de M = 0.822 (DE = 0.090) en T1, M = 0.848 (DE = 0.084) en T2 y
M = 0.846 (DE = 0.092) en T3. Un modelo mixto con la misma especificación que el anterior no mostró efecto
de condición (F(2, 14) = 0.057, p = .944) ni efecto de tiempo (F(2, 28) = 2.079, p = .144), pero sí una
interacción condición × tiempo (F(4, 28) = 2.830, p = .043; R² marginal = .065, R² condicional = .805).

Dos lecturas conviene separar. Por un lado, la diversidad léxica del piloto **no disminuyó** a lo largo del
episodio: los textos de T2 y T3 no son léxicamente más pobres que los de T1, y la R² marginal es
prácticamente nula (.065). Por otro lado, la interacción reproduce en esta medida la misma forma que en la
extensión, lo que es coherente con que ambas respondan al mismo contraste, pero también advierte que el TTR
no es independiente de la condición analizada. Es necesario recordar que el TTR depende de la longitud del
texto, de modo que compararlo entre momentos con extensiones distintas exige cautela interpretativa.

### 1.4 Estabilidad semántica entre segmentos

La similitud coseno entre los vectores de los tres textos de cada participante (modelo
`paraphrase-multilingual-MiniLM-L12-v2`) fue mayor entre T2 y T3 (M = 0.937, DE = 0.100) que entre T1 y T2
(M = 0.843, DE = 0.198) y que entre T1 y T3 (M = 0.802, DE = 0.204). Un modelo mixto con el par de
comparación como único efecto fijo e intercepto aleatorio por participante mostró un efecto significativo
del par (F(2, 32) = 5.409, p = .0095).

El ordenamiento es el que cabría esperar si el episodio avanzara por aproximaciones sucesivas a un mismo
referente ya escrito: el cambio mayor ocurre entre el primer texto (sin contacto previo con el estímulo) y
el segundo, y el cambio menor entre el segundo y el tercero. Los valores absolutos deben leerse con
reserva: la similitud media de T1–T2 incluye casos con valores tan bajos como 0.34, y esta variabilidad
individual —no la media— es la que explica que el efecto del par sea moderado.

### 1.5 Contenido temático y prototipos (análisis exploratorio)

**Tabla 4.** Tasas por 1000 palabras de los diccionarios temáticos, por momento del episodio (n = 17).

| Tema | T1 | T2 | T3 |
|---|---|---|---|
| Soledad | 28.98 | 27.95 | 27.20 |
| Espacio | 26.66 | 22.05 | 22.04 |
| Objetos | 21.31 | 20.39 | 25.66 |
| Emociones negativas | 2.56 | 5.90 | 5.04 |
| Luz y sombra | 4.03 | 1.66 | 1.17 |
| Pasividad | 4.02 | 2.19 | 3.30 |
| Duda | 1.62 | 2.32 | 2.85 |
| Espera | 1.54 | 0.98 | 1.26 |
| Incomunicación | 0.00 | 0.51 | 0.48 |
| Desconexión | 0.00 | 0.00 | 0.00 |

*Nota*: las desviaciones estándar (no mostradas por brevedad) son del mismo orden o mayores que las medias
en prácticamente todos los temas. Dos temas del diccionario —incomunicación y desconexión— prácticamente no
aparecen en el corpus del piloto; en el caso de desconexión la tasa es exactamente cero en los tres
momentos, lo que indica que los términos elegidos no están representados en estos textos.

Los cambios de proximidad a prototipos entre T1 y T3 fueron pequeños en todos los casos. Los mayores fueron
tristeza (Δ = +0.048, DE = 0.082), emociones negativas (Δ = +0.045, DE = 0.092) y ansiedad/malestar
(Δ = +0.035, DE = 0.090); los restantes constructos quedaron por debajo de |0.021|. En todos ellos la
desviación estándar es mayor que la media y la mediana es de magnitud inferior, indicio de que unos pocos
participantes concentran el cambio. Estos análisis no fueron sometidos a corrección por comparaciones
múltiples —son 20 constructos y 10 temas— ni a prueba inferencial, por lo que se reportan como
*exploratorios*.

A modo de referencia descriptiva, y sin valor inferencial por el tamaño de los grupos, la distancia
euclidiana entre T1 y T3 en el espacio reducido por componentes principales fue M = 2.30 (DE = 2.87) en
Audio, M = 5.21 (DE = 4.22) en Texto y M = 8.26 (DE = 3.81) en Imagen. Ese espacio se ajustó sobre los 120
vectores del conjunto completo (piloto y principal), de modo que las distancias del piloto no son
independientes de esa solución.

---

### 1.6 Figuras

Las cuatro figuras provienen de la corrida completa del pipeline y emplean `n_palabras_calculado`,
la variable dependiente de esta cohorte. Los archivos están en la carpeta `figuras/`, junto a este
documento.

**Figura 1 — Trayectorias de la extensión por condición**
(`figuras/PILOTO_n_palabras_calculado_ES_trayectoria.pdf`). Cada línea es la media marginal estimada
del modelo mixto con su intervalo de confianza del 95 %. Las tres condiciones parten de niveles
distintos y solo Audio asciende de forma sostenida (de 133.67 a 216.83 palabras); Texto desciende
entre T1 y T2 y se mantiene después; Imagen es prácticamente plana (de 97.80 a 110.60). La
divergencia entre las tres líneas es la representación gráfica de la interacción condición × tiempo
(F(4, 28) = 3.642, p = .016), el único efecto significativo del modelo. La amplitud de las bandas
refleja la base de 5 o 6 participantes por condición y es la razón por la que el patrón se reporta
como exploratorio.

**Figura 2 — Trayectorias individuales** (`figuras/PILOTO_n_palabras_calculado_ES_individuales.pdf`).
Una línea por participante, superpuestas a la tendencia grupal de cada condición. La figura muestra
la heterogeneidad que sostiene la diferencia entre la varianza explicada marginal (R² = .208) y la
condicional (R² = .800): varias trayectorias se cruzan y hay participantes que triplican su punto de
partida mientras otros lo reducen. Es la representación que advierte contra leer las medias de la
Figura 1 como el comportamiento de un escritor típico.

**Figura 3 — Distribución por condición y momento**
(`figuras/PILOTO_n_palabras_calculado_ES_distribucion.pdf`). Diagramas de caja con las observaciones
individuales superpuestas. La caja de Audio en T3 es la más dispersa (DE = 114.97, frente a 47–81 en
el resto de las celdas) y contiene el texto más extenso del piloto, de 378 palabras; las cajas de
Imagen son las más compactas. Esa dispersión es la que sostiene el contraste T1–T3 de la condición
Audio (Δ = −83.17, p = .001) y, al mismo tiempo, la que explica por qué ese contraste depende de
pocos casos.

**Figura 4 — Diagnóstico del modelo** (`figuras/piloto_n_palabras_calculado_check_model.png`). Panel
generado con el paquete `performance`: linealidad (residuos frente a valores ajustados), homogeneidad
de la varianza, observaciones influyentes, normalidad de los residuos y colinealidad. En esta cohorte
no se aprecian violaciones relevantes: la prueba de Shapiro-Wilk sobre los residuos da W = 0.9915
(p = .974) y los residuos escalados se mantienen entre −1.71 y 1.97, de modo que ninguna de las 51
observaciones supera el umbral |2.5| que el pipeline usa para identificar casos influyentes. El modelo
convergió sin singularidad. El contraste con el análisis del conjunto completo es instructivo: allí
ese mismo criterio marca 115 de 120 observaciones y el reajuste no pudo estimarse, mientras que aquí
no hay casos que excluir.

## 2. Discusión

### 2.1 Síntesis del patrón

El piloto ofrece un patrón que, en su forma, es el inverso del que se documenta en la cohorte principal y
que conviene enunciar con precisión antes de interpretarlo. Aquí la extensión del texto **no** aumenta de
manera general con la repetición (F(2, 28) = 1.845, p = .177), pero sí depende del modo reactivo asignado
(interacción F(4, 28) = 3.642, p = .016), porque la condición Audio crece de forma clara
(T1 → T3 = −83.17 palabras, p = .001) mientras Texto se mantiene o retrocede e Imagen permanece plana. La
diversidad léxica no cae. La similitud semántica se estabiliza en el segundo paso del episodio. Los cambios
de contenido temático y de proximidad a prototipos son pequeños y heterogéneos. Y aproximadamente cuatro
quintas partes de la varianza de la extensión corresponden a diferencias entre participantes
(R² condicional = .800).

### 2.2 Habilitación lingüística: ¿contacto con el referente o modo específico?

La distinción más productiva que el artículo ofrece para leer este patrón proviene de la literatura que el
propio artículo revisa. La definición operativa de habilitación lingüística allí recogida es la facilitación
de un desempeño en un modo activo *como resultado de la exposición a un modo reactivo*
(Camacho & Gómez, 2007; Gómez, 2005; Tamayo et al., 2010, citados en López Corral et al., 2024), esto es,
la manera en que leer, escuchar u observar afecta al escribir. Si la facilitación fuera un efecto general de
«tener algo que decir», bastaría con el contacto con el referente, cualquiera que fuese su modalidad; si
fuera específica del modo, cada condición debería producir un efecto distinguible.

El artículo es explícito en que el asunto no está resuelto y que la evidencia disponible apunta a algo más
amplio que el par complementario. Señala, en efecto, que en la habilitación lingüística de la escritura se
ha encontrado relación con los modos **escuchar** y **observar**, que *no* forman par con la escritura, y
concluye que la interrelación funcional de la escritura parece extenderse más allá de la lectura para
abarcar otros modos (López et al., 2019, 2020, citados en López Corral et al., 2024). El patrón del
piloto —donde la única condición que extiende el texto es precisamente la auditiva— es del tipo que esa
evidencia haría esperar, y no del tipo que predeciría una lectura estricta del par escribir–leer.

Ahora bien, tres razones impiden presentarlo como un hallazgo. Primera: los contrastes directos entre
condiciones en T3 quedaron en p = .072 (tanto Audio–Texto como Audio–Imagen), es decir, la diferencia que se
supone en el centro del argumento no alcanzó el umbral. Segunda: el efecto descansa en seis participantes;
con esa base, una única trayectoria atípica puede producir la interacción completa. Y tercera, y más
importante: el patrón no se replica en la cohorte principal, donde la interacción es prácticamente nula
(F(4, 40) = 0.075, p = .989) y el efecto que domina es el de tiempo general. La comparación formal entre
cohortes —interacción `fuente × tiempo`: F(2, 68) = 6.848, p = .002— confirma que las trayectorias difieren
significativamente entre el piloto y el principal, mientras que el nivel general de extensión no difiere
(`fuente`: p = .939).

La lectura defendible, entonces, es de **generación de hipótesis**: el piloto produce la hipótesis de una
habilitación específica por el modo escuchar, y no la evidencia de ella. Su valor está en que esa hipótesis
es formulable, medible y falsable —y en que la cohorte principal, que sí tiene un efecto general de tiempo,
no la confirma. Un diseño que quiera ponerla a prueba necesita asignación balanceada, un mínimo de
participantes por condición que permita sostener la interacción, y el contraste Audio–Texto declarado como
contraste principal antes de recoger los datos.

### 2.3 Segmentación del episodio y extensión del mismo

El artículo propone entender el episodio de escritura como una actividad extensible y segmentable, en la
que un primer segmento (Segmento A) corresponde al contacto con el referente y a la producción de un texto,
y un segundo segmento (Segmento B) a la interacción con el referente original y/o con su versión escrita
para modificarla, produciendo lo que denomina el *Referente AB* (López Corral et al., 2024). El diseño del
piloto implementa esa segmentación en dos cortes: T1 → T2 y T2 → T3.

Los contrastes de la condición Audio permiten describir el fenómeno con precisión: el cambio acumulado de
T1 a T3 es significativo (p = .001), pero ninguno de los dos pasos parciales lo es por separado (p = .082 en
ambos). No se trata, por tanto, de un salto asociado al primer contacto con el estímulo, sino de un
crecimiento **gradual a lo largo de los dos segmentos**, que solo se vuelve detectable al sumarse. En
Texto, en cambio, el segundo segmento no añade texto respecto al primero (p = .987), y la tendencia
descriptiva es de *retorno* al nivel inicial. Es decir, la segmentación del episodio se refleja en los
datos de manera desigual según el modo: en la condición auditiva el episodio se extiende a lo largo de sus
segmentos; en la de lectura, no.

Conviene subrayar una limitación conceptual de esta operacionalización. El artículo habla de la extensión
*del episodio*, esto es, de una actividad que se prolonga en el tiempo; lo que aquí se mide es el número de
palabras del producto de cada segmento. El conteo de palabras es un indicador indirecto de la extensión:
captura el rastro escrito de la actividad, no su duración ni su distribución temporal.

### 2.4 Conexión entre segmentos: del referente al texto ya escrito

El resultado semántico del piloto es, con diferencia, el más consistente y el que mejor conversa con el
marco. La similitud entre los dos últimos textos (M = 0.937) supera a la del primero con el segundo
(M = 0.843) y a la del primero con el tercero (M = 0.802), con un efecto significativo del par de
comparación (F(2, 32) = 5.409, p = .0095).

El artículo sostiene que, en el segundo segmento, el escritor puede interactuar con el referente original
y/o con su versión escrita, y que el producto resultante es una versión modificada de lo escrito previamente
*a propósito del referente original*. El ordenamiento observado es el que corresponde a ese encadenamiento:
el cambio semántico mayor ocurre en la transición que va del texto escrito sin contacto específico con el
referente (T1) a la primera versión anclada a él (T2); a partir de ahí, el escritor trabaja sobre lo ya
escrito, y por eso el segundo desplazamiento es el menor de los tres. Los datos del piloto son compatibles
con que el anclaje del episodio se desplace del referente al texto, que es la dirección que el artículo
describe con la noción de Referente AB.

La principal reserva es que la similitud coseno entre embeddings mide proximidad distribucional de
contenido, no identidad referencial: dos textos pueden parecerse mucho por estilo o por reiteración temática
sin que el segundo trate sobre la versión escrita del primero.

### 2.5 Imaginación y contenido

El artículo dedica un desarrollo específico a la imaginación: para imaginar es necesario haber observado,
escuchado o leído, y el uso imaginativo del conocimiento está condicionado por la forma y el modo de
contacto previo (Ryle, 2005, citado en López Corral et al., 2024). Es la razón teórica por la que T3
acumula los tres estímulos.

Los datos del piloto son demasiado tenues para sostener o rechazar esa expectativa. Los cambios de
proximidad a prototipos apuntan en una dirección reconocible —aumento de tristeza, emociones negativas y
ansiedad/malestar—, pero sus magnitudes son pequeñas (Δ entre +0.035 y +0.048), las desviaciones son
mayores que las medias y no se aplicó corrección por multiplicidad sobre 20 constructos. Lo mismo ocurre
con los temas: la tasa de emociones negativas se duplica descriptivamente de T1 a T2 y se mantiene en T3,
pero la dispersión es mayor que el efecto. Y hay un problema de operacionalización que conviene declarar:
los diccionarios de *desconexión* e *incomunicación* prácticamente no se activan en estos textos, con tasa
exactamente cero en el primero. Un instrumento que no registra variación no puede informar sobre el
constructo al que apunta.

### 2.6 Extensión, diversidad y profundidad: tres cosas distintas

Hay un resultado del piloto que merece consideración propia porque matiza una expectativa frecuente. En la
condición Audio, los textos crecieron de forma marcada (de ~134 a ~217 palabras), y sin embargo la
diversidad léxica no disminuyó: el TTR del piloto fue de 0.822 en T1, 0.848 en T2 y 0.846 en T3, sin efecto
de tiempo (p = .144) y con una R² marginal de apenas .065.

Esto tiene una consecuencia para el marco: **extender el episodio no es lo mismo que profundizarlo**. El
artículo caracteriza la escritura como una actividad que permite ordenar y revisar lo que se dice, darle
forma y estructura una y otra vez; si esa reelaboración tuviera como correlato necesario una mayor riqueza
léxica, debería observarse algún movimiento en el TTR. No se observa. Ello sugiere que el aumento de
extensión puede producirse por incorporación de contenido nuevo dentro de un repertorio léxico estable.
Conviene, en consecuencia, no tratar la extensión como un índice de complejidad.

### 2.7 Lo que este estudio piloto no permite sostener

**Tabla 5.** Afirmaciones no sostenibles y alternativas defendibles.

| Afirmación no sostenible | Formulación defendible |
|---|---|
| Escuchar habilita más que leer. | La condición Audio mostró el único crecimiento intragrupo significativo de T1 a T3 (p = .001), pero el contraste directo Audio–Texto en T3 no alcanzó significación (p = .072) y el grupo tenía 6 participantes. |
| La extensión del texto crece con la repetición. | En el piloto no hay efecto principal de tiempo (F(2, 28) = 1.845, p = .177); el crecimiento se concentra en una condición. |
| El piloto replica al estudio principal. | Las trayectorias difieren significativamente entre cohortes (`fuente × tiempo`: F(2, 68) = 6.848, p = .002). El nivel general, en cambio, no difiere (p = .939). |
| El episodio de escritura mejoró con la acumulación de estímulos. | Solo la condición Audio muestra extensión sostenida; Imagen permanece prácticamente plana y Texto vuelve a su nivel inicial. |
| El modo visual reorganiza más el contenido. | La distancia en el espacio PCA fue mayor en Imagen (M = 8.26) que en Audio (M = 2.30), pero es una descripción sobre 5 participantes, sin prueba, en un espacio ajustado sobre 120 vectores. |
| La escritura se volvió más compleja. | La diversidad léxica no cambió (p = .144); extensión y diversidad son dimensiones independientes en estos datos. |
| Los cambios en prototipos confirman la propuesta teórica. | Los cambios son pequeños, con dispersión mayor que la media, sin corrección por multiplicidad y sin prueba inferencial. |

### 2.8 Matriz teoría–evidencia

**Tabla 6.** Evaluación de las proposiciones del marco teórico con los datos del piloto.

| Proposición | Evaluación | Confianza |
|---|---|---|
| Los modos reactivos anteceden y retroalimentan al modo activo | Apoyo parcial (solo una condición) | Baja |
| La habilitación depende del modo reactivo y no solo del contacto con el referente | Compatible, no probada | Baja |
| El episodio de escritura es segmentable y extensible | Apoyo parcial (condición Audio) | Baja–moderada |
| Los segmentos se encadenan sobre la versión escrita del referente (Referente AB) | Apoyo parcial | Moderada |
| La imaginación se apoya en lo previamente observado, escuchado o leído | Evidencia insuficiente | Baja |
| El par escribir–leer produce efectos diferenciales | No respaldado en extensión | Baja |

*Nota*: ninguna proposición puede evaluarse con la potencia que exige una afirmación confirmatoria; los
niveles de confianza se refieren a lo que estos datos permiten decir, no a la plausibilidad de la propuesta
teórica.

### 2.9 Limitaciones

1. **Tamaño y balance de los grupos.** 17 participantes en tres condiciones (6, 6 y 5). La interacción
   significativa se apoya en el grupo de 6 participantes de Audio.
2. **Instrumento distinto del estudio principal.** Sin `demora` y con `n_palabras` vacía: la variable
   dependiente es un conteo derivado.
3. **Muestra independiente.** No es una primera ola del estudio principal; los contrastes entre cohortes
   informan sobre diferencias entre dos muestras.
4. **Medición del producto y no de la actividad.** No se registra la alternación de modos mientras se
   escribe, que es precisamente lo que el artículo propone medir.
5. **Múltiples comparaciones.** Los bloques de temas (10) y prototipos (20) no recibieron corrección ni
   prueba inferencial.
6. **Medidas automáticas sin validación humana.** No hubo jueces que valoraran los textos.
7. **Un solo modelo de embeddings**, y el espacio PCA ajustado sobre los 120 vectores del conjunto completo.
8. **Cautela sobre el TTR** por su dependencia de la longitud del texto.

### 2.10 Agenda derivada

1. Preregistrar el contraste modal principal (Audio–Texto) con un tamaño de muestra calculado.
2. Balancear condiciones y celdas, con la demora controlada.
3. Medir el episodio mientras ocurre (pausas, relecturas, verbalizaciones).
4. Validar el contenido con jueces humanos.
5. Depurar los instrumentos léxicos (desconexión e incomunicación no registran variación).
6. Comparar modelos de embeddings alternativos.

---

## 3. Conclusiones

1. En el estudio piloto **no se observó un efecto general de tiempo** sobre la extensión del texto
   (F(2, 28) = 1.845, p = .177).
2. Sí se observó una **interacción entre condición y tiempo** (F(4, 28) = 3.642, p = .016). La condición
   Audio es la única con un crecimiento claro de T1 a T3 (−83.17 palabras, p = .001); Imagen permanece
   prácticamente plana y Texto se mantiene o retrocede.
3. Dado que el contraste directo Audio–Texto en T3 no alcanzó significación (p = .072) y que los grupos son
   de 5 a 6 participantes, el patrón debe leerse como **exploratorio**: genera la hipótesis de una
   habilitación específica por el modo escuchar, no la establece.
4. La **estabilidad semántica** entre el segundo y el tercer texto (M = 0.937) fue mayor que entre el
   primero y el segundo (M = 0.843; F(2, 32) = 5.409, p = .0095), un ordenamiento compatible con que los
   segmentos del episodio se encadenen sobre la versión escrita del referente.
5. La **diversidad léxica no disminuyó** pese al aumento de extensión en la condición Audio (p = .144):
   extender el episodio y volverlo más diverso son cosas distintas.
6. Los cambios de **contenido** (temas y prototipos) son pequeños, con dispersión mayor que la media y sin
   corrección por multiplicidad; no sostienen ninguna afirmación sobre desplazamiento semántico.
7. Aproximadamente **cuatro quintas partes de la varianza** de la extensión corresponden a diferencias
   entre participantes (R² condicional = .800).
8. El patrón del piloto **no replica en la cohorte principal** (`fuente × tiempo`: F(2, 68) = 6.848,
   p = .002): las trayectorias difieren entre muestras aunque el nivel general no (p = .939). El piloto debe
   leerse como fase de generación de hipótesis.

---

## Referencias

Camacho, J., & Gómez, D. (2007). Variación de los modos de lenguaje en la adquisición y transferencia de
conocimiento. En J. Irigoyen, M. Jiménez & K. Acuña (Eds.), *Enseñanza, aprendizaje y evaluación. Una
aproximación a la pedagogía de las ciencias* (pp. 105-135). Universidad de Sonora.

Fuentes, M., & Ribes, E. (2001). Un análisis funcional de la comprensión lectora como interacción
conductual. *Revista Latina de Pensamiento y Lenguaje*, *9*(2), 181-212.

Gómez, A. (2005). *Transferencia entre modos del lenguaje y niveles de interacción: observar, escuchar,
hablar, leer y escribir* (Tesis doctoral). Universidad de Guadalajara.

López, A., Flores, C., & Torres, C. (2017). Análisis de la habilitación lingüística de la escritura. En
J. Irigoyen, K. Acuña & M. Jiménez (Coords.), *Aportes conceptuales y derivaciones tecnológicas en psicología
y educación* (pp. 259-280). Qartuppi. https://doi.org/10.29410/QTP.17.01

López, A., Acuña, K., Flores, C., & Irigoyen, J. (2019). Evaluación del modo lingüístico escribir con
posibilidad de revisión y corrección del texto. *Revista Iberoamericana de Psicología*, *12*(1), 61-76.
https://doi.org/10.33881/2027-1786.rip.12106

López, A., Acuña, K., Irigoyen, J., & Córdova, G. (2020). Habilitación lingüística y corrección de la
escritura con señalización de errores. *Journal of Behavior, Health & Social Issues*, *12*(1), 33-45.
https://doi.org/10.22201/fesi.20070780.2020.12.1.75672

López, A., Dávila, J., Ramírez, D., Jiménez, M., & Acuña, K. (2022). Análisis funcional de la escritura
como modo lingüístico. *Acta Comportamentalia*, *30*(2), 361-379. https://doi.org/10.32870/ac.v30i2.82679

López Corral, A., Rey Murrieta, P., Acuña Meléndrez, K., & Jiménez, M. Y. (2024). ¿Qué sucede al escribir?
Interrelación de modos lingüísticos como propuesta metodológica para el estudio de la escritura. *Revista
Mexicana de Análisis de la Conducta*, *50*(2), 185-207. https://doi.org/10.5514/rmac.v50.i2.90353

Ryle, G. (2005). *El concepto de lo mental*. Paidós.

*Las entradas de esta lista están transcritas de la lista de referencias del artículo de López Corral et al.
(2024), verificada en el PDF. No se añadió ninguna referencia que no figure allí.*
