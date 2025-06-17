# Mi Configuración de Neovim "Modo DIOS"

Este es mi manual de usuario personal para mi configuración de Neovim, diseñada para ser un entorno de desarrollo completo, rápido y eficiente que reemplaza a VS Code.

## Filosofía

Esta configuración se basa en `vim-plug` como gestor de plugins, manteniendo la simplicidad de tener un archivo de configuración principal (`init.vim`) pero integrando el poder de plugins modernos escritos en Lua. El objetivo es combinar la estabilidad de un sistema clásico con la velocidad y funcionalidades del ecosistema moderno de Neovim.

---

## 🏛️ Estructura de Carpetas

Para que esta configuración funcione, solo necesitas respaldar los siguientes archivos en tus dotfiles. El resto se genera automáticamente.

```bash
~/.config/nvim/
├── autoload/
│   └── plug.vim    # El gestor de plugins. Esencial.
├── init.vim        # El corazón de la configuración. Aquí vive todo.
└── shortcuts.vim   # Tus atajos personalizados (cargado desde init.vim).
```

**IMPORTANTE:** La carpeta `plugged/` **NO** debe ser incluida en tu repositorio. Contiene el código de los plugins y se puede regenerar en cualquier momento. Añade `plugged/` a tu archivo `.gitignore`.

---

## 🔌 Gestión de Plugins con `vim-plug`

Usamos `vim-plug`, un gestor de plugins minimalista y muy confiable.

### Mantenimiento de Plugins

Todo se hace con comandos dentro de Neovim:

* **:PlugInstall**: Instala los plugins que hayas añadido a tu `init.vim`.
* **:PlugUpdate**: Actualiza todos tus plugins a su última versión.
* **:PlugClean**: Desinstala los plugins que hayas borrado o comentado en tu `init.vim`.
* **:PlugStatus**: Muestra una lista de todos tus plugins y su estado actual.

### ¿Cómo Añadir un Nuevo Plugin?

1.  Busca el plugin que quieres en GitHub (por ejemplo, `usuario/repo-del-plugin`).
2.  Abre tu `init.vim`.
3.  Ve a la sección de `PLUGIN MANAGER (VIM-PLUG)`.
4.  Añade una nueva línea con `Plug 'usuario/repo-del-plugin'`.
5.  Guarda el archivo (`:w`).
6.  Ejecuta `:PlugInstall` para instalarlo.
7.  Si el plugin requiere configuración, añádela en la sección de `PLUGIN CONFIGURATION`.

---

## 🚀 Plugins Instalados y su Función

Aquí está la lista de todos los superpoderes que le hemos añadido a tu Neovim.

### Interfaz y Apariencia (UI)

* **`catppuccin/nvim`**: El tema de colores principal (Mocha). Se encarga de que todo se vea chido y uniforme.
* **`nvim-tree/nvim-tree.lua`**: Un explorador de archivos moderno que reemplaza a NERDTree. Es más rápido y se integra con Git.
* **`nvim-web-devicons`**: Muestra iconos bonitos para cada tipo de archivo en `nvim-tree`.
* **`nvim-lualine/lualine.nvim`**: Una barra de estado súper ligera y personalizable que te da información útil.
* **`lewis6991/gitsigns.nvim`**: Muestra indicadores visuales en la columna de la izquierda para las líneas que has añadido (`+`), modificado (`~`) o borrado (`-`).

### Funcionalidad del Editor

* **`tpope/vim-surround`**: Un clásico para añadir, cambiar y borrar "alrededores" (comillas, paréntesis, etiquetas HTML, etc.) de forma súper rápida.
* **`junegunn/goyo.vim`**: Modo "zen" o "sin distracciones" para escribir prosa o Markdown.
* **`numToStr/Comment.nvim`**: Para comentar y descomentar líneas o bloques de código de forma inteligente, usando el estilo de comentario correcto para cada lenguaje.

### Búsqueda y Navegación

