#!/bin/bash
# =========================================================
#        Colección de Funciones Utiles para Shell
# =========================================================
#
# Este archivo contiene funciones personalizadas para mejorar
# la productividad en la línea de comandos.
#
# Para usarlo, añádelo a tu .bashrc o .zshrc:
#   source /ruta/a/este/archivo/shared_functions.sh
#

# ---------------------------------------------------------
# --- Manejo de Archivos y Directorios
# ---------------------------------------------------------

# Crea un directorio y entra en él.
function mkcd() {
	mkdir -p "$1" && cd "$1";
}

# Determina el tamaño de un archivo o directorio de forma legible.
function fs() {
	du -sh -- "$@" 2>/dev/null || du -sh .[!.]* *;
}

# `o`: abre el directorio actual o el archivo/directorio especificado.
# Dependencias: xdg-open (Linux)
function o() {
	if [ $# -eq 0 ]; then
		xdg-open .;
	else
		xdg-open "$@";
	fi;
}

# `tre`: un `tree` más inteligente que ignora directorios comunes y usa `less`.
# Dependencias: tree, less
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Para listar solo directorios.
function lsd() {
  ls -lFh "$@" | grep --color=never '^d';
}

# Para listar solo archivos.
function lsf() {
  ls -lFh "$@" | grep --color=never '^-';
}

# Crea una copia de seguridad rápida de un archivo.
# Uso: backup archivo.txt -> crea archivo.txt.bak
function backup() {
    cp -- "$1" "${1}.bak";
}

# ---------------------------------------------------------
# --- Utilidades de Desarrollo y Red
# ---------------------------------------------------------

# `gdiff`: usa la salida de color de Git para un `diff` más legible.
# MEJORA: Se renombra a 'gdiff' para no sobreescribir el comando 'diff' del sistema,
# lo cual podría romper otros scripts.
# Dependencias: git
function gdiff() {
	git diff --no-index --color-words "$@";
}

# Crea una URL de datos (data URL) a partir de un archivo.
# Dependencias: file, openssl
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -A -in "$1")"; # MEJORA: -A en openssl para evitar saltos de línea.
}

# Inicia un servidor HTTP simple desde el directorio actual.
# Dependencias: python3
function server() {
	local port="${1:-8000}";
	echo "Iniciando servidor en http://localhost:${port}"
	# MEJORA: Se usa `command` para abrir el navegador de forma más robusta.
	sleep 1 && command -v xdg-open >/dev/null && xdg-open "http://localhost:${port}/" &
	python3 -m http.server "$port";
}

# Compara el tamaño original de un archivo con su versión gzippeada.
# Dependencias: bc
function gz() {
	# MEJORA: Se añade una comprobación para evitar división por cero si el archivo está vacío.
	local origsize=$(wc -c < "$1");
	if [ "$origsize" -eq 0 ]; then
		echo "El archivo está vacío."
		return 1
	fi
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "scale=2; $gzipsize * 100 / $origsize" | bc);
	printf "Original: %d bytes\n" "$origsize";
	printf "Gzipped:  %d bytes (%s%%)\n" "$gzipsize" "$ratio";
}

# Una versión más limpia de `dig`.
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# Comprueba si una URL está activa (devuelve código 200).
# Dependencias: curl, libnotify-bin (para notify-send)
function isup() {
	local uri=$1
	if curl -s --head --fail --request GET "$uri" > /dev/null; then # MEJORA: --fail es más semántico que `grep "200 OK"`
		echo "✅ $uri está arriba."
		command -v notify-send >/dev/null && notify-send --urgency=low "$uri está arriba."
	else
		echo "❌ $uri está caído."
		command -v notify-send >/dev/null && notify-send --urgency=critical "$uri está caído."
	fi
}

# ---------------------------------------------------------
# --- Utilidades de Docker
# ---------------------------------------------------------

# Limpia contenedores, imágenes, volúmenes y redes de Docker que no se usan.
function dclean() {
	echo "🧹 Limpiando Docker..."
	docker container prune -f
	docker image prune -f
	docker volume prune -f
	docker network prune -f
	echo "✅ Limpieza completada."
}

# Muestra una tabla con el ID, Nombre, Imagen y IP de los contenedores activos.
function dip() {
  echo "ID            Nombre                         Imagen                         IP"
  echo "------------  ------------------------------ ------------------------------ --------------------"
  docker inspect --format '{{.Id}} {{.Name}} {{.Config.Image}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) | \
  awk '{printf "%-12.12s %-30.30s %-30.30s %-20.20s\n", $1, substr($2,2), $3, $4}'
}

