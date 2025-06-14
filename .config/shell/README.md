# Guía de Configuración Modular para Zsh y Bash

Este documento explica la estructura y el flujo de carga de la configuración para los shells Zsh y Bash, diseñada para ser modular, potente y fácil de mantener.

## Filosofía y Objetivos

1.  **Zsh como Shell Principal:** La experiencia en Zsh es la más rica y completa.
2.  **Bash como Alternativa Funcional:** Bash hereda la configuración compartida para ser una alternativa consistente y útil.
3.  **Hogar Limpio (`~/`):** Se minimiza el número de "dotfiles" en el directorio home. La configuración principal reside en `~/.config/`.
4.  **Modularidad:** La lógica se separa en archivos con propósitos específicos para evitar la duplicación y facilitar las modificaciones. Un alias se cambia en un solo lugar y afecta a ambos shells.

## Estructura Final de Archivos

```
$HOME
├── .bashrc
└── .config/
    ├── zsh/
    │   ├── .zshenv
    │   └── .zshrc
    └── shell/
        ├── README.md            <-- (Este archivo)
        ├── shared_env.sh
        ├── shared_aliases.sh
        ├── shared_functions.sh
        ├── bash_specific.sh
        ├── zsh_specific.zsh
        ├── zsh_prompt.zsh
        └── completions/
            └── kubetail.bash    <-- (Lugar para scripts de autocompletado de terceros)
```

## Flujo de Carga y Propósito de Cada Archivo

### Zsh (El Shell Principal)

El flujo de carga de Zsh es muy específico y se respeta para un rendimiento y comportamiento óptimos.

1.  **`~/.config/zsh/.zshenv`**
    * **Cuándo se carga:** *Siempre*. Al iniciar cualquier tipo de sesión de Zsh (interactiva o no, login o no).
    * **Propósito:** Definir **exclusivamente variables de entorno** (`export`). Es el lugar perfecto para `PATH`, `EDITOR`, etc., para que estén disponibles incluso en scripts.
    * **Llama a:** `~/.config/shell/shared_env.sh`

2.  **`~/.config/zsh/.zshrc`**
    * **Cuándo se carga:** Solo para shells **interactivos**.
    * **Propósito:** Configurar todo lo que el usuario ve y con lo que interactúa: alias, funciones, atajos de teclado (`bindkey`), el prompt, el historial, `compinit`, etc.
    * **Llama a:** `~/.config/shell/zsh_specific.zsh`

3.  **`~/.config/shell/zsh_specific.zsh`**
    * **Propósito:** Es el orquestador principal de la sesión interactiva de Zsh. No contiene la configuración directamente, sino que carga los módulos en el orden correcto.
    * **Llama a:** `shared_aliases.sh`, `shared_functions.sh`, `zsh_prompt.zsh` y configura `compinit`, `bindkey` y el resaltado de sintaxis.

4.  **`~/.config/shell/zsh_prompt.zsh`**
    * **Propósito:** Contiene toda la lógica para construir el prompt de Zsh, incluyendo la integración con Git a través de `vcs_info`. Está separado para mantener el archivo `zsh_specific.zsh` más limpio.

### Bash (El Shell Alternativo)

Bash tiene un flujo más simple. Todo se centraliza en `.bashrc` para sesiones interactivas.

1.  **`~/.bashrc`**
    * **Cuándo se carga:** Al iniciar un shell interactivo que no es de login. Es el punto de entrada más común.
    * **Propósito:** Es el único archivo de entrada en `~/`. Su única misión es verificar si la sesión es interactiva y, de ser así, cargar la configuración principal de Bash.
    * **Llama a:** `~/.config/shell/bash_specific.sh`

2.  **`~/.config/shell/bash_specific.sh`**
    * **Propósito:** El orquestador principal para Bash. Carga todos los componentes compartidos y luego añade la configuración que es exclusiva de Bash, como su propio prompt y su sistema de autocompletado (`bash-completion`).
    * **Llama a:** `shared_env.sh`, `shared_aliases.sh`, `shared_functions.sh` y los scripts de autocompletado.

### Archivos Compartidos

El corazón de la modularidad.

1.  **`~/.config/shell/shared_env.sh`**
    * **Propósito:** **Variables de entorno (`export`) y nada más.** Es el único lugar donde se definen.

2.  **`~/.config/shell/shared_aliases.sh`**
    * **Propósito:** **Aliases y nada más.** Contiene todos los alias que son compatibles tanto con Zsh como con Bash.

3.  **`~/.config/shell/shared_functions.sh`**
    * **Propósito:** **Funciones y nada más.** Contiene todas las funciones que usan sintaxis POSIX compatible con ambos shells.
