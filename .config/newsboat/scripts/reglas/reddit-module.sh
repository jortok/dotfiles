#!/bin/bash

# ==============================================================================
# Módulo de Extracción para Reddit
#
# Contiene la lógica específica para extraer galerías de Reddit, que es
# completamente diferente a la genérica.
# Es llamado por la regla genérica cuando detecta una URL de Reddit.
# ==============================================================================

function reddit() {
    local url="$1"; local output_file="$2";
    local user_data_dir="${GALLERY_USER_DATA_DIR:-$HOME/.config/chromium}"
    log INFO "👽 Detectada URL de Reddit. Usando módulo de extracción específico..."
    
    if ! command -v chromium &> /dev/null; then
        log ERROR "El módulo de Reddit requiere 'chromium'. Por favor, instálalo."; exit 1
    fi
    
    local page_html; page_html=$(mktemp)
    timeout 60 chromium --headless --no-sandbox --dump-dom --user-data-dir="$user_data_dir" "$url" > "$page_html" 2>/dev/null

    if [ ! -s "$page_html" ]; then
        log WARN "El módulo de Reddit no pudo obtener el HTML. Verifica tu sesión en Chromium."; touch "$output_file"; return
    fi
    
    # Lógica de extracción y post-procesamiento de Reddit combinadas.
    {
        pup 'li[slot^="page-"] img attr{src}' < "$page_html"
        pup 'li[slot^="page-"] img attr{srcset}' < "$page_html" | tr ',' '\n' | awk '{print $1}'
    } | sed 's/&amp;/\&/g' > "$output_file"

    rm -f "$page_html"
}