# Extrae cualquier archivo comprimido que le pases.
# Dependencias: tar, gzip, bzip2, unzip, etc.
function extract() {
    for file in "$@"; do
        if [ -f "$file" ]; then
            case "$file" in
                *.tar.bz2)   tar xjf "$file"    ;;
                *.tar.gz)    tar xzf "$file"    ;;
                *.bz2)       bunzip2 "$file"  ;;
                *.rar)       unrar x "$file"    ;;
                *.gz)        gunzip "$file"   ;;
                *.tar)       tar xf "$file"     ;;
                *.tbz2)      tar xjf "$file"    ;;
                *.tgz)       tar xzf "$file"    ;;
                *.zip)       unzip "$file"      ;;
                *.Z)         uncompress "$file" ;;
                *.7z)        7z x "$file"       ;;
                *)           echo "'$file' no puede ser extraído con esta función." ;;
            esac
        else
            echo "'$file' no es un archivo válido."
        fi
    done
}

# Muestra el clima de una ciudad usando wttr.in
# Dependencias: curl
function clima() {
    local city="${1:-Mexico City}" # Usa "Mexico City" por defecto si no se especifica otra.
    curl "https://wttr.in/${city}?lang=es"
}

# Genera un archivo de evidencia con el contenido de archivos de texto
# en una ruta específica, omitiendo binarios.
#
# Uso: evidencia [ruta_origen] [-o archivo_salida.txt]
#
# Argumentos:
#   ruta_origen:      La ruta a un archivo o directorio a procesar.
#   -o archivo_salida: (Opcional) El nombre del archivo donde se guardará
#                      el contenido. Por defecto es 'evidencia.txt'.
#
function evidencia() {
  local source_path=""
  local output_file="evidencia.txt"

  # 1. --- Procesar los argumentos de entrada ---
  # Este bucle permite usar -o en cualquier posición.
  while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
      -o)
        output_file="$2"
        shift # Mueve más allá del argumento '-o'
        shift # Mueve más allá de su valor
        ;;
      *)
        # Si no es -o, asumimos que es la ruta de origen
        if [ -n "$source_path" ]; then
          echo "Error: Se ha especificado más de una ruta de origen." >&2
          return 1
        fi
        source_path="$1"
        shift # Mueve más allá del argumento
        ;;
    esac
  done

  # 2. --- Validar las entradas ---
  if [ -z "$source_path" ]; then
    echo "Error: No se especificó una ruta de origen." >&2
    echo "Uso: evidencia [ruta_origen] [-o archivo_salida.txt]" >&2
    return 1
  fi

  if [ ! -e "$source_path" ]; then
    echo "Error: La ruta '$source_path' no existe." >&2
    return 1
  fi

  echo "🚀 Iniciando la generación de evidencia..."
  echo "Fuente: '$source_path'"
  echo "Salida se añadirá a: '$output_file'"

  # 3. --- Lógica principal para buscar y procesar archivos ---
  # Usamos find ... -print0 | while read ... para manejar de forma segura
  # nombres de archivo con espacios o caracteres especiales.
  local files_processed=0
  local files_skipped=0

  find "$source_path" -type f -print0 | while IFS= read -r -d '' file; do
    # Comprobar si el archivo es de tipo texto (omitir binarios, imágenes, etc.)
    if [[ $(file -b --mime-type "$file") == text/* ]]; then
      echo "✅ Procesando: $file"

      # Añadir cabecera y contenido al archivo de salida
      {
        echo "=================================================="
        echo "Archivo: $file"
        echo "Fecha: $(date)"
        echo "=================================================="
        echo ""
        cat "$file"
        echo ""
        echo "--- FIN DE ARCHIVO ---"
        echo ""
        echo ""
      } >> "$output_file"

      files_processed=$((files_processed + 1))
    else
      echo "⚠️  Omitiendo (no es texto): $file"
      files_skipped=$((files_skipped + 1))
    fi
  done

  echo "------------------------------------------"
  echo "🎉 ¡Proceso completado!"
  echo "Archivos de texto procesados: $files_processed"
  echo "Archivos omitidos (binarios, etc.): $files_skipped"
  echo "Resultados añadidos a '$output_file'."
}