* **`nvim-telescope/telescope.nvim`**: ¡La joya de la corona! Es un buscador "difuso" (fuzzy finder) que te permite encontrar cualquier cosa al instante. Reemplaza `Ctrl+P` y `Ctrl+Shift+F` de VS Code.
* **`nvim-lua/plenary.nvim`**: Una librería de funciones de Lua que es una dependencia obligatoria para Telescope y muchos otros plugins modernos.

### Git

* **`TimUntersberger/neogit`**: Un cliente de Git súper completo inspirado en Magit de Emacs. Te da una interfaz para hacer todo tu trabajo de Git sin salir de Neovim.

### Desarrollo y "Superpoderes" de IDE

* **`nvim-treesitter/nvim-treesitter`**: El motor de resaltado de sintaxis más avanzado. Entiende la estructura de tu código, no solo las palabras, lo que resulta en colores mucho más precisos y útiles.
* **`norcalli/nvim-colorizer.lua`**: Resalta los códigos de color (ej. `#FFFFFF`, `rgb(0,0,0)`) con su color real.
* **`neovim/nvim-lspconfig`**: El plugin oficial para configurar los **Language Servers (LSP)**.
* **`williamboman/mason.nvim`**: Un gestor de paquetes de LSP. Se encarga de instalar, actualizar y gestionar los "cerebros" que analizan tu código.
* **`williamboman/mason-lspconfig.nvim`**: El puente que conecta a Mason con `lspconfig` para automatizar la configuración.
* **`hrsh7th/nvim-cmp`**: El motor de autocompletado. Es modular y súper rápido.
* **`cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`**: Fuentes de sugerencias para `nvim-cmp`. Toman sugerencias del LSP, de las palabras que ya están en tus archivos abiertos (buffers) y de las rutas de tu sistema.
* **`L3MON4D3/LuaSnip` y `cmp_luasnip`**: El motor de "snippets" (plantillas de código) y su integración con el autocompletado.

### Asistente de IA

* **`jackMort/ChatGPT.nvim`**: Una integración completa con ChatGPT. Te permite chatear, pedir que edite código, que lo explique, etc.
* **`MunifTanjim/nui.nvim`**: Una librería de componentes de UI, es una dependencia para que ChatGPT.nvim pueda crear sus ventanas y popups.

---

## ⌨️ Tabla de Atajos de Teclado

Aquí tienes tu "acordeón" personal con los atajos más importantes. Tu tecla líder (leader) es la **coma (`,`)**.

| Atajo | Acción | Plugin |
| :--- | :--- | :--- |
| **Navegación General** | | |
| `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | Moverse entre splits (ventanas) | Neovim |
| **Telescope (Búsqueda)** | | |
| `,ff` | **Buscar Archivos** en el proyecto | Telescope |
| `,fg` | **Buscar Texto** en todo el proyecto | Telescope |
| `,fb` | Buscar en los buffers (archivos) abiertos | Telescope |
| `,fh` | Buscar en la ayuda de Neovim | Telescope |
| **Herramientas de Código** | | |
| `,n` | Abrir/cerrar el explorador de archivos | nvim-tree |
| `,gg` | Abrir la interfaz de **Neogit** | Neogit |
| `gd` | Ir a la **definición** de la variable/función | LSP |
| `gr` | Mostrar todas las **referencias** | LSP |
| `K` (mayús+k) | Mostrar documentación contextual (hover) | LSP |
| `,rn` | **Renombrar** variable/función en todo el proyecto | LSP |
| `,e` | Mostrar diagnósticos/errores en la línea actual | LSP |
| **Utilidades Varias** | | |
| `,f` | Activar/desactivar modo de escritura **Goyo** | Goyo |
| `,o` | Activar/desactivar corrector ortográfico | Neovim |
| `,v` | Abrir el índice de **Vimwiki** | vimwiki |
| `,s` | Revisar script actual con **ShellCheck** | Neovim |
| `,c` | Compilar documento (`:!compiler`) | Neovim |
| `,p` | Previsualizar salida (`:!opout`) | Neovim |
| `,h` | Ocultar/Mostrar elementos de la UI | Neovim |
