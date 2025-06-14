# =========================================================
# Contenido para: ~/.bashrc
# El ÚNICO punto de entrada para Bash.
# =========================================================
# Si no es una sesión interactiva, no hacer nada.
[ -z "$PS1" ] && return

# Carga la configuración principal de Bash.
[ -f "$HOME/.config/shell/bash_specific.sh" ] && source "$HOME/.config/shell/bash_specific.sh"
