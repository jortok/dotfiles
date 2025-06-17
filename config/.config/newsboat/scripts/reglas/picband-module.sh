#!/bin/bash

# ==============================================================================
# Módulo de Post-procesamiento para picband.com
#
# Contiene una única función que sabe cómo transformar las URLs de este sitio.
# Es llamado por la regla genérica después de la extracción inicial.
# ==============================================================================

function picband() {
    local archivo_de_urls="$1"

    # 1. Validar que se recibió un argumento.
    if [[ -z "$archivo_de_urls" ]]; then
        log ERROR "No se proporcionó la ruta al archivo de URLs."
        return 1 # Retorna un código de error
    fi

    # 2. Validar que el archivo realmente existe.
    if [[ ! -f "$archivo_de_urls" ]]; then
        log ERROR "El archivo '$archivo_de_urls' no existe o no es un archivo regular."
        return 1
    fi

    log INFO "🐕 Aplicando post-procesamiento para picband.com..."

    # 3. Usar sed para hacer ambas operaciones en un solo paso y modificar el archivo.
    #    -i: modifica el archivo "in-place" (en el sitio).
    #    -e: permite ejecutar múltiples scripts/expresiones.
    #    1er script: '/static/!d' -> Si una línea NO (!) contiene "static", la borra (d).
    #    2do script: 's/.../.../'  -> Realiza la sustitución que ya tenías.
    sed -i \
        -e '/static/!d' \
        -e 's/\/t\([0-9]\+\.jpg\)$/\/\1/' \
        "$archivo_de_urls"

    log INFO "🐕 Terminando post-procesamiento para picband.com..."
}