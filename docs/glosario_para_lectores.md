# GUÍA DE RESULTADOS DEL ESTUDIO PILOTO — EXPLICADA SIN JERGA

Para: quien pidió el estudio (perfil no técnico en NLP).
De: auditoría del material del piloto, 2026-09-23.
Regla de esta guía: **todo número aquí está copiado de un archivo que existe** y se indica cuál.
Nada de esta guía es una interpretación nueva: donde hay interpretación, va marcada como tal.

---

## 1. Resumen en una página

**Qué se hizo.** 17 personas escribieron un texto sobre una escena (una persona sola en una habitación)
en tres momentos:

| Momento | Qué recibían antes de escribir |
| --- | --- |
| **T1** | nada (escritura libre) |
| **T2** | un estímulo |
| **T3** | los tres estímulos (texto, audio e imagen) |

Cada persona pertenecía a un grupo desde el principio: **Texto (6 personas), Audio (6), Imagen (5)**.

**Qué se midió.** Principalmente **cuántas palabras** escribieron en cada momento
(`n_palabras_calculado`). Se calcularon también otras cosas (variedad de vocabulario, parecido de
significado entre los textos, temas), pero **para el piloto no quedaron resultados**: los archivos que
las contenían están vacíos (ver §5).

**Qué salió.**

| Grupo | Palabras en T1 | Palabras en T3 | Cambio |
| --- | --- | --- | --- |
| Texto | 144 | 117 | **bajó 27** |
| Audio | 134 | 217 | **subió 83** |
| Imagen | 98 | 111 | subió 13 |

- Ni "el grupo" ni "el paso del tiempo" explican las diferencias por sí solos (p = 0,22 y p = 0,18:
  no significativos).
- Lo que sí aparece es la **combinación** de grupo y tiempo (p = 0,016): **el crecimiento se concentra en
  el grupo Audio**.
- Con la corrección por comparaciones múltiples (Holm), el único contraste que se mantiene es
  **Audio de T1 a T3: −83 palabras, p = 0,0013**. Los demás quedan en "tendencia" o en nada.

**La frase que hay que decir y la que no.**

- ✅ "En el piloto, el aumento de palabras en el tiempo se concentra en el grupo Audio; el único cambio
  que sobrevive la corrección estadística es el de Audio entre T1 y T3."
- ❌ "Escuchar audio mejora la escritura." Con 6 personas en ese grupo y un solo contraste significativo
  de nueve, eso no se puede afirmar.
- ❌ "Se encontró un cambio en el vocabulario / en las emociones / en el significado." Del piloto **no
  hay** resultados de eso.

---

## 2. Cómo leer las cuatro palabras que aparecen en los archivos

### "n_palabras_calculado"

Es el conteo de palabras de un texto, contado por el programa (no por Excel). Se llama "calculado"
justamente para distinguirlo de una columna de conteo que venía en el Excel y estaba **vacía** para el
piloto. Cuando en esta guía leas "palabras", es este número.

### "Embedding" (o "vector", 384 dimensiones)

Un embedding es una **huella numérica del significado** de un texto: el programa convierte el texto en
una lista de 384 números, de manera que **dos textos que significan cosas parecidas producen listas
parecidas**. Es como darle a cada texto un código de barras que depende de lo que dice, no de cómo se ve.
Analogía: dos canciones distintas del mismo género quedan "cerca" en un mapa de gustos; dos textos que
hablan de lo mismo quedan cerca en el mapa de significados.

- **Similitud (coseno):** número de 0 a 1 que dice qué tan cerca están dos textos. 1 = prácticamente lo
  mismo; valores bajo 0,5 = textos que ya hablan de cosas distintas.
- **Distancia euclidiana:** lo mismo que la similitud pero al revés: 0 = idénticos, números grandes =
  textos que se alejaron.

### "Prototipo semántico"

Se tomaron 20 conceptos (soledad, espera, tristeza, esperanza, miedo…) y se escribieron **5 frases típicas
de cada uno**. Con esas frases se construye un "imán" o punto de referencia por concepto. Después se mide
qué tan cerca queda cada narrativa de cada imán. Es una forma de preguntar "¿de qué habla este texto?"
usando números.

**Importante para el piloto:** este cálculo **no llegó a producir resultados** (los archivos quedaron
vacíos, §5). Los resultados de prototipos que existen son del **conjunto combinado de 40 personas**, no
del piloto. **Sin embargo se va a verificar que paso con este procedimiento y volver a correr para obtener resultados.**

