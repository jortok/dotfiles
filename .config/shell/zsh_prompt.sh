# =========================================================
# Contenido para: ~/.config/shell/zsh_prompt.zsh
# El nuevo y flamante prompt para Zsh, replicando el de Bash.
# =========================================================

autoload -Uz vcs_info
autoload -U colors && colors

# --- Configuración de vcs_info para Git ---
# Habilitar para el sistema de control de versiones 'git'.
zstyle ':vcs_info:*' enable git

# Define los símbolos para cada estado de Git (¡la magia está aquí!).
zstyle ':vcs_info:git:*' unstagedstr '!'  # Modificado pero no en staging.
zstyle ':vcs_info:git:*' stagedstr '+'    # En staging.
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}%S%F{reset}'   # Símbolo de staging en verde.
zstyle ':vcs_info:*' unstagedstr '%F{red}%U%F{reset}' # Símbolo de unstaged en rojo.

# Hook para comprobar archivos no rastreados y stashes.
# Esta función se añade a las comprobaciones que hace vcs_info.
zsh_prompt_git_extras() {
  # Comprobar si hay archivos no rastreados.
  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    # Añadir '?' a los indicadores.
    vcs_info_msg_1_="${vcs_info_msg_1_}?"
  fi
  # Comprobar si hay stashes.
  if $(git rev-parse --verify refs/stash &>/dev/null); then
    # Añadir '$' a los indicadores.
    vcs_info_msg_1_="${vcs_info_msg_1_}$"
  fi
}
# Registra nuestra función para que se ejecute.
zstyle ':vcs_info:*' a-hooks git-untracked
zstyle ':vcs_info:*' hooks git-untracked

# ---- Formato del Mensaje de vcs_info ----
# Formato principal: ' on <nombre_rama>'
# %b: nombre de la rama.
zstyle ':vcs_info:git:*' formats " on %F{172}%b%F{white}"
# Formato para los indicadores de estado: '[!!!]'
# %c: staged
# %u: unstaged
# msg_1_: donde ponemos nuestros símbolos '?' y '$'
zstyle ':vcs_info:git:*' actionformats ' on %F{172}%b%F{blue} [%c%u%F{blue}${vcs_info_msg_1_}]%F{white}'

# Añade vcs_info a los comandos que se ejecutan antes de mostrar el prompt.
precmd_functions+=(vcs_info)

# --- Construcción Final del Prompt (PS1) ---
# Replicando el estilo de tu prompt de Bash con la sintaxis de Zsh.
local user_style='%F{orange}'
[[ "$USER" == "root" ]] && user_style='%F{red}'

local host_style='%F{yellow}'
[[ -n "$SSH_TTY" ]] && host_style='%F{red}'

PS1=$'\n'                                         # Nueva línea
PS1+='%B${user_style}%n%F{white}@'               # usuario@
PS1+="${host_style}%m%F{white} in "             # maquina in
PS1+="%F{green}%~"                              # directorio
PS1+='${vcs_info_msg_0_}'                        # Mensaje de Git (' on branch [+++]')
PS1+=$'\n%F{white}\$ %f%b'                       # Símbolo de prompt $ y reseteo.
