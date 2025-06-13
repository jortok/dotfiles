#!/bin/bash

# ==============================================================================
# Cerebro de Extracción para Gallery Tool v4.7.3
#
# Novedades:
# - Se simplificó la detección de funciones de módulo para mayor robustez.
# ==============================================================================

# --- Carga Dinámica de Módulos ---
log INFO "🧩 Cargando módulos de reglas..."
for module_file in "$(dirname "$BASH_SOURCE")"/*-module.sh; do
    if [ -f "$module_file" ]; then
        log INFO "  -> Módulo cargado: $(basename "$module_file")"
        source "$module_file"
    fi
done

# --- Funciones Auxiliares (sin cambios) ---
validate_and_normalize_url() { local url_raw="$1"; local base_url="$2"; local url_clean=$(echo "$url_raw" | tr -d '\r\n\t' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'); if [[ -z "$url_clean" || "$url_clean" == "#" || "$url_clean" == "/" || "$url_clean" =~ ^data: || "$url_clean" =~ (google-analytics|facebook.com/tr) ]]; then return 1; fi; if [[ "$url_clean" =~ ^// ]]; then echo "https:$url_clean"; elif [[ "$url_clean" =~ ^/ ]]; then echo "$base_url$url_clean"; elif [[ ! "$url_clean" =~ ^https?:// ]]; then echo "$base_url/$url_clean"; else echo "$url_clean"; fi; return 0; }
process_srcset() { local srcset="$1"; local base_url="$2"; echo "$srcset" | tr ',' '\n' | while IFS= read -r entry; do local url=$(echo "$entry" | sed -E 's/^[[:space:]]*([^[:space:]]+).*/\1/'); validate_and_normalize_url "$url" "$base_url"; done; }


# ==============================================================================
# FUNCIÓN DE ORQUESTACIÓN PRINCIPAL
# ==============================================================================
extraer_urls_con_regla() {
    local url="$1"; local output_file="$2"; local modo_extraccion="$3"
    local html_content_file; html_content_file=$(mktemp)
    local temp_urls_file; temp_urls_file=$(mktemp)
    local base_url=$(echo "$url" | sed -E 's|(https?://[^/]+).*|\1|')

    # --- Decisión de Extracción Inicial ---
    if [[ "$url" == *"reddit.com"* ]]; then
        reddit "$url" "$temp_urls_file"
    else
        log INFO "🔍 Usando método de extracción genérico (Modo: $modo_extraccion)..."
        if [[ "$modo_extraccion" == "js" ]]; then timeout 60 chromium --headless --no-sandbox --dump-dom "$url" > "$html_content_file" 2>/dev/null; else set +e; curl -f -sL --user-agent "Mozilla/5.0" "$url" > "$html_content_file"; local code=$?; set -e; if [[ $code -ne 0 ]]; then log WARN "curl falló, fallback a --js..."; timeout 60 chromium --headless --no-sandbox --dump-dom "$url" > "$html_content_file" 2>/dev/null; fi; fi
        if [ ! -s "$html_content_file" ]; then log ERROR "No se pudo descargar HTML."; touch "$output_file"; rm -f "$html_content_file" "$temp_urls_file"; return; fi
        
        log INFO "Analizando HTML en busca de multimedia..."
        local src_attrs=("src" "data-src" "data-lazy-src" "data-original"); for attr in "${src_attrs[@]}"; do pup "img[$attr] attr{$attr}" < "$html_content_file" | while IFS= read -r l; do validate_and_normalize_url "$l" "$base_url"; done >> "$temp_urls_file"; done
        pup 'a[href*=".jpg"], a[href*=".jpeg"], a[href*=".png"] attr{href}' < "$html_content_file" | while IFS= read -r l; do validate_and_normalize_url "$l" "$base_url"; done >> "$temp_urls_file"
        pup 'img[srcset] attr{srcset}' < "$html_content_file" | while IFS= read -r s; do process_srcset "$s" "$base_url"; done >> "$temp_urls_file"
        pup 'video[src] attr{src}, meta[property^="og:image"] attr{content}' < "$html_content_file" | while IFS= read -r l; do validate_and_normalize_url "$l" "$base_url"; done >> "$temp_urls_file"
    fi
    
    # --- Decisión de Post-procesamiento ---
    if [[ "$url" == *"fapello.com"* ]]; then
        fapello "$temp_urls_file"
    elif [[ "$url" == *"directstripper.com"* ]]; then
        directstripper "$temp_urls_file"
    elif [[ "$url" == *"voyeurweb.com"* ]]; then
        vw "$temp_urls_file"
    fi
    
    # --- Filtrado Final ---
    if [ ! -s "$temp_urls_file" ]; then log WARN "Extracción inicial no encontró URLs."; fi
    
    log INFO "🧹 Limpiando y filtrando resultados..."
    grep -iE '\.(jpe?g|png|gif|webp|avif|mp4|webm|mov)(\?[^?]*)?$' "$temp_urls_file" \
      | grep -v -iE '(\.svg$|placeholder|dummy|blank|logo|avatar|profile|thumbs|stuff|user|icon|favicon|gravatar|spinner|loading)' \
      | sort -u > "$output_file"
    
    rm -f "$html_content_file" "$temp_urls_file"

    if [ -s "$output_file" ]; then
        log INFO "✓ Extracción finalizada: $(wc -l < "$output_file" | awk '{print $1}') URLs válidas encontradas."
    else
        log WARN "No se encontraron URLs válidas tras el filtrado."
    fi
}
