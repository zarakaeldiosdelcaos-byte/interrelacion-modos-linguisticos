# Integridad y trazabilidad

Este repositorio distingue **tres conjuntos de hashes**, y cada uno responde a una pregunta
distinta. No mezclarlos es la diferencia entre "estos son los bytes que analicé" y "esto es lo que
había en una carpeta".

---

## 1. Los artefactos de este repositorio

`manifests/SHA256_REPO.txt` — un `sha256sum` de todos los archivos versionados, con rutas
relativas a la raíz del repositorio.

```bash
bash tests/check_hashes.sh                      # verifica el manifiesto del repositorio
sha256sum -c manifests/SHA256_REPO.txt          # equivalente, directo
```

Cómo se regenera (solo si cambia el contenido, nunca a mano):

```bash
cd <raíz del repositorio>
git ls-files -z | xargs -0 sha256sum > manifests/SHA256_REPO.txt
```

`manifests/INVENTARIO_REPO.csv` — el inventario con tamaño y fecha por archivo, generado en el
mismo momento.

## 2. El árbol auditado (procedencia original)

Los manifiestos de la auditoría describen el árbol de trabajo del que se extrajo este paquete
(`Experimento Alfonso Lopez Corral`, 311 archivos, 175 únicos por hash). **No son verificables
desde el repositorio** porque apuntan a rutas del disco local; se conservan como procedencia.

| Archivo | Qué contiene |
|---|---|
| `manifests/SHA256_ARBOL_AUDITADO.txt` | Los 311 archivos del árbol con su hash |
| `manifests/INVENTARIO_COMPLETO_ARBOL_AUDITADO.csv` | Inventario con tamaño, fecha y extensión |
| `manifests/INDICE_DUPLICADOS.csv` | Los 103 grupos de archivos duplicados (≈40 MB redundantes) |
| `manifests/MANIFIESTO_SHA256_MATERIAL_PILOTO.{txt,csv}` | Los 60 archivos del material del piloto |
| `manifests/MANIFIESTO_SHA256_PAQUETE_COMPLETO.{txt,csv}` | El paquete completo de auditoría (73 archivos) |

## 3. Hashes de los artefactos citados en los documentos

| Artefacto | SHA-256 | Dónde vive |
|---|---|---|
| `Experimento ALC.R` (original auditado, **intacto**) | `a781da40333aa7c7ee0a401ea9ab404f57b0260e876e6555acfbd4c1088b5950` | árbol auditado, no en el repositorio |
| `Experimento ALC_v5_corregido.R` (reparado) | `0ddbe5cceb298e85456600d57541b9474f9ca55b89674e4bbbb704b9c6ee2bb1` | `code/01_pipeline_nlp.R` (mismos bytes) |
| Manuscrito `resultados.tex` / `resultados.pdf` | texto idéntico entre ambos (`fa7bea79…`) | árbol auditado |
| Narraciones del piloto (`embeddings_piloto_t1..t3.rds`) | 17 × 384, no vacíos | `data/processed/piloto/` |

## 4. Reglas de integridad

1. **Ningún microdato entra al control de versiones.** `tests/check_hashes.sh` lo verifica con
   `git ls-files`.
2. **Los manifiestos se regeneran con el comando de arriba**, nunca editando el archivo.
3. **Un artefacto vacío no se publica.** La auditoría encontró tres objetos del piloto guardados
   como `0 × 384` (prototipos, semántica, extracción): un archivo vacío publicado invita a citarlo.
4. **Los resultados publicados no se han re-ejecutado en este empaquetado.** Son los de la corrida
   auditada; el código sí se ha verificado sintácticamente (`parse()`), no ejecutado de punta a punta.
