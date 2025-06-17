#!/bin/bash
# ==============================================================================
# Gallery Tool v5.1
# Script principal blindado contra problemas de scope y con manejo de
# temporales mejorado.
# ==============================================================================

set -euo pipefail

# --- DEFINICIÓN DE CONSTANTES Y ENTORNO ---
readonly VERSION="5.1"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly GALLERY_TOOL_ROOT="${GALLERY_TOOL_ROOT:-/home/toku/gal}"
export SCRIPT_DIR

# --- INCLUSIÓN DE BIBLIOTECAS DE FUNCIONES ---
source "$SCRIPT_DIR/gallery-functions.sh"

# --- MANEJO DE DIRECTORIO TEMPORAL ---
# Se crea el directorio de trabajo globalmente y se asegura su limpieza.
# Esto resuelve el error "unbound variable" en el trap.
readonly DIR_TRABAJO=$(mktemp -d)
trap 'rm -rf "$DIR_TRABAJO"' EXIT

# --- FUNCIONES AUXILIARES DEL SCRIPT PRINCIPAL ---

generar_ruta_desde_url() {
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

Extrae imágenes y videos de una página web y las muestra en una galería local.
Las galerías se guardan en directorios predecibles dentro de '$GALLERY_TOOL_ROOT'.

OPCIONES:
  --js                Forzar uso de navegador headless (JS) para la extracción.
  --nsxiv             Abrir imágenes descargadas con el visor 'nsxiv'.
  -h, --help          Muestra este menú de ayuda y sale.
EOF
}

# --- FUNCIÓN PRINCIPAL DE EJECUCIÓN ---

main() {
    # 1. Procesamiento de argumentos de línea de comandos
    local modo_vista="html"
    local modo_extraccion="curl"
    
    for arg in "$@"; do shift; case "$arg" in "--js") set -- "$@" "-j" ;; "--nsxiv") set -- "$@" "-n" ;; "--help") set -- "$@" "-h" ;; *) set -- "$@" "$arg"; esac; done
    while getopts "jnh" opt; do case $opt in j) modo_extraccion="js" ;; n) modo_vista="nsxiv" ;; h) mostrar_ayuda; exit 0 ;; \?) log ERROR "Opción inválida." >&2; mostrar_ayuda; exit 1 ;; esac; done
    shift "$((OPTIND -1))"

    # Se usa una variable readonly para proteger la URL original de ser
    # sobrescrita por scripts cargados con 'source'.
    local readonly original_url="${1:-}"
    if [[ -z "$original_url" ]]; then
        log ERROR "No se proporcionó URL. Use -h para ver la ayuda."
        exit 1
    fi

    # 2. Configuración del entorno de ejecución
    log INFO "🚀 Ejecutando Gallery Tool v${VERSION}"
    verificar_dependencias "curl" "pup" "sed" "numfmt" "zip" "file" "identify"
    
    local regla_cerebro="$SCRIPT_DIR/reglas/generic.sh"
    log INFO "🧠 Cargando cerebro de extracción: $regla_cerebro"
    source "$regla_cerebro"

    local ruta_relativa
    ruta_relativa=$(generar_ruta_desde_url "$original_url")
    local DIR_GALERIA="$GALLERY_TOOL_ROOT/gallery-tool/$ruta_relativa"
    
    log INFO "📁 Directorio de la galería: $DIR_GALERIA"
    
    # 3. Verificación de caché
    if [ -f "$DIR_GALERIA/.complete" ]; then
        log INFO "✨ Galería encontrada en caché. Mostrando resultados..."
        abrir_visualizador "$modo_vista" "$DIR_GALERIA"
        log INFO "✅ Proceso finalizado."
        wait ${VIEWER_PID:-0} 2>/dev/null || true
        exit 0
    fi
    
    # 4. Preparación de directorios
    log INFO "Galería no encontrada o incompleta. Iniciando proceso completo..."
    mkdir -p "$DIR_GALERIA"
    echo "$original_url" > "$DIR_GALERIA/.source_url"
    
    local raw_urls_file="$DIR_TRABAJO/raw_urls.txt"
    local processed_urls_file="$DIR_TRABAJO/processed_urls.txt"
    local final_urls_file="$DIR_TRABAJO/final_urls.txt"

    # 5. Flujo de procesamiento principal
    log INFO "--- FASE 1: Extracción ---"
    extraer_urls_con_regla "$original_url" "$raw_urls_file" "$modo_extraccion"
    if [ ! -s "$raw_urls_file" ]; then
        log ERROR "No se encontraron URLs multimedia en la página."
        rm -rf "$DIR_GALERIA"; exit 1
    fi
    
    log INFO "--- FASE 2: Normalización ---"
    procesar_urls "$raw_urls_file" "$processed_urls_file" "$original_url"
    
    log INFO "--- FASE 3: Optimización ---"
    deduplicar_y_optimizar "$processed_urls_file" "$final_urls_file"

    log INFO "--- FASE 4: Descarga ---"
    descargar_multimedia "$final_urls_file" "$DIR_GALERIA" "$original_url" 12

    # 6. Flujo de post-procesamiento
    log INFO "--- FASE 5: Limpieza, Renombrado y Compresión ---"
    limpiar_multimedia_descargada "$DIR_GALERIA"
    renombrar_para_ordenar "$DIR_GALERIA"
    crear_archivo_zip "$DIR_GALERIA"
    
    local archivos_restantes
    archivos_restantes=$(find "$DIR_GALERIA" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp -o -iname \*.mp4 -o -iname \*.webm \) | wc -l)
    if [ "$archivos_restantes" -eq 0 ]; then
        log WARN "No quedaron archivos multimedia válidos después de la limpieza. Abortando."
        exit 0
    fi
    
    # 7. Finalización y visualización
    log INFO "--- FASE 6: Visualización ---"
    abrir_visualizador "$modo_vista" "$DIR_GALERIA"
    
    touch "$DIR_GALERIA/.complete"
    log INFO "✅ Proceso finalizado. Galería guardada en: $DIR_GALERIA"
    wait ${VIEWER_PID:-0} 2>/dev/null || true
}

# --- Punto de Entrada del Script ---
main "$@"
