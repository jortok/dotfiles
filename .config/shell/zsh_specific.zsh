# =========================================================
# Contenido para: ~/.config/shell/zsh_specific.zsh
# (VERSIÓN CORREGIDA Y FINAL)
# =========================================================

# --- 1. Cargar Componentes Compartidos ---
[ -f "$HOME/.config/shell/shared_aliases.sh" ] && source "$HOME/.config/shell/shared_aliases.sh"
[ -f "$HOME/.config/shell/shared_functions.sh" ] && source "$HOME/.config/shell/shared_functions.sh"

# --- 2. Configuración Específica de Zsh ---
HISTFILE="$HOME/.cache/zsh_history";
setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS;
setopt autocd interactive_comments;
stty stop undef;

# --- 3. Sistema de Autocompletado ---
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# --- 4. Modo Vi y Atajos de Teclado ---
bindkey -v
export KEYTIMEOUT=1
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
function zle-keymap-select() { case $KEYMAP in (vicmd) echo -ne '\e[1 q';; (viins|main) echo -ne '\e[5 q';; esac }; zle -N zle-keymap-select;
function zle-line-init() { zle -K viins; echo -ne '\e[5 q' }; zle -N zle-line-init; echo -ne '\e[5 q'; preexec() { echo -ne '\e[5 q'; };
bindkey -s '^o' 'lfcd\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
autoload -U edit-command-line; zle -N edit-command-line; bindkey '^e' edit-command-line;

# --- 5. Cargar el Prompt de Zsh ---
# ¡LA CLAVE! Esta opción le dice a Zsh que sustituya las variables en el prompt.
setopt PROMPT_SUBST
[ -f "$HOME/.config/shell/zsh_prompt.zsh" ] && source "$HOME/.config/shell/zsh_prompt.zsh"

# --- 6. Resaltado de Sintaxis (Debe ir al FINAL) ---
if [ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# --- 7. Autocompletado Adicional ---
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
