#!/usr/bin/env bash
# ============================================================================
#  checks de integridad del repositorio  (cuatro comprobaciones, una pasada)
#  uso:  bash tests/check_hashes.sh            → verifica manifests/SHA256_REPO.txt
#        bash tests/check_hashes.sh ruta.txt   → verifica otro manifiesto
# ============================================================================
set -u
cd "$(dirname "$0")/.." || exit 1          # raíz del repositorio
MANIFEST="${1:-manifests/SHA256_REPO.txt}"
fallos=0

PY=""
for c in python3 python py; do command -v "$c" >/dev/null 2>&1 && { PY="$c"; break; }; done

echo "== 1. ¿hay microdatos rastreados por git? (debe salir vacío) =="
if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  # nombres que delatan microdatos, y hojas de cálculo FUERA de results/ (dentro va la copia
  # agregada en Excel, que sí es admisible y además se inspecciona en el check 1b)
  sospechosos=$( { git ls-files | grep -Ei 'ancho_.*completo|_longitudinal\.csv|identificacion\.csv|scores_diccionarios|Vaciado|Datos Exp|datos_experimento|piloto_interrelacion|datos_completos_ancho|datos_formato_largo|\.RData' ; git ls-files | grep -Ei '\.(xlsx|xls)$' | grep -v '^results/' ; } || true)
  if [ -n "$sospechosos" ]; then
    echo "   ⚠ REVISAR: hay archivos que parecen microdatos:"
    echo "$sospechosos" | sed 's/^/     /'
    fallos=$((fallos+1))
  else
    echo "   OK: ningún microdato rastreado"
  fi
else
  echo "   (sin repositorio git; se omite)"
fi

echo
echo "== 1b. ¿algún CSV o .xlsx rastreado trae narrativa (celdas de más de 200 caracteres)? =="
if [ -n "$PY" ] && command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  "$PY" - <<'PYEOF'
import csv, re, zipfile, subprocess, sys
rastreados = subprocess.run(["git", "ls-files"], capture_output=True, text=True).stdout.split()
csvs  = [f for f in rastreados if f.lower().endswith((".csv", ".tsv"))]
xlsxs = [f for f in rastreados if f.lower().endswith((".xlsx", ".xlsm"))]
mal, n = [], 0

def largas_xlsx(f, umbral=200):
    """Cuenta cadenas largas dentro de un .xlsx (sharedStrings y cadenas en línea)."""
    try:
        z = zipfile.ZipFile(f)
    except Exception:
        return -1
    c = 0
    for parte in z.namelist():
        if not parte.endswith(".xml"):
            continue
        xml = z.read(parte).decode("utf-8", "replace")
        c += sum(1 for s in re.findall(r"<t[^>]*>(.*?)</t>", xml, re.S) if len(s) > umbral)
    return c

for f in csvs:
    n += 1
    try:
        with open(f, newline="", encoding="utf-8-sig", errors="replace") as fh:
            for row in csv.reader(fh):
                if any(len(c) > 200 for c in row):
                    mal.append(f); break
    except Exception as e:
        mal.append(f"{f} (no se pudo leer: {e})")

for f in xlsxs:
    n += 1
    c = largas_xlsx(f)
    if c != 0:
        mal.append(f"{f} ({c} cadenas largas)")

if mal:
    print("   ⚠ REVISAR: archivos con contenido de más de 200 caracteres (posible narrativa):")
    for f in mal: print("     ", f)
else:
    print(f"   OK: {n} archivos revisados ({len(csvs)} CSV, {len(xlsxs)} xlsx), ninguno con celdas largas")
sys.exit(1 if mal else 0)
PYEOF
  [ $? -ne 0 ] && fallos=$((fallos+1))
else
  echo "   (sin git o sin python; se omite)"
fi

echo
echo "== 2. ¿coinciden los artefactos con el manifiesto? ($MANIFEST) =="
if [ -f "$MANIFEST" ] && [ -n "$PY" ]; then
  "$PY" - "$MANIFEST" <<'PYEOF'
import hashlib, re, sys, os
BINARIAS = (".rds", ".png", ".pdf", ".jpg", ".jpeg", ".gif", ".xlsx", ".xls",
            ".zip", ".gz", ".rda", ".rdata")
