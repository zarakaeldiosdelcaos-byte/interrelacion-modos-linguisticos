===============================================================
ANÁLISIS PILOTO — REPORTE DE EJECUCIÓN
===============================================================

Fecha: 2026-09-25 19:15:20 
Directorio: C:/Users/saraq/Downloads/Experimento Alfonso Lopez Corral/Analisis agosto v2 
Carpeta de resultados: C:/Users/saraq/Downloads/Experimento Alfonso Lopez Corral/Analisis agosto v2/piloto 

👥 Participantes piloto: 17 
👥 Participantes principal: 23 

📊 Variables aptas analizadas:
 n_palabras_calculado 

✅ MODELOS PILOTO VÁLIDOS:

VARIABLE: n_palabras_calculado 
Type III Analysis of Variance Table with Satterthwaite's method
                 Sum Sq Mean Sq NumDF DenDF F value Pr(>F)  
condicion          4435    2218     2    14    1.70  0.218  
tiempo             4811    2406     2    28    1.84  0.177  
condicion:tiempo  18995    4749     4    28    3.64  0.016 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
R² marginal: 0.2084  | condicional: 0.7996 

❌ MODELOS PILOTO EXCLUIDOS:
# A tibble: 0 × 3
# ℹ 3 variables: variable <chr>, estado <chr>, motivo <chr>

✅ MODELOS PRINCIPAL VÁLIDOS:

VARIABLE: n_palabras_calculado 
Type III Analysis of Variance Table with Satterthwaite's method
                 Sum Sq Mean Sq NumDF DenDF F value      Pr(>F)    
condicion          2135    1068     2    20    0.60        0.56    
tiempo            91056   45528     2    40   25.50 0.000000072 ***
condicion:tiempo    535     134     4    40    0.07        0.99    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
R² marginal: 0.1972  | condicional: 0.7875 

❌ MODELOS PRINCIPAL EXCLUIDOS:
# A tibble: 0 × 3
# ℹ 3 variables: variable <chr>, estado <chr>, motivo <chr>


COMPARACIÓN PILOTO VS PRINCIPAL (interacción fuente:tiempo)
# A tibble: 1 × 7
  variable             efecto            F   df1   df2       p p_ajustada
  <chr>                <chr>         <dbl> <int> <dbl>   <dbl>      <dbl>
1 n_palabras_calculado fuente:tiempo  6.85     2  68.0 0.00195    0.00195
