# =========================================================
# Contenido para: ~/.config/shell/shared_aliases.sh
# (VERSIÓN CORREGIDA Y FINAL)
# =========================================================

# ---- Navegación y Sistema ----
alias c="clear"
alias cls="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ---- Manipulación de Archivos (con interactividad y verbosidad) ----
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -i"

# ---- ls con colores (solo para sistemas GNU/Linux) ----
export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
alias ls='ls -h --color=auto --group-directories-first'
alias l='ls -lFh'
alias la='ls -lAFh'
alias ll='ls -lrthA'
alias lsd="ls -lFh | grep --color=never '^d'"
alias lsf="ls -lFh | grep --color=never '^-'"

# ---- Editores ----
alias vim="nvim"
alias vi="nvim"

# ---- Gestión de Dotfiles ----
# ¡Tu alias esencial para gestionar tus dotfiles con git!
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ---- Redes y Puertos ----
alias ports='ss -tulanp'
alias mnt="mount | awk '{if (/^\/dev/ || /^\/\//) print(\$1,\$2,\$3)}' | column -t | sort"
alias NetExtIP="curl -s ipinfo.io/ip"
alias NetIntIPall="ip a |grep 'inet '| awk '{print \$NF,\$2}'"
alias NetIntGW="ip r | grep default | cut -d' ' -f 3"
alias NetIntIPv4='hostname -I | cut -d" " -f1'

# ---- Búsqueda y Utilidades ----
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias path='echo -e ${PATH//:/\\n}'
alias week='date +%V'
alias tokudate='date +"%Y-%m-%d w%V.%u %H:%M"'

# ---- Git ----
alias g="git"

# ---- Docker ----
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias dexe="docker exec -it"
alias dins="docker inspect"
alias dlog="docker logs -f"
alias drmi="docker rmi"
alias dsp="docker system prune --all -f"
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dclogs="docker-compose logs -f"

# ---- Kubernetes ----
if command -v kubecolor >/dev/null 2>&1; then
    alias k='kubecolor'
else
    alias k='kubectl'
fi
alias kg='k get'
alias kgp='k get pod'
alias kgpw='k get pod -o wide'
alias kgd='k get deploy'
alias kgs='k get service'
alias kgj='k get jobs'
alias kapp='k apply -f'
alias kdel='k delete -f'
