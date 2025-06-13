#!/bin/bash

# ==============================================================================
# Archivo de Funciones Compartidas para Gallery Tool v5.0
# ==============================================================================

# --- FUNCIONES DE UTILIDAD ---
log() {
    local level="$1"; shift; local message="$*"; local timestamp;
    timestamp=$(date '+%Y-%m-%d %H:%M:%S');
    case "$level" in
        ERROR) echo -e "❌ [$timestamp] ERROR: $message" >&2 ;;
        WARN)  echo -e "⚠️  [$timestamp] WARN:  $message" >&2 ;;
        INFO)  echo -e "ℹ️  [$timestamp] INFO:  $message" ;;
    esac
}
verificar_dependencias() {
    local dependencias_requeridas=("$@"); local faltantes=();
    log INFO "Verificando dependencias: ${dependencias_requeridas[*]}";
    for dep in "${dependencias_requeridas[@]}"; do
        if ! command -v "$dep" &> /dev/null; then faltantes+=("$dep"); fi
    done
    if [[ ${#faltantes[@]} -gt 0 ]]; then
        log ERROR "Dependencias faltantes: ${faltantes[*]}. Por favor, instálalas."; exit 1;
    fi;
    log INFO "Todas las dependencias necesarias están presentes."
}

# --- FUNCIONES DE PROCESAMIENTO (SIN CAMBIOS) ---
procesar_urls() {
    local input_file="$1"; local output_file="$2"; local page_url="$3";
    log INFO "Procesando y normalizando URLs..."
    local temp_processed; temp_processed=$(mktemp)
    local base_url; base_url=$(echo "$page_url" | grep -oP 'https?://[^/]+')
    local dir_url; dir_url=$(dirname "$page_url")
    while IFS= read -r url_media; do
        [ -z "$url_media" ] && continue
        if [[ "$url_media" =~ ^// ]]; then url_media="https:${url_media}";
        elif [[ "$url_media" =~ ^/ ]]; then url_media="${base_url}${url_media}";
        elif [[ ! "$url_media" =~ ^https?:// ]]; then url_media="${dir_url}/${url_media}";
        fi
        echo "$url_media" | sed 's#/\./#/#g' >> "$temp_processed"
    done < "$input_file"
    sort -u "$temp_processed" > "$output_file"
    rm -f "$temp_processed"
}
deduplicar_y_optimizar() {
    local input_file="$1"; local output_file="$2";
    log INFO "Deduplicando y eligiendo la mejor resolución..."
    # ... (Sin cambios en el interior de esta función)
    if [ ! -s "$input_file" ]; then log WARN "No se encontraron URLs válidas para optimizar."; touch "$output_file"; return; fi
    local -A url_candidates=(); local -A url_scores=();
    while IFS= read -r url || [[ -n "$url" ]]; do
        [[ -z "$url" ]] && continue; local base_key; base_key=$(basename "$url" | sed -e 's/?.*//' -e 's/&auto=webp.*//' -e 's/&fm=jpg.*//'); local score=0;
        if [[ "$url" =~ width=([0-9]+) ]]; then score="${BASH_REMATCH[1]}"; elif [[ "$url" =~ ([0-9]{2,5})x([0-9]{2,5}) ]]; then score="${BASH_REMATCH[1]}"; fi
        local existing_score=${url_scores[$base_key]:-0}; if (( score > existing_score )); then url_candidates["$base_key"]="$url"; url_scores["$base_key"]=$score; elif ! [[ -v url_scores[$base_key] ]]; then url_candidates["$base_key"]="$url"; url_scores["$base_key"]=0; fi
    done < "$input_file"
    local count=0; if [[ ${#url_candidates[@]} -gt 0 ]]; then printf "%s\n" "${url_candidates[@]}" > "$output_file"; count=${#url_candidates[@]}; else log WARN "No se pudo determinar la mejor resolución, se usarán todas las URLs encontradas."; cp "$input_file" "$output_file"; count=$(wc -l < "$output_file" | awk '{print $1}'); fi
    log INFO "Seleccionadas $count imágenes únicas."
}
descargar_multimedia() {
    local url_list_file="$1"; local download_dir="$2"; local jobs="${3:-8}";
    # ... (Sin cambios en el interior de esta función)
    if [ ! -s "$url_list_file" ]; then log WARN "No hay archivos que descargar."; return; fi; local total; total=$(wc -l < "$url_list_file"); log INFO "Iniciando descarga de $total archivos con $jobs trabajos paralelos...";
    cat "$url_list_file" | xargs -d '\n' -n 1 -P "$jobs" sh -c 'fname=$(basename "$2" | sed "s/?.*//"); wget -q --user-agent="Mozilla/5.0" -O "$1/$fname" "$2"' _ "$download_dir"; log INFO "Descarga completada."
}
limpiar_multimedia_descargada() {
    local media_dir="$1"; local min_dimension=301;
    # ... (Sin cambios en el interior de esta función)
    if ! command -v identify &> /dev/null; then log WARN "Comando 'identify' (ImageMagick) no instalado. Saltando limpieza por dimensiones."; return; fi
    log INFO "🧹 Limpiando avatares e iconos pequeños..."; local archivos_a_eliminar=();
    for file in "$media_dir"/*.{jpg,jpeg,png,gif,webp}; do [ -f "$file" ] || continue; local dimensions; dimensions=$(identify -format "%w %h" "$file" 2>/dev/null); if [ -z "$dimensions" ]; then log WARN "No se pudieron obtener las dimensiones de: $(basename "$file")"; continue; fi; local width; local height; read -r width height <<< "$dimensions"; if [ "$width" -lt "$min_dimension" ] || [ "$height" -lt "$min_dimension" ]; then archivos_a_eliminar+=("$file"); fi; done
    if [ ${#archivos_a_eliminar[@]} -gt 0 ]; then for file_to_delete in "${archivos_a_eliminar[@]}"; do log INFO "  -> Eliminando imagen pequeña: $(basename "$file_to_delete")"; rm "$file_to_delete"; done; log INFO "Limpieza completada. Se eliminaron ${#archivos_a_eliminar[@]} archivos."; else log INFO "No se encontraron imágenes pequeñas que eliminar."; fi
}

# --- NUEVA FUNCIÓN DE RENOMBRADO ---
renombrar_para_ordenar() {
    local media_dir="$1"
    log INFO "🔢 Renombrando archivos para asegurar orden natural..."
    
    # Revisa si los archivos ya están renombrados para no hacerlo dos veces
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
    local padding=$(printf "%0${#total_files}d" 0 | wc -c)
    padding=$((padding - 1))
    
    local counter=1
    for old_file in "${files[@]}"; do
        local filename; filename=$(basename "$old_file")
        local new_filename; new_filename=$(printf "%0${padding}d_%s" "$counter" "$filename")
        mv -n "$old_file" "$media_dir/$new_filename"
        ((counter++))
    done
    
    log INFO "Se renombraron $total_files archivos correctamente."
}

# --- NUEVA FUNCIÓN PARA CREAR ZIP ---
crear_archivo_zip() {
    local media_dir="$1"
    local gallery_name; gallery_name=$(basename "$media_dir")
    local zip_file="$media_dir/$gallery_name.zip"

    log INFO "📦 Creando archivo ZIP..."

    if [ -f "$zip_file" ]; then
        log INFO "El archivo ZIP ya existe. Saltando este paso."
        return
    fi

    # Usamos "zip -j" para no guardar la ruta de los directorios (junk paths)
    # -q para modo silencioso
    if ! zip -j -q "$zip_file" "$media_dir"/*.{jpg,jpeg,png,gif,webp,mp4,webm}; then
        log WARN "No se encontraron archivos para comprimir o hubo un error con 'zip'."
        return
    fi

    log INFO "Archivo ZIP creado en: $zip_file"
}

# --- FUNCIONES DE VISUALIZACIÓN (MODIFICADAS) ---
generar_galeria_html() {
    local media_dir="$1"
    local html_file="$media_dir/galeria.html"
    local source_url_file="$media_dir/.source_url"
    local template_file="$SCRIPT_DIR/gallery-template.html"

    if [ ! -f "$template_file" ]; then log ERROR "No se encontró plantilla: $template_file"; return 1; fi
    local source_url; source_url=$(cat "$source_url_file")
    
    log INFO "Generando galería HTML desde plantilla..."
    local media_files_js="["; local file_count=0;
    
    # Ahora busca los archivos ya renombrados, ordenados por nombre.
    local sorted_files
    sorted_files=$(find "$media_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp -o -iname \*.mp4 -o -iname \*.webm \) | sort)

    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            local filename; filename=$(basename "$file")
            local extension; extension="${filename##*.}"
            local size; size=$(stat -c%s "$file" 2>/dev/null || echo 0)
            local size_human; size_human=$(numfmt --to=iec --suffix=B "$size" 2>/dev/null || echo "${size}B")
            [[ $file_count -gt 0 ]] && media_files_js+=","
            local sanitized_name; sanitized_name=$(echo "$filename" | sed 's/"/\\"/g')
            media_files_js+="{\"name\":\"$sanitized_name\",\"extension\":\"$extension\",\"size\":\"$size_human\"}"
            ((file_count++))
        fi
    done <<< "$sorted_files"

    media_files_js+="]"

    # Lógica para el botón de ZIP
    local gallery_name; gallery_name=$(basename "$media_dir")
    local zip_file_name="$gallery_name.zip"
    local zip_button_html=""
    if [ -f "$media_dir/$zip_file_name" ]; then
        zip_button_html="<a href=\"./${zip_file_name}\" download class=\"button-zip\">📦 Descargar todo (.zip)</a>"
    fi
    
    local escaped_url; escaped_url=$(printf '%s\n' "$source_url" | sed 's:[&/\]:\\&:g')
    sed -e "s|SOURCE_URL_PLACEHOLDER|$escaped_url|g" \
        -e "s|MEDIA_FILES_PLACEHOLDER|$media_files_js|g" \
        -e "s|PLACEHOLDER_ITEM_COUNT|$file_count|g" \
        -e "s|<!-- ZIP_BUTTON_PLACEHOLDER -->|$zip_button_html|g" \
        "$template_file" > "$html_file"
    log INFO "Galería HTML generada con $file_count elementos."
}

VIEWER_PID=0
abrir_visualizador() {
    local modo="$1"; local media_dir="$2"
    local navegador="${BROWSER:-xdg-open}"
    
    # Para nsxiv, le pasamos los archivos ordenados
    if [[ "$modo" == "nsxiv" ]]; then
        log INFO "Abriendo con nsxiv...";
        # shellcheck disable=SC2046
        nsxiv -f -t $(find "$media_dir" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp \) | sort) &
        VIEWER_PID=$!
    else
        local html_file="$media_dir/galeria.html"
        if [ ! -f "$html_file" ] || [[ "$media_dir/.complete" != "$html_file" ]]; then
            log WARN "galeria.html no encontrada o desactualizada, generándola ahora..."
            generar_galeria_html "$media_dir" || { log ERROR "Falló la generación de galeria.html."; return 1; }
        fi
        log INFO "Abriendo galería HTML con $navegador...";
        "$navegador" "file://$html_file" &
        VIEWER_PID=$!
    fi
}
