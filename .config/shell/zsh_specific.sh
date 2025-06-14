# =========================================================
# Contenido para: ~/.config/shell/zsh_specific.zsh
# Configuración que se carga solo para Zsh.
# =========================================================

# --- 1. Cargar Componentes Compartidos ---
[ -f "$HOME/.config/shell/shared_env.sh" ] && source "$HOME/.config/shell/shared_env.sh"
[ -f "$HOME/.config/shell/shared_aliases.sh" ] && source "$HOME/.config/shell/shared_aliases.sh"
[ -f "$HOME/.config/shell/shared_functions.sh" ] && source "$HOME/.config/shell/shared_functions.sh"

# --- 2. Configuración Específica de Zsh ---

# Historial
HISTFILE="$HOME/.cache/zsh_history"
setopt APPEND_HISTORY          # Añade al historial, no sobreescribe.
setopt INC_APPEND_HISTORY      # Añade comandos inmediatamente.
setopt HIST_IGNORE_ALL_DUPS    # No añade duplicados.
setopt HIST_REDUCE_BLANKS      # Elimina espacios en blanco superfluos.

# Opciones Generales
setopt autocd                  # Entrar a un directorio tecleando su nombre.
setopt interactive_comments    # Permite comentarios en la terminal interactiva.
stty stop undef                # Deshabilita Ctrl-S.

# --- 3. Sistema de Autocompletado ---
# Se inicializa antes de configurar los atajos de teclado que dependen de él.
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Incluir archivos ocultos.

# --- 4. Modo Vi y Atajos de Teclado ---
bindkey -v
export KEYTIMEOUT=1 # Reduce el lag de la tecla ESC en modo Vi.

# Navegación con teclas de Vi en el menú de autocompletado.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Función para cambiar el cursor entre modo comando (bloque) e inserción (línea).
function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q' ;; # block
    viins | main) echo -ne '\e[5 q' ;; # beam
  esac
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins
  echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

# Atajos con Ctrl
bindkey -s '^o' 'lfcd\n'  # Ctrl+O para `lfcd`
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n' # Ctrl+F para `fzf`
autoload -U edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line # Ctrl+E para editar comando en $EDITOR

# --- 5. Cargar el Prompt de Zsh ---
[ -f "$HOME/.config/shell/zsh_prompt.zsh" ] && source "$HOME/.config/shell/zsh_prompt.zsh"

# --- 6. Resaltado de Sintaxis (Debe ir al FINAL) ---
if [ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# Cargar autocompletado de kubectl si existe.
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
