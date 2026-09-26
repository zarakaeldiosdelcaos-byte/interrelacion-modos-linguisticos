#!/usr/bin/env python3
"""Genera manifests/SHA256_REPO.txt a partir de los archivos versionados.

Regla de huella (idéntica a la que usa tests/check_hashes.sh):
  · archivos de texto  -> SHA-256 del contenido con los finales de línea
                          normalizados a LF (así la huella no depende de si el
                          sistema que hizo el checkout usa CRLF o LF).
  · archivos binarios  -> SHA-256 de los bytes tal cual.
El propio manifiesto se excluye (no puede contener su huella).
"""
import hashlib
import os
import subprocess

SALIDA = "manifests/SHA256_REPO.txt"
BINARIAS = (".rds", ".png", ".pdf", ".jpg", ".jpeg", ".gif", ".xlsx", ".xls",
            ".zip", ".gz", ".rda", ".rdata")


def huella(ruta):
    datos = open(ruta, "rb").read()
    if not ruta.lower().endswith(BINARIAS):
        datos = datos.replace(b"\r\n", b"\n")
    return hashlib.sha256(datos).hexdigest()


def main():
    archivos = subprocess.run(["git", "ls-files"], capture_output=True, text=True,
                              check=True).stdout.split("\n")
    rutas = sorted(f for f in archivos if f.strip() and f != SALIDA)
    lineas = []
    for r in rutas:
        if not os.path.isfile(r):
            print(f"   ⚠ no está en el árbol, se omite: {r}")
            continue
        lineas.append(f"{huella(r)} *{r}")
    with open(SALIDA, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lineas) + "\n")
    print(f"   manifiesto escrito: {len(lineas)} archivos -> {SALIDA}")


if __name__ == "__main__":
    main()