### "Modelo mixto"

Es la forma correcta de analizar este diseño: las mismas personas escriben tres veces, así que sus tres
textos no son independientes entre sí. El modelo mixto separa **las diferencias entre personas** (cuánto
escribe cada quien por carácter) de **lo que cambia con la condición y el tiempo** (lo experimental).
De ahí salen dos números que verás en las tablas:

- **R² marginal** (0,21 en el piloto): cuánto de la variación explican la condición y el tiempo.
- **R² condicional** (0,80 en el piloto): cuánto explican condición, tiempo **y** las diferencias entre
  personas. Que sea 0,80 y el marginal 0,21 significa: **la mayor parte de la variación es "de quién
  escribe", no del experimento.**

### "p" y "corrección de Holm"

La p mide la probabilidad de ver una diferencia así si en realidad no hubiera ninguna. Por convención,
p < 0,05 = "difícil de explicar por azar". Como se hacen **muchas comparaciones a la vez** (9 contrastes),
la probabilidad de que alguna salga "significativa" por casualidad sube; la corrección de Holm sube el
listón para compensarlo. Un contraste puede tener p = 0,002 sin corregir y 0,082 corregido: eso es
"tendencia", no resultado.

---

## 3. Los resultados del piloto, uno por uno

Archivo fuente: `03_resultados/tablas_piloto/` y `03_resultados/tablas_comparativas/`.

### 3.1 ¿Los grupos escribieron distinto? — No concluyente

`condicion`: F(2;14) = 1,70 · **p = 0,218** · R² marginal 0,21.
Los tres grupos escribieron entre 98 y 144 palabras de media en T1, pero con este número de personas la
diferencia no se puede distinguir del azar.

### 3.2 ¿Se escribió más con el tiempo? — No concluyente en el piloto

`tiempo`: F(2;28) = 1,84 · **p = 0,177**.
Mirando la tabla del §1 parecería que sí (Audio sube 83 palabras), pero el efecto global no alcanza
significancia: el crecimiento de Audio queda compensado por la bajada de Texto y el estancamiento de Imagen.

### 3.3 ¿Importa a qué grupo perteneces para cómo creces en el tiempo? — Sí, y esto es lo central

`condicion:tiempo`: F(4;28) = **3,64** · **p = 0,016**.
Traducción: **el patrón de cambio a lo largo de T1→T2→T3 no es el mismo en los tres grupos.** Es la única
señal del piloto que supera el umbral sin corrección, y se mantiene al corregir por haber comparado
piloto y principal (`p ajustada = 0,00195` para `fuente:tiempo`).

### 3.4 ¿Cuál comparación concreta sostiene esa señal? — Solo una

`piloto_n_palabras_calculado_contrastes_tiempo.csv` (p con corrección Holm):

| Comparación dentro del grupo | Diferencia (palabras) | p corregida |
| --- | --- | --- |
| **Audio: T1 → T3** | **−83,2** | **0,0013** ✅ |
| Audio: T1 → T2 | −38,5 | 0,082 |
| Audio: T2 → T3 | −44,7 | 0,082 |
| Texto: T1 → T2 / T1 → T3 / T2 → T3 | +26,8 / +27,2 / +0,3 | 0,61 / 0,61 / 0,99 |
| Imagen: los tres | −5,4 / −12,8 / −7,4 | 1,00 / 1,00 / 1,00 |

**Lectura correcta:** de las nueve comparaciones hechas, una sobrevive. El grupo Audio es el único que
muestra un crecimiento claro, y ese crecimiento ocurre de T1 a T3 (con los tres estímulos juntos), no de
manera limpia paso a paso.

### 3.5 ¿El piloto predice lo que pasará con el estudio grande? — No

Este es el hallazgo más importante para no cometer un error de interpretación:

| Efecto | Piloto (17 personas) | Estudio principal (23 personas) |
| --- | --- | --- |
| Grupo | p = 0,218 | p = 0,559 |
| Tiempo | p = 0,177 | **p = 0,000000072** ✅ |
| Grupo × Tiempo | **p = 0,016** ✅ | p = 0,989 |

En el **piloto** lo que llama la atención es la interacción (solo Audio crece).
En el **principal** lo que llama la atención es el tiempo (todos crecen mucho) **y la interacción
desaparece por completo** (p = 0,989).

