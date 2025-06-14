# =========================================================
# Contenido para: ~/.config/shell/zsh_specific.zsh
# (VERSIÓN FINAL CON CORRECCIÓN DE CARGA DE HISTORIAL)
# =========================================================

# --- 1. Cargar Componentes Compartidos ---
[ -f "$HOME/.config/shell/shared_aliases.sh" ] && source "$HOME/.config/shell/shared_aliases.sh"
[ -f "$HOME/.config/shell/shared_functions.sh" ] && source "$HOME/.config/shell/shared_functions.sh"

# --- 2. Configuración de Historial Específica de Zsh ---
# ¡CORRECCIÓN CLAVE! Toda la configuración de historial va aquí.
# Se definen como variables de shell, no de entorno.
HISTFILE="$HOME/.cache/zsh_history"
HISTSIZE=32768
SAVEHIST=32768 # SAVEHIST es el estándar en Zsh para el tamaño del archivo.

# Opciones de historial que ahora deberían funcionar correctamente.
setopt APPEND_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# --- 3. Configuración Interactiva Adicional ---
setopt autocd interactive_comments
stty stop undef

# --- 4. Sistema de Autocompletado ---
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# --- 5. Modo Vi y Atajos de Teclado ---
bindkey -v
export KEYTIMEOUT=1

# --- 6. Integración de fzf (Búsqueda Mejorada) ---
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi

# --- 7. Búsqueda en Historial con Flechas (history-substring-search) ---
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

# --- 8. Autocompletado para Alias y Herramientas Adicionales ---
compdef _git config=git

# Habilita el autocompletado para el alias `k` (kubectl)
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

# --- 9. Cargar el Prompt de Zsh ---
setopt PROMPT_SUBST
[ -f "$HOME/.config/shell/zsh_prompt.zsh" ] && source "$HOME/.config/shell/zsh_prompt.zsh"

# --- 10. Resaltado de Sintaxis (Debe ir al FINAL) ---
if [ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

neofetch
