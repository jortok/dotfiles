#!/bin/bash

# ==============================================================================
# Gallery Tool v5.0
#
# Novedades:
# - Renombrado numérico de archivos para ordenamiento natural consistente.
# - Generación de un archivo .zip para descarga completa.
# - El script de visualización ahora es sensible a la existencia del .zip.
# ==============================================================================

set -euo pipefail
readonly VERSION="5.0"

readonly GALLERY_TOOL_ROOT="${GALLERY_TOOL_ROOT:-/home/toku/gal}"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Export SCRIPT_DIR para que sea accesible en funciones hijas
export SCRIPT_DIR

source "$SCRIPT_DIR/gallery-functions.sh"

function generar_ruta_desde_url() {
    local url="$1"
    echo "$url" |
      sed -E 's#^https?://##' |
      sed -E 's#/[^/]+\.[^/.]+$##' |
      sed 's#/$##' |
      sed 's|[^a-zA-Z0-9._/-]|-|g'
}

mostrar_ayuda() {
    cat << EOF
🚀 Gallery Tool v${VERSION} - Extractor y Visualizador de Multimedia Web
Uso: $0 [OPCIONES] <URL>

Extrae todas las imágenes y videos de una página web y las muestra en una galería local.
Las galerías se guardan en directorios predecibles dentro de '$GALLERY_TOOL_ROOT'.

OPCIONES:
  --js                Forzar el uso de un navegador headless (JavaScript) para la extracción.
  --nsxiv             Abrir las imágenes descargadas con el visor de imágenes 'nsxiv'.
  -h, --help          Muestra este menú de ayuda y sale.
EOF
}

main() {
    local modo_vista="html"
    local modo_extraccion="curl"
    
    # ... (procesamiento de opciones sin cambios)
    for arg in "$@"; do shift; case "$arg" in "--js") set -- "$@" "-j" ;; "--nsxiv") set -- "$@" "-n" ;; "--help") set -- "$@" "-h" ;; *) set -- "$@" "$arg"; esac; done
    while getopts "jnh" opt; do case $opt in j) modo_extraccion="js" ;; n) modo_vista="nsxiv" ;; h) mostrar_ayuda; exit 0 ;; \?) log ERROR "Opción inválida." >&2; mostrar_ayuda; exit 1 ;; esac; done
    shift "$((OPTIND -1))"
    local url="${1:-}"; if [[ -z "$url" ]]; then log ERROR "No se proporcionó URL."; exit 1; fi

    log INFO "🚀 Ejecutando Gallery Tool v${VERSION}"

    local regla_cerebro="$SCRIPT_DIR/reglas/generic.sh"
    log INFO "🧠 Cargando cerebro de extracción: $regla_cerebro"
    source "$regla_cerebro"

    verificar_dependencias "curl" "wget" "pup" "sed" "numfmt" "zip"

    local ruta_relativa; ruta_relativa=$(generar_ruta_desde_url "$url")
    local DIR_GALERIA="$GALLERY_TOOL_ROOT/gallery-tool/$ruta_relativa"
    
    log INFO "📁 Directorio de la galería: $DIR_GALERIA"
    
    if [ -f "$DIR_GALERIA/.complete" ]; then
        log INFO "✨ Directorio y marcador .complete encontrados. Mostrando galería desde caché."
        abrir_visualizador "$modo_vista" "$DIR_GALERIA"
        log INFO "✅ Proceso finalizado."
        wait ${VIEWER_PID:-0} 2>/dev/null || true
        exit 0
    fi
    
    log INFO "Directorio no encontrado o incompleto, iniciando proceso de descarga..."
    mkdir -p "$DIR_GALERIA"
    echo "$url" > "$DIR_GALERIA/.source_url"
    
    local DIR_TRABAJO="$DIR_GALERIA/_work"
    mkdir -p "$DIR_TRABAJO"
    local raw_urls_file="$DIR_TRABAJO/raw_urls.txt"
    local processed_urls_file="$DIR_TRABAJO/processed_urls.txt"
    local final_urls_file="$DIR_TRABAJO/final_urls.txt"
    
    log INFO "📡 Fase 1: Extrayendo URLs..."
    extraer_urls_con_regla "$url" "$raw_urls_file" "$modo_extraccion"

    if [ ! -s "$raw_urls_file" ]; then
        log ERROR "No se encontraron URLs multimedia en la página."
        rm -rf "$DIR_GALERIA"; exit 1
    fi
    
    log INFO "🔧 Fase 2: Normalizando URLs..."
    procesar_urls "$raw_urls_file" "$processed_urls_file" "$url"
    
    log INFO "💎 Fase 3: Deduplicando y optimizando..."
    deduplicar_y_optimizar "$processed_urls_file" "$final_urls_file"

    log INFO "⬇️ Fase 4: Descargando..."
    descargar_multimedia "$final_urls_file" "$DIR_GALERIA" 12

    log INFO "🧹 Fase 4.5: Limpieza Post-Descarga..."
    limpiar_multimedia_descargada "$DIR_GALERIA"

    # --- NUEVAS FASES ---
    log INFO "🔢 Fase 4.6: Renombrando archivos..."
    renombrar_para_ordenar "$DIR_GALERIA"

    log INFO "📦 Fase 4.7: Creando archivo ZIP..."
    crear_archivo_zip "$DIR_GALERIA"
    
    rm -rf "$DIR_TRABAJO"

    local archivos_restantes
    archivos_restantes=$(find "$DIR_GALERIA" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp -o -iname \*.mp4 -o -iname \*.webm \) | wc -l)
    if [ "$archivos_restantes" -eq 0 ]; then
        log WARN "No quedaron archivos multimedia válidos después de la limpieza."; exit 0
    fi

    log INFO "🎨 Fase 5: Generando y Visualizando..."
    abrir_visualizador "$modo_vista" "$DIR_GALERIA"
    
    touch "$DIR_GALERIA/.complete"
    
    log INFO "✅ Proceso finalizado. Galería guardada en: $DIR_GALERIA"
    wait ${VIEWER_PID:-0} 2>/dev/null || true
}

main "$@"
