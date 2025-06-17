#!/bin/bash

# ==============================================================================
# Módulo de Post-procesamiento para fapello.com
#
# Contiene una única función que sabe cómo transformar las URLs de este sitio.
# Es llamado por la regla genérica después de la extracción inicial.
# ==============================================================================

function directstripper() {

    local archivo_de_urls="$1"
    log INFO "🐕 Aplicando post-procesamiento para www.directstripper.com..."
    
    # Creamos un archivo temporal para no modificar el original mientras leemos.
    local temp_transformado; temp_transformado=$(mktemp)
    
    # Usamos `sed` para quitar el sufijo "_300px" y lo guardamos en el temporal.
    sed 's/-400x600//g' "$archivo_de_urls" > "$temp_transformado"
    
    # Sobrescribimos el archivo original con el contenido transformado.
    mv "$temp_transformado" "$archivo_de_urls"
}
