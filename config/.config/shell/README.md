# Guía de Configuración de Shell (Zsh + Bash)

Este es un entorno de shell modular y de alto rendimiento, diseñado con una filosofía de "home limpio", priorizando Zsh como la experiencia principal y manteniendo a Bash como una alternativa funcional y consistente.

## Filosofía y Objetivos

1.  **Zsh como Shell Principal:** La experiencia en Zsh es la más rica y completa, potenciada con un gestor de plugins, autocompletado avanzado y un prompt personalizado.
2.  **Bash como Alternativa Funcional:** Bash hereda toda la configuración compartida (alias, funciones, variables) para ser una alternativa consistente y útil cuando sea necesaria.
3.  **Hogar Limpio (`~/`):** Se minimiza el número de "dotfiles" en el directorio `home`. La configuración principal reside en `~/.config/` gracias al uso de la variable `ZDOTDIR`.
4.  **Modularidad:** La lógica se separa en archivos con propósitos específicos para evitar la duplicación y facilitar las modificaciones. Un alias se cambia en `shared_aliases.sh` y el cambio se aplica a ambos shells.

---

## Estructura de Archivos

La configuración está centralizada en `~/.config/`, dejando el directorio home (`~`) con el mínimo de archivos posible.

```bash
/home/toku/
├── .bashrc               <-- Punto de entrada para Bash.
└── .zshenv               <-- ÚNICO archivo en home para Zsh. Define ZDOTDIR.
└── .config/
├── zsh/
|   ├── .zshrc            <-- Punto de entrada para Zsh interactivo (leído gracias a ZDOTDIR).
│   ├── plugins/          <-- Directorio para los plugins descargados por el gestor.
│   │   └── ...
│   └── completions/      <-- Scripts de autocompletado específicos para Zsh.
│       └── _kubectl
│       └── ...└── shell/
├── README.md             <-- (Este archivo)
├── shared_env.sh         <-- Variables de entorno para AMBOS shells (PATH, EDITOR, etc.).
├── shared_aliases.sh     <-- Aliases para AMBOS shells (l, la, config, k, dcu, etc.).
├── shared_functions.sh   <-- Funciones para AMBOS shells (mkcd, dclean, tre, etc.).
├── bash_specific.sh      <-- Orquestador principal de Bash.
├── zsh_specific.zsh      <-- Orquestador principal de Zsh (cerebro de la configuración).
└── zsh_prompt.zsh        <-- Toda la lógica del prompt personalizado de Zsh.
```

---

## Flujo de Carga Detallado

### Zsh (El Shell Principal)

El flujo de Zsh es elegante y mantiene el directorio `home` limpio.

1.  **`~/.zshenv`**: Es lo **primero** que Zsh lee. Su única misión es exportar la variable `export ZDOTDIR="$HOME/.config/zsh"`. Esto le dice a Zsh que, a partir de este momento, debe buscar el resto de sus archivos de configuración (como `.zshrc`) dentro de `~/.config/zsh/`.
2.  **`~/.config/zsh/.zshrc`**: Al ser una shell interactiva, Zsh ahora busca y encuentra este archivo (gracias a `ZDOTDIR`). Este archivo simplemente actúa como un cargador para el orquestador principal.
3.  **`~/.config/shell/zsh_specific.zsh`**: El verdadero cerebro. Este archivo:
    * Carga los módulos compartidos (`shared_aliases.sh`, `shared_functions.sh`).
    * Configura el historial, el autocompletado avanzado y el modo Vi.
    * **Ejecuta el gestor de plugins `plugin-load`** para descargar y activar los plugins.
    * Carga el prompt personalizado desde `zsh_prompt.zsh`.

### Bash (El Shell Alternativo)

1.  **`~/.bashrc`**: El punto de entrada tradicional.
2.  **`~/.config/shell/bash_specific.sh`**: Orquesta la carga de los módulos compartidos (`shared_env.sh`, `shared_aliases.sh`, `shared_functions.sh`).

---

## Componentes Clave de Zsh

### Gestor de Plugins (`plugin-load`)

El archivo `zsh_specific.zsh` contiene una función personalizada que gestiona los plugins. Clona los repositorios desde GitHub usando **SSH** y los carga en el orden correcto.

**Plugins Instalados Actualmente:**

* `rupa/z`: Salta a directorios frecuentes basándose en tu historial.
* `zsh-users/zsh-completions`: Una colección masiva de mejoras para el autocompletado.
* `zsh-users/zsh-history-substring-search`: Permite buscar en el historial escribiendo cualquier parte de un comando.
* `zsh-users/zsh-syntax-highlighting`: Resalta la sintaxis de los comandos en tiempo real.
* `zsh-users/zsh-autosuggestions`: Sugiere comandos mientras escribes, basándose en tu historial.

### Funciones y Alias Notables

(Para una lista completa, revisar los archivos `shared_aliases.sh` y `shared_functions.sh`)

* **Alias `config`**: El pilar para gestionar estos dotfiles (`/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME`).
* **Alias `k`**: Atajo para `kubectl`.
* **Alias `dcu`/`dcd`**: Inicia y detiene contenedores de `docker-compose`.
* **Función `dclean`**: Limpia drásticamente Docker (contenedores, imágenes y volúmenes no usados).
* **Función `tre`**: Muestra un árbol de directorios optimizado, ignorando `node_modules`.
