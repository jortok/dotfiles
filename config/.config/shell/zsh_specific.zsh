# =========================================================
# Contenido para: ~/.config/shell/zsh_specific.zsh
# =========================================================

# --- 1. Cargar Componentes Compartidos ---
[ -f "$HOME/.config/shell/shared_aliases.sh" ] && source "$HOME/.config/shell/shared_aliases.sh"
[ -f "$HOME/.config/shell/shared_functions.sh" ] && source "$HOME/.config/shell/shared_functions.sh"

# --- 2. Configuración de Historial Específica de Zsh ---
# Esto está bien configurado.
HISTFILE="$HOME/.cache/zsh_history"
HISTSIZE=32768
SAVEHIST=32768
setopt APPEND_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# --- 3. Configuración Interactiva Adicional ---
# Esto está bien configurado.
setopt autocd interactive_comments
stty stop undef

# --- 4. Sistema de Autocompletado ---
# Tu configuración de autocompletado es sólida. Solo nos aseguraremos
# de que zsh-completions (cargado como plugin) la enriquezca.
fpath=($HOME/.config/zsh/completions $fpath)
autoload -U compinit; compinit
zmodload zsh/complist
zstyle ':completion:*' menu select
_comp_options+=(globdots)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
source <(kubectl completion zsh)


# --- 5. Modo Vi y Atajos de Teclado ---
bindkey -v
export KEYTIMEOUT=1

# --- 6. Integración de fzf
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi

# --- 7. Carga de Plugins (MÉTODO ÚNICO Y CENTRALIZADO) ---
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

function plugin-load {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      # --- COMENTARIO ---
      # La URL ahora se construye usando el formato SSH (git@github.com:).
      echo "Cloning $repo via SSH..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        #"git@github.com:${repo}.git" "$plugdir"
        "https://github.com:${repo}.git" "$plugdir"
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found for '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

# El orden importa: los plugins de resaltado y sugerencias deben ir al final.
repos=(
  # Frameworks y utilidades base
  rupa/z                                  # Para saltar a directorios frecuentes
  zsh-users/zsh-completions               # Colección de autocompletados adicionales
  #felix-schindler/docker-zsh-completion

  # Búsqueda en historial (el plugin en sí)
  zsh-users/zsh-history-substring-search
  joshskidmore/zsh-fzf-history-search

  # Prompt (Tema visual de la línea de comandos)
  #sindresorhus/pure
  #powerlevel10k/powerlevel10k

  # git
  wfxr/forgit
  unixorn/git-extra-commands


  # Plugins que modifican la línea de comandos (deben ir al final)
  zsh-users/zsh-syntax-highlighting       # Resalta la sintaxis mientras escribes
  zsh-users/zsh-autosuggestions           # Sugiere comandos basados en tu historial
)

# Ahora cargamos todos los plugins desde un solo lugar.
plugin-load $repos

# --- 8. Autocompletado y Atajos Específicos ---
# Esto se queda, ya que es configuración personal, no un plugin genérico.
compdef _git config=git

# --- COMENTARIO ---
# Los atajos para history-substring-search van AQUÍ, después de que el plugin
# ha sido cargado por `plugin-load`.
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- 9. Cargar Prompt Personal ---
# Se vuelve a cargar tu prompt personalizado en lugar de 'pure'.
setopt PROMPT_SUBST
[ -f "$HOME/.config/shell/zsh_prompt.zsh" ] && source "$HOME/.config/shell/zsh_prompt.zsh"

# --- 10, 11. SECCIONES ELIMINADAS ---
# --- COMENTARIO ---
# Se eliminaron las secciones 10 y 11 y el contenido de la 7 original porque
# ahora `plugin-load` se encarga de:
#   - Cargar el prompt `pure` (adiós, zsh_prompt.zsh).
#   - Cargar `zsh-history-substring-search`.
#   - Cargar `zsh-syntax-highlighting`.
