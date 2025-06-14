# =========================================================
# Contenido para: ~/.config/shell/zsh_prompt.zsh
# (VERSIÓN FINAL CORREGIDA SIN \n LITERAL)
# =========================================================
autoload -Uz vcs_info
autoload -U colors && colors

# --- Configuración de vcs_info para Git ---
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' unstagedstr '!'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}%S%F{reset}'
zstyle ':vcs_info:*' unstagedstr '%F{red}%U%F{reset}'
zsh_prompt_git_extras() {
  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then vcs_info_msg_1_="${vcs_info_msg_1_}?"; fi
  if $(git rev-parse --verify refs/stash &>/dev/null); then vcs_info_msg_1_="${vcs_info_msg_1_}$"; fi
};
zstyle ':vcs_info:*' a-hooks git-untracked
zstyle ':vcs_info:*' hooks git-untracked
zstyle ':vcs_info:git:*' formats " on %F{172}%b%F{white}"
zstyle ':vcs_info:git:*' actionformats ' on %F{172}%b%F{blue} [%c%u%F{blue}${vcs_info_msg_1_}]%F{white}'
precmd_functions+=(vcs_info)

# --- Construcción Final del Prompt (PS1) ---
user_style='%F{orange}'
[[ "$USER" == "root" ]] && user_style='%F{red}'
host_style='%F{yellow}'
[[ -n "$SSH_TTY" ]] && host_style='%F{red}'

# Prompt de dos líneas.
# La primera línea con la información.
PROMPT='%B${user_style}%n%F{white}@${host_style}%m%F{white} in %F{green}%~${vcs_info_msg_0_}'
# La segunda línea con el símbolo de prompt. El $'\n' asegura el salto de línea.
PROMPT+=$'\n%F{white}$ %f%b'
