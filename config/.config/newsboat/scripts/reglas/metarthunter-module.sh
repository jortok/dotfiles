#!/bin/bash

# ==============================================================================
# Módulo de Post-procesamiento para metarthunter.com
#
# Contiene una única función que sabe cómo transformar las URLs de este sitio.
# Es llamado por la regla genérica después de la extracción inicial.
# ==============================================================================

function metart() {
    local archivo_de_urls="$1"
    log INFO "🐕 Aplicando post-procesamiento para metarthunter.com..."
    
    # Creamos un archivo temporal para no modificar el original mientras leemos.
    local temp_transformado; temp_transformado=$(mktemp)
    
    grep "content" "$archivo_de_urls" > "$temp_transformado"; mv "$temp_transformado" "$archivo_de_urls"
    sed 's/w200/1200/g' "$archivo_de_urls" > "$temp_transformado"; mv "$temp_transformado" "$archivo_de_urls"
    sed 's/w400/1200/g' "$archivo_de_urls" > "$temp_transformado"; mv "$temp_transformado" "$archivo_de_urls"
    sed 's/w600/1200/g' "$archivo_de_urls" > "$temp_transformado"; mv "$temp_transformado" "$archivo_de_urls"
    sed 's/w800/1200/g' "$archivo_de_urls" > "$temp_transformado"; mv "$temp_transformado" "$archivo_de_urls"
    sed 's/400/1200/g' "$archivo_de_urls" > "$temp_transformado"; mv "$temp_transformado" "$archivo_de_urls"
    sort -u "$archivo_de_urls" -o "$archivo_de_urls"
}
