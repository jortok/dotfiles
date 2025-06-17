# =========================================================
# Contenido para: ~/.config/shell/zsh_prompt.zsh
# (VERSIÓN FINAL RECONSTRUIDA LÓGICAMENTE)
# =========================================================
autoload -Uz vcs_info
autoload -U colors && colors

# --- PASO 1. Habilitar vcs_info para Git y activar la detección de cambios ---
# Es lo primero, le decimos a vcs_info que se prepare para 'git'.
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true

# --- PASO 2. Definir los símbolos para los estados de Git ---
# Definimos qué caracteres usar para los placeholders %c (staged) y %u (unstaged).
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '!'

# --- PASO 3. Definir y registrar un hook para estados extra (untracked, stash) ---
# Primero, la función que añade '?' para archivos no seguidos y '$' para stashes.
zsh_prompt_git_extras() {
  # Revisa si hay archivos untracked
  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    vcs_info_msg_1_="${vcs_info_msg_1_}?"
  fi
  # Revisa si hay stashes
  if $(git rev-parse --verify refs/stash &>/dev/null); then
    vcs_info_msg_1_="${vcs_info_msg_1_}$"
  fi
}

# AHORA, LA CORRECCIÓN CLAVE:
# Registramos el NOMBRE EXACTO de nuestra función ('zsh_prompt_git_extras') en el array de 'hooks'.
# vcs_info ejecutará esta función y pondrá su salida en ${vcs_info_msg_1_}.
zstyle ':vcs_info:*' hooks zsh_prompt_git_extras

# --- PASO 4. Definir los formatos de salida que usan nuestros símbolos y hooks ---
# 'formats' se usa cuando el repo está LIMPIO. Solo muestra la rama (%b).
zstyle ':vcs_info:git:*' formats " on %F{172}%b%F{white}"

# 'actionformats' se usa cuando hay CAMBIOS. Muestra la rama y los símbolos.
# %b = branch, %c = staged, %u = unstaged, ${vcs_info_msg_1_} = nuestro hook.
zstyle ':vcs_info:git:*' actionformats " on %F{172}%b%F{white} [%F{blue}%c%u${vcs_info_msg_1_}%F{white}]"

# --- PASO 5. Registrar el trigger para ejecutar vcs_info ---
# Ya que todo está configurado, ahora le decimos a Zsh que ejecute vcs_info antes de cada prompt.
# Este debe ser uno de los últimos pasos de la configuración de vcs_info.
precmd_functions+=(vcs_info)

# --- PASO 6. Construcción Final del Prompt ---
# Finalmente, construimos el prompt usando ${vcs_info_msg_0_}, que vcs_info poblará.
user_style='%F{orange}'
[[ "$USER" == "root" ]] && user_style='%F{red}'
host_style='%F{yellow}'
[[ -n "$SSH_TTY" ]] && host_style='%F{red}'

PROMPT='%B${user_style}%n%F{white}@${host_style}%m%F{white} in %F{green}%~${vcs_info_msg_0_}'
PROMPT+=$'\n%F{white}$ %f%b'
