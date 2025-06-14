# Mis Scripts para dwmblocks

¡Bienvenido a mi colección de scripts personalizados para `dwmblocks`! Este repositorio contiene una serie de módulos para la barra de estado de `dwm`, diseñados para ser minimalistas, eficientes y altamente funcionales. Cada script está pensado para proveer información útil de un vistazo y permitir interacciones rápidas a través de clics del ratón.

![Imagen de una barra de estado de dwm con varios bloques activos](https://placehold.co/800x40/1e1e2e/cdd6f4?text=dwmblocks+|+%F0%9F%94%8A+%7C+%F0%9F%8C%90+%7C+%F0%9F%93%A1%E2%86%9189%25+%7C+%F0%9F%94%8A%E2%86%9330%25+%7C+%F0%9F%95%90+14%3A20)

---

## 📋 Características

- **Modularidad:** Cada función es un script independiente, fácil de añadir, quitar o modificar.
- **Eficiencia:** Escritos en `sh` (POSIX) siempre que es posible para un rendimiento óptimo.
- **Interactividad:** La mayoría de los módulos responden a clics del ratón para mostrar más información o ejecutar acciones.
- **Personalización:** Uso extensivo de variables de entorno (`$TERMINAL`, `$EDITOR`) para adaptarse a tu configuración.
- **Estándares XDG:** Respeto por la estructura de directorios XDG para archivos de caché y configuración.

---

## ⚙️ Instalación y Dependencias

### Requisitos Generales

1.  **dwmblocks:** El motor que ejecuta estos scripts.
2.  **Fuente Nerd Font:** Necesaria para mostrar correctamente los íconos (ej. Fira Code Nerd Font, JetBrains Mono Nerd Font).
3.  **libnotify:** Para mostrar las notificaciones emergentes (`notify-send`).
4.  **Terminal:** Una terminal configurada en la variable de entorno `$TERMINAL` (ej. `st`, `alacritty`).
5.  **Editor:** Un editor de texto configurado en la variable de entorno `$EDITOR` (ej. `vim`, `neovim`).
6.  **dmenu:** Usado por varios scripts para menús interactivos.
7.  **xdotool:** Requerido por el script `sb-keylocks` para simular pulsaciones de teclas.

### Configuración

1.  Clona o copia estos scripts a un directorio en tu `PATH`, por ejemplo `~/.local/bin/statusbar/`.
2.  Asegúrate de que todos los scripts tengan permisos de ejecución:
    ```bash
    chmod +x ~/.local/bin/statusbar/*
    ```
3.  Edita el archivo `config.h` de tu `dwmblocks` para añadir los módulos que desees.
4.  Recompila `dwmblocks`:
    ```bash
    cd /ruta/a/tu/dwmblocks
    sudo make install
    ```
5.  Reinicia `dwm` para ver los cambios.

---

## 📜 Módulos Disponibles

A continuación se detalla cada uno de los scripts disponibles.

### Sistema y Hardware

---

#### `sb-cpubars`
Muestra la carga de cada núcleo del CPU como una serie de barras que cambian de altura, similar a Polybar.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                |
| ----------------- | -------------------- | ------------------------------------- |
| `🪨 ▂▄ ▆█`         | `Clic de en medio`   | Abre `htop` en una nueva terminal.    |
|                   | `Clic derecho`       | Muestra una notificación de ayuda.    |
|                   | `Shift + Clic`       | Abre el script en tu `$EDITOR`.       |

---

#### `sb-memory`
Muestra la memoria RAM utilizada sobre el total disponible.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                     |
| ----------------- | -------------------- | ------------------------------------------ |
| `🧠2.15GiB/7.76GiB` | `Clic izquierdo`     | Muestra los procesos que más RAM consumen. |
|                   | `Clic de en medio`   | Abre `htop`.                               |
|                   | `Clic derecho`       | Muestra una notificación de ayuda.         |

**Dependencias:** `free` (parte de `procps-ng`).

---

#### `sb-volume`
Controla y muestra el nivel de volumen actual del sistema usando `amixer`.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                 |
| ----------------- | -------------------- | -------------------------------------- |
| `🔊80%` / `🔇`    | `Scroll arriba`      | Sube el volumen.                       |
|                   | `Scroll abajo`       | Baja el volumen.                       |
|                   | `Clic de en medio`   | Silencia/activa el volumen (toggle).   |

**Dependencias:** `amixer` (parte de `alsa-utils`).

---

#### `sb-mic`
Indica si el micrófono (fuente de captura) está activo o silenciado.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                |
| ----------------- | -------------------- | ------------------------------------- |
| `🎤` / `🔇`       | `Clic izquierdo`     | Silencia/activa el micrófono (toggle). |
|                   | `Clic derecho`       | Muestra una notificación de ayuda.    |

**Dependencias:** `amixer` (parte de `alsa-utils`).

---

#### `sb-battery`
Muestra el estado y porcentaje de carga de todas las baterías conectadas.

| Salida de Ejemplo    | Interacción (Clic)   | Acción                               |
| -------------------- | -------------------- | ------------------------------------ |
| `🔋85%` / `🔌100%`   | `Scroll arriba/abajo`| Sube/baja el brillo de la pantalla.  |
|                      | `Clic derecho`       | Muestra una notificación de ayuda.   |

**Dependencias:** `xbacklight`.

---

#### `sb-brightness`
Muestra el nivel de brillo actual de la pantalla.

| Salida de Ejemplo | Interacción (Clic)   | Acción                             |
| ----------------- | -------------------- | ---------------------------------- |
| `💡 75%`          | `Clic derecho`       | Muestra una notificación de ayuda. |

---

#### `sb-disk`
Muestra el espacio en disco utilizado para un punto de montaje específico (por defecto `/`).

| Salida de Ejemplo | Interacción (Clic)   | Acción                                    |
| ----------------- | -------------------- | ----------------------------------------- |
| `🖥: 50G/220G`     | `Clic izquierdo`     | Muestra el uso de todos los discos.       |

---

### Red e Internet

---

#### `sb-internet`
Detecta y muestra el estado de la conexión de red actual de forma inteligente, priorizando Ethernet sobre Wi-Fi.

| Salida de Ejemplo         | Interacción (Clic)   | Acción                                    |
| ------------------------- | -------------------- | ----------------------------------------- |
| `🌐 enp2s0`               | `Clic izquierdo`     | Abre `nmtui` para gestionar conexiones.   |
| `📶 MiRed 89%`             | `Clic derecho`       | Muestra una notificación de ayuda.        |
| `📡 Desconectado`         |                      |                                           |

**Dependencias:** `nmtui`, `iwgetid`.

---

#### `sb-vpn`
Controla y muestra el estado de una conexión VPN gestionada por NetworkManager.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                    |
| ----------------- | -------------------- | ----------------------------------------- |
| `🟢` / `🔴`         | `Clic izquierdo`     | Conecta/desconecta la VPN.                |

**Dependencias:** `nmcli` (NetworkManager).

---

#### `sb-nettraf`
Muestra el tráfico de red de subida (🔺) y bajada (🔻) desde la última actualización.

| Salida de Ejemplo   | Interacción (Clic)   | Acción                              |
| ------------------- | -------------------- | ----------------------------------- |
| `🔻 1.2K B 🔺 345 B` | `Clic izquierdo`     | Abre `bmon` para un monitoreo detallado. |

---

### Productividad y Aplicaciones

---

#### `sb-pacpackages`
Muestra el número de paquetes de Arch Linux que se pueden actualizar.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                    |
| ----------------- | -------------------- | ----------------------------------------- |
| `📦12`            | `Clic izquierdo`     | Inicia la actualización con `yay -Syu`.   |
|                   | `Clic de en medio`   | Muestra la lista de paquetes a actualizar.|

**Dependencias:** `pacman`, `yay` (opcional).

---

#### `sb-music`
Muestra la canción que se está reproduciendo en MPD.

| Salida de Ejemplo               | Interacción (Clic)   | Acción                                     |
| ------------------------------- | -------------------- | ------------------------------------------ |
| `Artista - Título de la Canción` | `Clic izquierdo`     | Abre `ncmpcpp`.                            |
|                                 | `Clic de en medio`   | Pausa/reanuda la reproducción.             |
|                                 | `Scroll arriba/abajo`| Cambia a la canción anterior/siguiente.    |

**Dependencias:** `mpc`, `ncmpcpp`.

---

#### `sb-mailbox`
Cuenta y muestra el número de correos sin leer en un directorio de Maildir.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                    |
| ----------------- | -------------------- | ----------------------------------------- |
| `📬5`             | `Clic izquierdo`     | Abre `neomutt`.                           |
|                   | `Clic de en medio`   | Sincroniza los correos con `mbsync`.      |

**Dependencias:** `neomutt`, `mbsync`.

---

#### `sb-news`
Muestra el número de artículos de noticias sin leer de `newsboat`.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                    |
| ----------------- | -------------------- | ----------------------------------------- |
| `📰28`            | `Clic izquierdo`     | Abre `newsboat`.                          |
|                   | `Clic de en medio`   | Sincroniza los feeds RSS.                 |

**Dependencias:** `newsboat`.

---

#### `sb-torrent`
Muestra el estado de los torrents que se están gestionando con `transmission`.

| Salida de Ejemplo         | Interacción (Clic)   | Acción                                    |
| ------------------------- | -------------------- | ----------------------------------------- |
| `⬇️2 🌱1 🛑3`              | `Clic izquierdo`     | Abre la interfaz de terminal `stig`.      |
|                           | `Clic de en medio`   | Inicia/detiene el demonio de transmission.|

**Dependencias:** `transmission-cli`, `stig`.

---

### Información y Teclado

---

#### `sb-clock`
Muestra la fecha y la hora actual, con un ícono de reloj que cambia cada hora.

| Salida de Ejemplo              | Interacción (Clic)   | Acción                                     |
| ------------------------------ | -------------------- | ------------------------------------------ |
| `2025-06-14 w24.6 🕑14:20`      | `Clic izquierdo`     | Muestra el calendario y citas de `calcurse`.|
|                                | `Clic de en medio`   | Abre `calcurse`.                           |

**Dependencias:** `calcurse` (opcional).

---

#### `sb-keyboard`
Muestra la distribución de teclado actual y permite cambiarla.

| Salida de Ejemplo | Interacción (Clic)   | Acción                                    |
| ----------------- | -------------------- | ----------------------------------------- |
| `⌨️ ES` / `⌨️ US`   | `Clic izquierdo`     | Abre `dmenu` para seleccionar otro layout.|

**Dependencias:** `setxkbmap`, `dmenu`.

---

#### `sb-keylocks`
Indica si las teclas de Bloqueo de Mayúsculas y Bloqueo Numérico están activadas.

| Salida de Ejemplo   | Interacción (Clic)   | Acción                                   |
| ------------------- | -------------------- | ---------------------------------------- |
| `🅰️` / `🔢` / `🅰️ 🔢` | `Clic izquierdo`     | Activa/desactiva el Bloqueo de Mayúsculas.|
|                     | `Clic de en medio`   | Activa/desactiva el Bloqueo Numérico.    |

**Dependencias:** `xset`, `xdotool`.

---

#### `sb-forecast`
Muestra el pronóstico del tiempo para tu ubicación.

| Salida de Ejemplo        | Interacción (Clic)   | Acción                                    |
| ------------------------ | -------------------- | ----------------------------------------- |
| `☔10% 🥶15° 🌞25°`      | `Clic izquierdo`     | Muestra el reporte completo en `less`.    |
|                          | `Clic de en medio`   | Fuerza la actualización del pronóstico.   |

**Dependencias:** `curl`.