Comparación formal de los dos conjuntos (`comparacion_n_palabras_calculado_ANOVA.csv`):
el nivel general de palabras no difiere entre cohortes (**fuente**: p = 0,94), pero **la forma del cambio
en el tiempo sí difiere** (**fuente × tiempo**: F = 6,85 · p = 0,002).

> Cómo decirlo sin exagerar: "el piloto y el estudio principal no cuentan la misma historia sobre el
> papel de la condición; la diferencia entre ambos conjuntos es detectable estadísticamente, pero son
> **muestras distintas de personas** (17 y 23, con 5 a 8 personas por celda), así que esto se reporta
> como exploratorio, no como un hallazgo confirmatorio."

### 3.6 Calidad del ajuste del modelo del piloto

`03_resultados/diagnosticos/` contiene, para las 51 narrativas, el valor observado, el ajustado por el
modelo y el residuo (la diferencia). `piloto_n_palabras_calculado_performance.txt` (71 KB) guarda la
salida de rendimiento del ajuste. Traducción práctica: **el modelo funciona como descripción de estos 17
casos, no como predicción de casos nuevos.**

---

## 4. Estado de las bases de datos (para saber de dónde sale cada número)

| Base | Qué es | Filas |
| --- | --- | --- |
| `01_datos_crudos/Vaciado Datos piloto Interrelación.xlsx` | El vaciado original, tal como se transcribió (con celdas combinadas y encabezado en la fila 4). | 17 personas × 3 textos |
| `01_datos_crudos/piloto_interrelacion_formato_largo.xlsx` | La misma información **ordenada**, con su propio diccionario de columnas. Es la base buena. | 51 |
| `02_datos_procesados/datos/ancho_piloto_completo.csv` | Una fila por persona, con sus tres textos y sus tres conteos. | 17 |
| `02_datos_procesados/datos/embeddings_piloto_t1..t3.rds` | Las huellas numéricas de los textos (384 números por texto). **Sí existen y sirven.** | 17 × 384 |
| `02_datos_procesados/datos/piloto_longitudinal.csv` | Formato "largo": una fila por persona y momento. Es el que usan los modelos. | 51 |

Tres detalles que conviene saber, porque explican rarezas de los archivos:

1. **La columna "número de palabras" del Excel venía vacía** para el piloto (en el estudio principal sí
   estaba llena). Por eso el análisis usa el conteo hecho por el programa.
2. **Las 17 filas del piloto viajan etiquetadas como "principal_P1…principal_P17".** Los datos del piloto
   son correctos, pero su etiqueta se confunde con la del estudio principal (que también tiene un P1…P17).
   En la tabla combinada de 40 personas hay, por eso, **17 identificadores repetidos**. Antes de cruzar o
   publicar esas bases hay que renombrar los del piloto (por ejemplo `piloto_P1`).
3. **La hoja de demora está vacía en el piloto**: el piloto no tuvo esa manipulación, solo el principal.
4. **Cuidado con las cifras de reparto que circulan de memoria:** la cabecera del programa de análisis
   declara "Texto P1-P5, Audio P6-P11, Imagen P12-P17", y **eso no coincide con los datos**. El reparto
   real, verificable en el formato largo, es **Texto 6 / Audio 6 / Imagen 5**. Si en algún documento
   aparece "5/6/6", viene de la cabecera del programa, no de los datos.

---

## 6. Mini glosario

| Término | Qué significa en una frase |
| --- | --- |
| Narrativa | El texto que escribió una persona en uno de los tres momentos. |
| T1 / T2 / T3 | Los tres momentos de escritura (sin estímulo / un estímulo / tres estímulos). |
| Condición | El grupo al que pertenecía la persona: Texto, Audio o Imagen. |
| Outcome | Lo que se mide y se analiza; aquí, número de palabras. |
| EMM | Media estimada por el modelo para una casilla (grupo × momento), corregida por quién escribe. |
| Embedding | Lista de 384 números que representa el significado de un texto. |
| Prototipo | Punto de referencia construido con 5 frases típicas de un concepto. |
| PCA | Técnica para resumir muchas variables en dos ejes ("mapa comprimido") y ver si los grupos se separan. |
| TTR | Variedad de vocabulario: palabras distintas divididas entre palabras totales. |
| p corregida (Holm) | El valor de p después de subir el listón por haber hecho muchas comparaciones. |
| Piloto | Las 17 personas del primer grupo de prueba. |
| Principal | Las 23 personas del estudio completo. |
| Combinado | Las 40 personas juntas (17 + 23), base de las tablas de "resultados" generales. |
