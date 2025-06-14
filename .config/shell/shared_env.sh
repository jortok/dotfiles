# Contenido para: ~/.config/shell/shared_env.sh
# ---------------------------------------------------------
# Define y exporta las rutas estándar de XDG.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Configura el PATH, añadiendo binarios de Go y locales.
export PATH="$HOME/.local/bin/statusbar:$HOME/.local/bin/cron:$HOME/.local/bin:$PATH:/usr/local/go/bin"


# ---- Editor y Herramientas de Desarrollo ----
export EDITOR='nvim'
export GPG_TTY=$(tty)

# ---- Configuración de Herramientas (XDG Compliant) ----
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export GOPATH="$XDG_DATA_HOME/go"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# ---- Node.js REPL ----
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node_history"
export NODE_REPL_HISTORY_SIZE='32768'
export NODE_REPL_MODE='sloppy'

# ---- Python y Otros ----
export PYTHONIOENCODING='UTF-8'
export MANPAGER='less -X'

# ---  ChatGPT Key    ----
OPENAI_API_KEY=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
