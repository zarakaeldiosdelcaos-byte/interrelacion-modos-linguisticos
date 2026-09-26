# Resultados integrados en el repositorio

Origen: la corrida completa y verificada del pipeline v5.9 (hash `1143b36a…`), sobre textos de
participantes reales. Este documento declara **qué entró, qué no y por qué**.

## Política de admisibilidad

**Entra**: informes y documentos; figuras (todas, ES/EN, PNG y PDF); tablas **agregadas**
(por grupo, por modelo o por efecto); objetos de modelo **sin** sus slots de una fila por
participante (`datos`, `diagnosticos`), conservando modelo, ANOVA, R², medias marginales y
contrastes; centroides de prototipos; registros de ejecución; inventarios.

**No entra**: cualquier archivo que contenga texto escrito por participantes; cualquier tabla
con una fila por observación o por participante, aunque sea numérica; los insumos crudos
(`.xlsx`, léxico, volcados `.RData`); los árboles duplicados de copias; los residuos de sesión.

Cada archivo candidato pasó además por una comprobación de contenido: si algún campo de texto
supera los 200 caracteres, se rechaza. Los `.rds` de modelo pasan otra: se recorren y se cuenta
cualquier cadena de más de 120 caracteres, que debe ser 0.

## Integrado

140 archivos. Inventario con rutas, tamaños y SHA-256 en
`manifests/INVENTARIO_RESULTADOS.csv`.

## Documentos de resultados (manuscritos)

Los tres manuscritos de resultados viven junto a los resultados de su cohorte, con las figuras que
citan, de modo que cada carpeta es un paquete autocontenido:

| documento | ruta | páginas | figuras |
| --- | --- | --- | --- |
| Resultados del piloto (n = 17) | `results/piloto/manuscrito/` | 17 | 4 |
| Resultados del principal (n = 23) | `results/principal/manuscrito/` | 19 | 10 |
| Resultados del conjunto (17 + 23) | `results/combinado/manuscrito/` | 22 | 14 |

Los tres declaran en su propio texto: qué cohorte analizan, que el conjunto de 40 son **dos muestras
independientes** (no una muestra de 40), que las figuras rotuladas como sentimiento global usan
*tristeza* como duplicado declarado porque el pipeline nunca calculó una medida tipo Bing/VADER, y
que el criterio de casos influyentes es inoperante en el modelo del conjunto (115 de 120
observaciones marcadas). Contienen únicamente resultados agregados: ninguna celda con texto de
participantes, ninguna fila por participante.

## Excluido y por qué

| archivo (en la corrida) | motivo |
| --- | --- |
| `logs/ejecucion_v5_20260925_1910_v59_final.log` | 2 celdas con texto > 200 caracteres |
| `resultados/tablas/datos_completos_ancho.csv` | contiene las columnas texto_t1/t2/t3 (narrativas) |
| `resultados/tablas/datos_formato_largo.csv` | contiene la columna texto (narrativas) |

## No encontrados

- `modelo limpio: modelos_comparativos.rds`
- `modelo limpio: modelos_piloto.rds`
- `modelo limpio: modelos_principal.rds`
- `resultados/modelos/modelos_mixtos.rds`
