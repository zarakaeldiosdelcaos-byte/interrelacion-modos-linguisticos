# Diccionarios y léxicos

Especificación de los recursos léxicos que usa el pipeline. **No contienen datos de personas.**

## 1. Léxico emocional NRC-ES

- Fuente: NRC Emotion Lexicon v0.92 de Saif M. Mohammad (traducciones al español).
- 8 emociones: 
  `joy` ·   `sadness` ·   `fear` ·   `anger` ·   `anticipation` ·   `trust` ·   `surprise` ·   `disgust`
- Archivo versionado: `data/raw/lexicons/nrc_es.rds` (30 661 bytes).
- Normalización de palabras: `tolower` → `iconv(to = "ASCII//TRANSLIT")` → solo `[a-z]`,
  la **misma** que usa `limpiar_texto()` sobre las narrativas. Sin esa coincidencia el
  conteo de emociones no es comparable entre el léxico y el corpus.
- Uso: `code/R/03_sentiment.R` (carga el léxico local; solo descarga si falta).

## 2. Diccionarios temáticos (estética de Hopper)

Diez temas, **190 términos semilla** en total. Provienen de `diccionarios_hopper_base` tal como está definido en el script del estudio.

### soledad (17 términos)

```text
solo, sola, soledad, solitario, solitaria, aislado, aislada, aislamiento, abandonado,
abandonada, unico, unica, sin compania, apartado, apartada, desvinculado, desvinculada
```

### espera (16 términos)

```text
espera, esperar, espero, esperaba, aguarda, aguardar, quietud, quieto, quieta, inmovilidad,
inmovil, paciencia, paciente, detenido, parado, parada
```

### incomunicacion (13 términos)

```text
silencio, silenciosa, silencioso, mudo, muda, callado, callada, calla, incomunicacion,
incomunicado, monologo, espaldas, sin voz
```

### objetos (23 términos)

```text
bolsa, maletin, sombrero, ropa, vestido, prenda, cama, habitacion, cuarto, hotel, piso, suelo,
equipaje, maleta, cartera, bolso, mueble, silla, ventana, cortina, puerta, mesilla, almohada
```

### emociones_negativas (31 términos)

```text
tristeza, triste, angustia, angustiado, angustiada, melancolia, melancolico, melancolica,
desolacion, desolado, desolada, dolor, doloroso, dolorosa, duele, pena, penoso, penosa,
desaliento, depresion, deprimido, deprimida, ansiedad, ansioso, ansiosa, inquietud, inquieto,
inquieta, infeliz, tormento, atormentado
```

### luz_sombra (19 términos)

```text
luz, luminoso, luminosa, iluminado, iluminada, sombra, sombras, sombrio, sombria, claro,
claridad, oscuro, oscuridad, oscura, penumbra, brillo, brillante, destello, radiante
```

### pasividad (21 términos)

```text
sentado, sentada, quieto, quieta, quietud, inmovil, inmovilidad, estatico, estatica, recostado,
recostada, acostado, acostada, tumbado, tumbada, reposa, reposaba, descansa, descansaba, yace,
yacia
```

### desconexion (17 términos)

```text
alejado, alejada, distancia, distante, lejos, lejano, lejana, separado, separada, desvinculado,
desvinculada, ignorado, ignorada, olvidado, olvidada, invisible, espaldas
```

### duda (17 términos)

```text
duda, dudaba, dudar, incierto, incierta, incertidumbre, interrogante, pregunta, indecision,
indeciso, indecisa, vacilacion, vacila, dilema, ambiguedad, ambiguo, ambigua
```

### espacio (16 términos)

```text
habitacion, cuarto, hotel, piso, pared, techo, suelo, ventana, puerta, interior, exterior,
frontera, limite, espacio, lugar, ambito
```

## 3. Enriquecimiento empírico (PMI) — advertencia metodológica

El script del estudio incluye un procedimiento de enriquecimiento (extrae candidatos por
frecuencia y PMI) y una lista de términos aceptados. Esa lista está **declarada en el propio
código como simulada** ('Selección manual (simulada con un vector de aceptados)') y contiene
palabras que el léxico NRC normalizado no puede contener tal cual (por ejemplo `vacío`,
`desolación`, `claro-oscuro`). Consecuencia:

> Los resultados que dependan del diccionario **enriquecido** no son reproducibles como
> decisión editorial; los que dependan del diccionario **base** sí.

Los diccionarios de este directorio son los **base**. Cualquier tabla del repositorio que use
términos añadidos debe declararlo.
