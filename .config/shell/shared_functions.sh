# Contenido para: ~/.config/shell/shared_functions.sh
# ---------------------------------------------------------
# Crea un directorio y entra en él.
function mkcd() {
	mkdir -p "$1" && cd "$1";
}

# Determina el tamaño de un archivo o directorio.
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# `diff` que usa la salida de color de Git.
if command -v git >/dev/null 2>&1; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi

# Crea una URL de datos (data URL) a partir de un archivo.
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Inicia un servidor HTTP simple desde el directorio actual.
function server() {
	local port="${1:-8000}";
	echo "Iniciando servidor en http://localhost:${port}"
	sleep 1 && xdg-open "http://localhost:${port}/" &
	python -m http.server "$port";
}

# Compara el tamaño original de un archivo con su versión gzippeada.
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "Original: %d bytes\n" "$origsize";
	printf "Gzipped:  %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Una versión más limpia de `dig`.
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# `o`: abre el directorio actual o el archivo/directorio especificado con xdg-open.
function o() {
	if [ $# -eq 0 ]; then
		xdg-open .;
	else
		xdg-open "$@";
	fi;
}

# `tre`: un `tree` más inteligente que ignora directorios comunes y usa `less`.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Comprueba si una URL está activa (devuelve código 200).
function isup() {
	local uri=$1
	if curl -s --head --request GET "$uri" | grep "200 OK" > /dev/null; then
		echo "$uri está arriba."
		notify-send --urgency=low "$uri está arriba."
	else
		echo "$uri está caído."
		notify-send --urgency=critical "$uri está caído."
	fi
}

# Funciones de Docker mejoradas.
function dclean() {
	echo "🧹 Limpiando Docker..."
	docker container prune -f
	docker image prune -f
	docker volume prune -f
	docker network prune -f
	echo "✅ Limpieza completada."
}
function dip() {
  docker inspect --format '{{.Id}} {{.Name}} {{.Config.Image}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) | \
  awk '{printf "%-12.12s %-30.30s %-30.30s %-20.20s\n", $1, substr($2,2), $3, $4}'
}
