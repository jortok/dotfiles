# Contenido para: ~/.config/shell/shared_env.sh
# ---------------------------------------------------------
# Define y exporta las rutas estándar de XDG.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"

# Configura el PATH, añadiendo binarios de Go y locales.
export PATH="$HOME/.local/bin/statusbar:$HOME/.local/bin/cron:$HOME/.local/bin:$PATH:/usr/local/go/bin"


# ---- Editor y Herramientas de Desarrollo ----
export EDITOR='nvim'
export GPG_TTY=$(tty)

# ---- Configuración de Herramientas (XDG Compliant) ----
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export MINIKUBE_HOME="$XDG_DATA_HOME/.config/minikube"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export GOPATH="$XDG_DATA_HOME/go"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYLINTHOME="$XDG_CACHE_HOME"/pylint

# ---- Node.js REPL ----
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node_history"
export NODE_REPL_HISTORY_SIZE='32768'
export NODE_REPL_MODE='sloppy'

# ---- Python y Otros ----
export PYTHONIOENCODING='UTF-8'
export MANPAGER='less -X'

# ---  ChatGPT Key    ----
export OPENAI_API_KEY=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
