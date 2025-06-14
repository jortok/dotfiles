# Guía de Configuración Modular para Zsh y Bash

Este documento explica la estructura y el flujo de carga de la configuración para los shells Zsh y Bash, diseñada para ser modular, potente y fácil de mantener.

## Filosofía y Objetivos

1.  **Zsh como Shell Principal:** La experiencia en Zsh es la más rica y completa, con un prompt mejorado y un sistema de autocompletado superior.
2.  **Bash como Alternativa Funcional:** Bash hereda toda la configuración compartida (alias, funciones, variables) para ser una alternativa consistente y útil cuando sea necesaria.
3.  **Hogar Limpio (`~/`):** Se minimiza el número de "dotfiles" en el directorio home. La configuración principal reside en `~/.config/`.
4.  **Modularidad:** La lógica se separa en archivos con propósitos específicos para evitar la duplicación y facilitar las modificaciones. Un alias se cambia en un solo lugar (`shared_aliases.sh`) y el cambio se aplica a ambos shells.

## Estructura Final de Archivos

```
/home/toku/
├── .bashrc                     <-- Punto de entrada para Bash
└── .config/
    ├── zsh/
    │   ├── .zshenv             <-- Punto de entrada para variables de entorno de Zsh
    │   └── .zshrc              <-- Punto de entrada para Zsh interactivo
    └── shell/
        ├── README.md           <-- (Este archivo)
        ├── shared_env.sh       <-- (Variables de entorno para AMBOS shells)
        ├── shared_aliases.sh   <-- (Aliases para AMBOS shells)
        ├── shared_functions.sh <-- (Funciones para AMBOS shells)
        ├── bash_specific.sh    <-- (Orquestador principal de Bash)
        ├── zsh_specific.sh     <-- (Orquestador principal de Zsh)
        ├── zsh_prompt.zsh      <-- (Toda la lógica del prompt de Zsh)
        └── completions/
            └── ...             <-- (Scripts de autocompletado para Bash, como kubetail.bash)
```

## Resumen de Configuraciones Clave

Para una referencia rápida, aquí están algunos de los alias, funciones y variables más importantes definidos en los archivos compartidos.

### Variables de Entorno (`shared_env.sh`)

| Variable          | Propósito                                             |
| ----------------- | ----------------------------------------------------- |
| `EDITOR`          | Define `nvim` como el editor de texto por defecto.    |
| `PATH`            | Incluye `~/.local/bin`, `~/bin` y las rutas de Go.     |
| `HISTSIZE`        | Aumenta el tamaño del historial de comandos.          |
| `XDG_*`           | Estandariza las rutas de configuración, datos y caché.|
| `DOCKER_CONFIG`   | Apunta la configuración de Docker a `~/.config/docker`.|

### Alias (`shared_aliases.sh`)

| Alias      | Comando Original                                           | Propósito                                       |
|------------|------------------------------------------------------------|-------------------------------------------------|
| `config`   | `/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME` | **Esencial:** Gestiona tus dotfiles con Git.    |
| `l`, `la`, `ll` | `ls -lFh`, etc.                                        | Atajos para diferentes formatos de listado.     |
| `g`        | `git`                                                      | Atajo para Git.                                 |
| `k`        | `kubectl` o `kubecolor`                                    | Atajo para Kubernetes.                          |
| `dcu`, `dcd` | `docker-compose up -d`, `docker-compose down`              | Atajos para iniciar y detener Docker Compose.   |
| `..`, `...`  | `cd ..`, `cd ../..`                                        | Navegación rápida hacia directorios superiores. |

### Funciones (`shared_functions.sh`)

| Función   | Propósito                                                        |
|-----------|------------------------------------------------------------------|
| `mkcd`    | Crea un directorio y entra en él (`mkdir -p "$1" && cd "$1"`). |
| `server`  | Inicia un servidor web simple en el directorio actual.           |
| `dclean`  | Limpia contenedores, imágenes y volúmenes de Docker no usados.   |
| `fs`      | Muestra el tamaño de un archivo o directorio de forma legible.   |
| `tre`     | Muestra un árbol de directorios ignorando `node_modules`, etc.   |
| `isup`    | Comprueba si una página web está en línea.                       |

## Flujo de Carga y Propósito de Cada Archivo

### Zsh (El Shell Principal)

1.  **`~/.config/zsh/.zshenv`** -> Llama a `shared_env.sh`
2.  **`~/.config/zsh/.zshrc`** -> Llama a `zsh_specific.zsh`
3.  **`zsh_specific.zsh`** -> Orquesta los módulos de alias, funciones y el prompt.

### Bash (El Shell Alternativo)

1.  **`~/.bashrc`** -> Llama a `bash_specific.sh`
2.  **`bash_specific.sh`** -> Orquesta los módulos compartidos y la configuración de Bash.
