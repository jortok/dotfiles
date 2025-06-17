#!/bin/bash

# ==============================================================================
# Módulo de Post-procesamiento para voyeurweb.com
#
# Contiene una única función que sabe cómo transformar las URLs de este sitio.
# Es llamado por la regla genérica después de la extracción inicial.
# ==============================================================================

function vw() {
    local archivo_de_urls="$1"
    log INFO "🐕 Aplicando post-procesamiento para voyeurweb.com..."
    
    # Creamos un archivo temporal para no modificar el original mientras leemos.
    local temp_transformado; temp_transformado=$(mktemp)
    
    cat $archivo_de_urls | grep "large" > $temp_transformado

    # Sobrescribimos el archivo original con el contenido transformado.
    mv "$temp_transformado" "$archivo_de_urls"
}