man = sys.argv[1]
fallos, n = [], 0
for linea in open(man, encoding="utf-8", errors="replace"):
    linea = linea.rstrip("\r\n")
    if not linea.strip():
        continue
    m = re.match(r"^([0-9a-fA-F]{64})\s+\*?(.+)$", linea)
    if not m:
        fallos.append((linea[:70], "formato inesperado")); continue
    h, ruta = m.group(1).lower(), m.group(2)
    n += 1
    if not os.path.isfile(ruta):
        fallos.append((ruta, "no existe en el árbol")); continue
    datos = open(ruta, "rb").read()
    if not ruta.lower().endswith(BINARIAS):
        datos = datos.replace(b"\r\n", b"\n")   # huella independiente del sistema
    if hashlib.sha256(datos).hexdigest() != h:
        fallos.append((ruta, "hash distinto"))
if fallos:
    print(f"   ⚠ DISCREPANCIAS ({len(fallos)} de {n}):")
    for r, m in fallos[:20]:
        print("     ", r, "→", m)
    sys.exit(1)
print(f"   OK: {n} archivos verificados, 0 discrepancias")
PYEOF
  [ $? -ne 0 ] && fallos=$((fallos+1))
else
  echo "   ⚠ no existe $MANIFEST o no hay python en el PATH"
  fallos=$((fallos+1))
fi

echo "== 3. ¿todas las filas de los CSV tienen tantos campos como su encabezado? =="
if [ -n "$PY" ]; then
  "$PY" - <<'PYEOF'
import csv, glob, sys
mal = 0; n = 0
for f in sorted(glob.glob("results/**/*.csv", recursive=True)) + sorted(glob.glob("data_spec/*.csv")):
    n += 1
    try:
        with open(f, newline="", encoding="utf-8-sig") as fh:
            rows = list(csv.reader(fh))
    except Exception as e:
        print("   ⚠ no se pudo leer", f, e); mal += 1; continue
    if not rows:
        print("   ⚠ vacío:", f); mal += 1; continue
    ancho = len(rows[0])
    desc = [i for i, r in enumerate(rows[1:], 2) if len(r) != ancho]
    if desc:
        print("   ⚠ REVISAR", f, "filas con distinto nº de campos:", desc[:5]); mal += 1
print(f"   {'OK' if mal == 0 else 'CON PROBLEMAS'}: {n} CSV revisados, {mal} con problemas")
sys.exit(1 if mal else 0)
PYEOF
  [ $? -ne 0 ] && fallos=$((fallos+1))
else
  echo "   (sin python en el PATH; se omite)"
fi

echo
echo "== 4. ¿están los cuatro informes y las figuras donde dice el inventario? =="
esperados="results/piloto/INFORME_PILOTO.md results/principal/INFORME_PRINCIPAL.md results/combinado/INFORME_COMBINADO.md results/combinado/BORRADOR_DISCUSION_Y_CONCLUSIONES.md docs/resultados_integrados.md manifests/INVENTARIO_RESULTADOS.csv results/piloto/manuscrito/resultados_piloto.pdf results/principal/manuscrito/resultados_principal.pdf results/combinado/manuscrito/resultados_combinado.pdf results/piloto/manuscrito/resultados_piloto.tex results/principal/manuscrito/resultados_principal.tex results/combinado/manuscrito/resultados_combinado.tex"
faltan=""
for f in $esperados; do [ -f "$f" ] || faltan="$faltan $f"; done
n_fig=$(ls results/figuras/*.png 2>/dev/null | wc -l)
if [ -n "$faltan" ]; then
  echo "   ⚠ faltan:$faltan"; fallos=$((fallos+1))
else
  echo "   OK: los once documentos están presentes"
fi
echo "   figuras del pipeline en results/figuras/: $n_fig (esperadas 15)"
[ "$n_fig" -ge 15 ] || { echo "   ⚠ faltan figuras"; fallos=$((fallos+1)); }

echo
if [ "$fallos" -eq 0 ]; then
  echo "== RESULTADO: todo OK =="
else
  echo "== RESULTADO: $fallos comprobación(es) con problemas =="
fi
exit "$fallos"
