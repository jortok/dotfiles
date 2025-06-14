# =========================================================
# Contenido para: ~/.config/shell/bash_specific.sh
# (VERSIÓN FINAL CON HISTORIAL Y PROMPT DE GIT RESTAURADO)
# =========================================================

# --- 1. Cargar Componentes Compartidos ---
[ -f "$HOME/.config/shell/shared_env.sh" ] && source "$HOME/.config/shell/shared_env.sh"
[ -f "$HOME/.config/shell/shared_aliases.sh" ] && source "$HOME/.config/shell/shared_aliases.sh"
[ -f "$HOME/.config/shell/shared_functions.sh" ] && source "$HOME/.config/shell/shared_functions.sh"

# --- 2. Configuración de Historial Específica de Bash ---
export HISTFILE="$HOME/.cache/bash_history"
shopt -s histappend

# --- 3. Configuración Interactiva Específica de Bash ---
shopt -s nocaseglob
shopt -s cdspell
shopt -s autocd
shopt -s globstar

# --- 4. Prompt de Bash (SECCIÓN RESTAURADA) ---
prompt_git() { local s='';
 local branchName=''; git rev-parse --is-inside-work-tree &>/dev/null || return; branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || git describe --all --exact-match HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null || echo '(unknown)')";
if ! $(git diff --quiet --ignore-submodules --cached); then s+='+'; fi; if ! $(git diff-files --quiet --ignore-submodules --); then s+='!'; fi;
if [ -n "$(git ls-files --others --exclude-standard)" ]; then s+='?'; fi; if $(git rev-parse --verify refs/stash &>/dev/null); then s+='$'; fi;
[ -n "${s}" ] && s=" [${s}]"; echo -e "${1}${branchName}${2}${s}"; };
if tput setaf 1 &> /dev/null; then bold=$(tput bold);
reset=$(tput sgr0); blue=$(tput setaf 33); green=$(tput setaf 64); orange=$(tput setaf 166); violet=$(tput setaf 61); red=$(tput setaf 124); white=$(tput setaf 15);
else bold=''; reset="\e[0m"; blue="\e[1;34m"; green="\e[1;32m"; orange="\e[1;33m"; violet="\e[1;35m"; red="\e[1;31m"; white="\e[1;37m"; fi;
if [[ "${USER}" == "root" ]]; then userStyle="${red}"; else userStyle="${orange}";
fi; if [[ "${SSH_TTY}" ]]; then hostStyle="${bold}${red}"; else hostStyle="${yellow}"; fi;
PS1="\[\033]0;\W\007\]"; PS1+="\[${userStyle}\]\u"; PS1+="\[${white}\] at "; PS1+="\[${hostStyle}\]\h"; PS1+="\[${white}\] in "; PS1+="\[${green}\]\w";
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")"; PS1+="\n"; PS1+="\[${white}\]\$ \[${reset}\]"; export PS1;
PS2="\[${yellow}\]→ \[${reset}\]"; export PS2;

# --- 5. Autocompletado de Bash ---
if [ -f /usr/share/bash-completion/bash_completion ]; then
	source /usr/share/bash-completion/bash_completion;
fi;
# Carga autocompletados de terceros desde una carpeta dedicada
if [ -d "$HOME/.config/shell/completions" ];
then
    for completion_file in "$HOME/.config/shell/completions/"*; do
        [ -f "$completion_file" ] && source "$completion_file"
    done
fi
# Habilita el autocompletado de git para el alias 'g'
if type _git &> /dev/null;
then
	complete -o default -o nospace -F _git g;
fi;
