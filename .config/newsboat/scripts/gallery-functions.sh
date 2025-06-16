#!/bin/bash
# ==============================================================================
# Archivo de Funciones Compartidas para Gallery Tool v5.1
# Corrección final en el manejo de traps para evitar errores de scope.
# ==============================================================================

# ------------------------------------------------------------------------------
# SECCIÓN 1: UTILIDADES Y LOGGING
# ------------------------------------------------------------------------------

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        ERROR) echo -e "❌ [$timestamp] ERROR: $message" >&2 ;;
        WARN)  echo -e "⚠️  [$timestamp] WARN:  $message" >&2 ;;
        INFO)  echo -e "ℹ️  [$timestamp] INFO:  $message" ;;
    esac
}

verificar_dependencias() {
    local dependencias_requeridas=("$@")
    local faltantes=()
    log INFO "Verificando dependencias: ${dependencias_requeridas[*]}"
    for dep in "${dependencias_requeridas[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            faltantes+=("$dep")
        fi
    done
    if [[ ${#faltantes[@]} -gt 0 ]]; then
        log ERROR "Dependencias faltantes: ${faltantes[*]}. Por favor, instálalas."
        exit 1
    fi
    log INFO "Todas las dependencias necesarias están presentes."
}

# ------------------------------------------------------------------------------
# SECCIÓN 2: PROCESAMIENTO Y FILTRADO DE URLS
# ------------------------------------------------------------------------------

procesar_urls() {
    local input_file="$1"
    local output_file="$2"
    local page_url="$3"

    log INFO "Procesando y normalizando URLs..."
    local temp_processed
    temp_processed=$(mktemp)
    local base_url
    base_url=$(echo "$page_url" | grep -oP 'https?://[^/]+')
    local dir_url
    dir_url=$(dirname "$page_url")

    while IFS= read -r url_media; do
        [ -z "$url_media" ] && continue

        if [[ "$url_media" =~ ^// ]]; then
            url_media="https:${url_media}"
        elif [[ "$url_media" =~ ^/ ]]; then
            url_media="${base_url}${url_media}"
        elif [[ ! "$url_media" =~ ^https?:// ]]; then
            url_media="${dir_url}/${url_media}"
        fi
        echo "$url_media" | sed 's#/\./#/#g' >> "$temp_processed"
    done < "$input_file"

    sort -u "$temp_processed" > "$output_file"
    rm -f "$temp_processed"
}

deduplicar_y_optimizar() {
    local input_file="$1"
    local output_file="$2"

    log INFO "Deduplicando y eligiendo la mejor resolución..."
    if [ ! -s "$input_file" ]; then
        log WARN "No se encontraron URLs válidas para optimizar."
        touch "$output_file"
        return
    fi

    local -A url_candidates=()
    local -A url_scores=()

    while IFS= read -r url || [[ -n "$url" ]]; do
        [[ -z "$url" ]] && continue
        local base_key
        base_key=$(basename "$url" | sed -e 's/?.*//' -e 's/&auto=webp.*//' -e 's/&fm=jpg.*//')
        local score=0
        if [[ "$url" =~ width=([0-9]+) ]]; then
            score="${BASH_REMATCH[1]}"
        elif [[ "$url" =~ ([0-9]{2,5})x([0-9]{2,5}) ]]; then
            score="${BASH_REMATCH[1]}"
        fi

        local existing_score=${url_scores[$base_key]:-0}
        if (( score > existing_score )); then
            url_candidates["$base_key"]="$url"
            url_scores["$base_key"]=$score
        elif ! [[ -v url_scores[$base_key] ]]; then
            url_candidates["$base_key"]="$url"
            url_scores["$base_key"]=0
        fi
    done < "$input_file"

    if [[ ${#url_candidates[@]} -gt 0 ]]; then
        printf "%s\n" "${url_candidates[@]}" > "$output_file"
        local count=${#url_candidates[@]}
        log INFO "Seleccionadas $count imágenes únicas."
    else
        log WARN "No se pudo determinar la mejor resolución, se usarán todas las URLs encontradas."
        cp "$input_file" "$output_file"
        local count
        count=$(wc -l < "$output_file" | awk '{print $1}')
        log INFO "Seleccionadas $count imágenes únicas."
    fi
}

# ------------------------------------------------------------------------------
# SECCIÓN 3: DESCARGA DE MULTIMEDIA
# ------------------------------------------------------------------------------

descargar_multimedia() {
    local url_list_file="$1"
    local download_dir="$2"
    local page_url="$3"
    local jobs="${4:-12}"

    if [ -z "$url_list_file" ] || [ -z "$download_dir" ] || [ -z "$page_url" ]; then
        log ERROR "Uso: ${FUNCNAME[0]} <archivo_urls> <directorio_descarga> <url_pagina_galeria>"
        log ERROR "Uno o más argumentos requeridos para la descarga están vacíos. Abortando."
        return 1
    fi

    if [ ! -s "$url_list_file" ]; then
        log WARN "No hay archivos que descargar en '$url_list_file'."
        return
    fi

    local cookie_jar
    cookie_jar=$(mktemp)
    # --- CORRECCIÓN CLAVE ---
    # El trap ahora solo se activa cuando la función RETORNA, no cuando el script TERMINA.
    # Esto asegura que "$cookie_jar" todavía existe cuando el trap se ejecuta.
    trap 'rm -f "$cookie_jar"' RETURN

    log INFO "Obteniendo cookies de sesión desde $page_url..."
    if ! curl -sL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36" -o /dev/null -c "$cookie_jar" "$page_url"; then
        log ERROR "No se pudieron obtener las cookies de sesión. Revisa la URL de la galería. Abortando."
        return 1
    fi

    if [ ! -s "$cookie_jar" ]; then
        log WARN "El servidor no proporcionó cookies. La descarga podría fallar..."
    else
        log INFO "Cookies guardadas exitosamente."
    fi
    export cookie_jar

    local total
    total=$(wc -l < "$url_list_file")
    log INFO "Iniciando descarga de $total archivos con $jobs trabajos en paralelo..."

    cat "$url_list_file" | xargs -d '\n' -n 1 -P "$jobs" sh -c '
        d_dir="$1"
        p_url="$2"
        current_url="$3"
        fname=$(basename "$current_url" | sed "s/?.*//")

        if ! curl -f -sS -b "$cookie_jar" -e "$p_url" \
             -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36" \
             -H "Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8" \
             -H "Accept-Language: es-MX,es;q=0.9,en-US;q=0.8,en;q=0.7" \
             -H "Sec-Fetch-Dest: image" -H "Sec-Fetch-Mode: no-cors" -H "Sec-Fetch-Site: same-origin" \
             -o "$d_dir/$fname" "$current_url"; then
            
            rm -f "$d_dir/$fname"
            echo "[$(date)] FALLO: $current_url" >> "$d_dir/descargas.log"
        fi
    ' _ "$download_dir" "$page_url"

    log INFO "Descarga completada. Revisa descargas.log para ver posibles fallos."
}

# ------------------------------------------------------------------------------
# SECCIÓN 4: POST-PROCESAMIENTO (LIMPIEZA, RENOMBRADO, COMPRESIÓN)
# ------------------------------------------------------------------------------

limpiar_multimedia_descargada() {
    local media_dir="$1"
    local min_dimension=301
    
    if ! command -v identify &>/dev/null || ! command -v file &>/dev/null; then
        log WARN "Comandos 'identify' o 'file' no instalados. Saltando limpieza por dimensiones."
        return
    fi

    log INFO "Limpiando avatares e imágenes pequeñas..."
    local archivos_a_eliminar=()
    local file_list
    file_list=$(find "$media_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp \))

    while IFS= read -r file; do
        local mime_type
        mime_type=$(file --mime-type -b "$file")
        if [[ ! "$mime_type" == image/* ]]; then
            log WARN "Archivo no es una imagen real: $(basename "$file") (tipo: $mime_type). Saltando."
            continue
        fi

        local dimensions
        dimensions=$(timeout 5s identify -format "%w %h" "$file" 2>/dev/null)
        if [ -z "$dimensions" ]; then
            log WARN "No se pudieron obtener dimensiones (corrupto o timeout): $(basename "$file")"
            continue
        fi
        
        local width height
        read -r width height <<< "$dimensions"
        
        if [ "$width" -lt "$min_dimension" ] || [ "$height" -lt "$min_dimension" ]; then
            archivos_a_eliminar+=("$file")
        fi
    done <<< "$file_list"

    if [ ${#archivos_a_eliminar[@]} -gt 0 ]; then
        for file_to_delete in "${archivos_a_eliminar[@]}"; do
            log INFO "-> Eliminando imagen pequeña: $(basename "$file_to_delete")"
            rm "$file_to_delete"
        done
        log INFO "Limpieza completada. Se eliminaron ${#archivos_a_eliminar[@]} archivos."
    else
        log INFO "No se encontraron imágenes pequeñas que eliminar."
    fi
}

renombrar_para_ordenar() {
    local media_dir="$1"
    log INFO "Renombrando archivos para asegurar orden natural..."
    
    if find "$media_dir" -maxdepth 1 -type f -name '001_*' -print -quit | grep -q .; then
        log INFO "Los archivos ya parecen estar renombrados. Saltando este paso."
        return
    fi
    
    local -a files
    while IFS= read -r file; do
        files+=("$file")
    done < <(find "$media_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp -o -iname \*.mp4 -o -iname \*.webm \) | sort -V)
    
    if [ ${#files[@]} -eq 0 ]; then
        log WARN "No se encontraron archivos multimedia para renombrar."
        return
    fi

    local total_files=${#files[@]}
    local padding=${#total_files}
    
    local counter=1
    for old_file in "${files[@]}"; do
        local filename
        filename=$(basename "$old_file")
        local new_filename
        new_filename=$(printf "%0${padding}d_%s" "$counter" "$filename")
        mv -n "$old_file" "$media_dir/$new_filename"
        ((counter++))
    done
    
    log INFO "Se renombraron $total_files archivos correctamente."
}

crear_archivo_zip() {
    local media_dir="$1"
    local gallery_name
    gallery_name=$(basename "$media_dir")
    local zip_file="$media_dir/$gallery_name.zip"

    log INFO "Creando archivo ZIP..."

    if [ -f "$zip_file" ]; then
        log INFO "El archivo ZIP ya existe. Saltando este paso."
        return
    fi

    if ! zip -j -q "$zip_file" "$media_dir"/*.{jpg,jpeg,png,gif,webp,mp4,webm}; then
        log WARN "No se encontraron archivos para comprimir o hubo un error con 'zip'."
    fi

    log INFO "Archivo ZIP creado en: $zip_file"
}

# ------------------------------------------------------------------------------
# SECCIÓN 5: GENERACIÓN DE HTML Y VISUALIZACIÓN
# ------------------------------------------------------------------------------

generar_galeria_html() {
    local media_dir="$1"
    local html_file="$media_dir/galeria.html"
    local source_url_file="$media_dir/.source_url"
    local template_file="$SCRIPT_DIR/gallery-template.html"

    if [ ! -f "$template_file" ]; then log ERROR "No se encontró plantilla: $template_file"; return 1; fi
    
    local source_url
    source_url=$(cat "$source_url_file")
    
    log INFO "Generando galería HTML desde plantilla..."
    local media_files_js="["
    local file_count=0
    
    local sorted_files
    sorted_files=$(find "$media_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp -o -iname \*.mp4 -o -iname \*.webm \) | sort)

    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            local filename size size_human extension sanitized_name
            filename=$(basename "$file")
            extension="${filename##*.}"
            size=$(stat -c%s "$file" 2>/dev/null || echo 0)
            size_human=$(numfmt --to=iec --suffix=B "$size" 2>/dev/null || echo "${size}B")
            sanitized_name=$(echo "$filename" | sed 's/"/\\"/g')
            
            [[ $file_count -gt 0 ]] && media_files_js+=","
            media_files_js+="{\"name\":\"$sanitized_name\",\"extension\":\"$extension\",\"size\":\"$size_human\"}"
            ((file_count++))
        fi
    done <<< "$sorted_files"
    media_files_js+="]"

    local gallery_name zip_file_name zip_button_html escaped_url
    gallery_name=$(basename "$media_dir")
    zip_file_name="$gallery_name.zip"
    zip_button_html=""
    if [ -f "$media_dir/$zip_file_name" ]; then
        zip_button_html="<a href=\"./${zip_file_name}\" download class=\"button-zip\">📦 Descargar todo (.zip)</a>"
    fi
    
    escaped_url=$(printf '%s\n' "$source_url" | sed 's:[&/\]:\\&:g')

    sed -e "s|SOURCE_URL_PLACEHOLDER|$escaped_url|g" \
        -e "s|MEDIA_FILES_PLACEHOLDER|$media_files_js|g" \
        -e "s|PLACEHOLDER_ITEM_COUNT|$file_count|g" \
        -e "s|<!-- ZIP_BUTTON_PLACEHOLDER -->|$zip_button_html|g" \
        "$template_file" > "$html_file"
    log INFO "Galería HTML generada con $file_count elementos."
}

abrir_visualizador() {
    local modo="$1"
    local media_dir="$2"
    local navegador="${BROWSER:-xdg-open}"
    
    if [[ "$modo" == "nsxiv" ]]; then
        log INFO "Abriendo con nsxiv..."
        # shellcheck disable=SC2046
        nsxiv -f -t $(find "$media_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp \) | sort) &
        VIEWER_PID=$!
    else
        local html_file="$media_dir/galeria.html"
        if [ ! -f "$html_file" ]; then
            log WARN "galeria.html no encontrada, generándola ahora..."
            generar_galeria_html "$media_dir" || { log ERROR "Falló la generación de galeria.html."; return 1; }
        fi
        log INFO "Abriendo galería HTML con $navegador...";
        "$navegador" "file://$html_file" &
        VIEWER_PID=$!
    fi
}
