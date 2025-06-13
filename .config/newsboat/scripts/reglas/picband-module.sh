#!/bin/bash

# ==============================================================================
# Módulo de Extracción para picband.com (hus) para Gallery Tool
#
# Este módulo está diseñado para parsear un formato de URL específico
# que contiene un rango numérico, como:
# URL: https://picband.com/static/pics/31517/[1-15].jpg
# ==============================================================================

# La función principal que será llamada desde generic.sh
# Recibe la URL de la página y el archivo de salida para las URLs extraídas.
picband() {
    local page_url="$1"
    local output_file="$2"

    log INFO "🤖 Ejecutando módulo de extracción específico para picband.com..."

    # Descarga el contenido de la página. Se usa '|| true' para evitar que
    # un error de curl detenga todo el script (set -e).
    local page_content
    page_content=$(curl -f -sL --user-agent "Mozilla/5.0" "$page_url" || true)
    
    if [ -z "$page_content" ]; then
        log WARN "No se pudo descargar contenido de la página o está vacío."
        return
    fi

    # Busca la línea con el patrón de URL, la procesa y expande el rango.
    # El resultado se guarda directamente en el archivo de salida.
    echo $page_content | grep "URL"
    echo "$page_content" | grep 'URL:' | while IFS= read -r line; do
        # Extrae la plantilla (ej: https://.../[1-15].jpg) y quita espacios
        local url_template
        url_template=$(echo "$line" | sed -n 's/.*URL: *\(https.*\)/\1/p' | tr -d '[:space:]')
        echo $url_template

        # Usa una expresión regular de Bash para capturar las partes de la URL
        if [[ "$url_template" =~ (.*)\[([0-9]+)-([0-9]+)\](\..*) ]]; then
            local base_url="${BASH_REMATCH[1]}"
            local start_num="${BASH_REMATCH[2]}"
            local end_num="${BASH_REMATCH[3]}"
            local extension="${BASH_REMATCH[4]}"
            
            log INFO "Plantilla encontrada: ${base_url}[${start_num}-${end_num}]${extension}"
            log INFO "Generando URLs desde el rango $start_num al $end_num..."

            # Itera con 'seq' para generar los números y construye cada URL
            for i in $(seq "$start_num" "$end_num"); do
                echo "${base_url}${i}${extension}"
            done
        else
            log WARN "No se pudo parsear la plantilla de URL: $url_template"
        fi
    done > "$output_file"
    
    local count
    count=$(wc -l < "$output_file" | awk '{print $1}')
    if [ "$count" -gt 0 ]; then
        log INFO "Módulo 'picband' extrajo $count URLs."
    else
        log WARN "Módulo 'picband' no pudo extraer ninguna URL."
    fi
}
