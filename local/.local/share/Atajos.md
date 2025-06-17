# 📚 Cheatsheet Completo de Atajos y Programas de LARBS (Arch Linux + dwm)

Este documento resume los atajos de teclado, configuraciones y programas esenciales del entorno **LARBS**, basado en **Arch Linux**, con enfoque en el teclado, eficiencia y el uso de programas minimalistas y modulares.

> 🧠 **Principios de LARBS**: Naturalidad, economía de recursos, centralidad en el teclado (vim), descentralización de herramientas y total configurabilidad.

La tecla `Mod` por defecto es la **tecla Super (Windows)**. En la configuración predeterminada, `Capslock` está remapeado para actuar como `Escape` si se presiona solo, o como `Mod` si se mantiene presionado.

---

## 🪟 `dwm` — Gestor de Ventanas Dinámico

`dwm` (Dynamic Window Manager) organiza las ventanas en mosaico automáticamente, maximizando el uso de la pantalla y la eficiencia. Su configuración es mínima pero potente.

### 🧭 Navegación y Control de Ventanas

| Atajo | Acción |
| :--- | :--- |
| `Mod + Enter` | Abrir nueva terminal (`st`). |
| `Mod + q` | Cerrar la ventana actual. |
| `Mod + j` / `k` | Mover el foco entre ventanas según el orden de pila. |
| `Mod + Shift + j` / `k` | Reordenar ventana en la pila. |
| `Mod + Space` | Convertir ventana seleccionada en maestra. |
| `Mod + v` | Ir a la ventana maestra. |
| `Mod + f` | Pantalla completa para la ventana actual. |
| `Mod + Shift + Space` | Alternar modo flotante para ventana (usar clic izquierdo/derecho + Mod para mover/redimensionar). |
| `Mod + s` | Fijar ventana a todos los tags (sticky). |
| `Mod + b` | Ocultar o mostrar la barra de estado. |

---

### 🧱 Diseños de Ventanas (Layouts)

| Atajo | Acción |
| :--- | :--- |
| `Mod + t` | Activar modo de mosaico. |
| `Mod + T` | Modo pila inferior. |
| `Mod + F` | Modo flotante general. |
| `Mod + y` / `Y` | Layouts Fibonacci spiral / Dwindle. |
| `Mod + u` / `U` | Monocle con máster / monocle completo. |
| `Mod + i` / `I` | Centrar máster / centrar y flotar máster. |
| `Mod + o` / `O` | Aumentar / disminuir ventanas en máster. |
| `Mod + h` / `l` | Cambiar tamaño del máster (`mfact`). |
| `Mod + z` / `x` | Aumentar / disminuir gaps entre ventanas. |
| `Mod + a` / `A` | Ocultar gaps / Resetear a valores por defecto. |

---

### 🏷️ Tags (Espacios de trabajo)

| Atajo | Acción |
| :--- | :--- |
| `Mod + [1-9]` | Cambiar al tag especificado. |
| `Mod + Shift + [1-9]` | Enviar ventana al tag. |
| `Mod + Tab` | Volver al último tag. |
| `Mod + g` / `;` | Ir al tag anterior/siguiente. |
| `Mod + Shift + g` / `;` | Mover ventana a tag anterior/siguiente. |
| `Mod + Left/Right` | Cambiar de monitor. |
| `Mod + Shift + Left/Right` | Mover ventana a otro monitor. |

---

## ⚙️ Programas Principales Integrados

LARBS incluye software ligero, funcional y bien integrado con el teclado. A continuación se listan los principales y sus atajos.

| Atajo | Programa | Descripción |
| :--- | :--- | :--- |
| `Mod + r` | `lf` | Gestor de archivos estilo `ranger`, controlado por teclado (`vim`). |
| `Mod + Shift + r` | `htop` | Monitor de sistema interactivo. |
| `Mod + d` | `dmenu` | Lanza comandos rápidamente. |
| `Mod + Shift + d` | `passmenu` | Menú para acceder a contraseñas (`pass`). |
| `Mod + w` | `LibreWolf` | Navegador web centrado en privacidad. |
| `Mod + e` | `neomutt` | Cliente de correo terminal. Requiere configuración con `mw`. |
| `Mod + Shift + e` | `abook` | Libreta de contactos de terminal. |
| `Mod + n` | `vimwiki` | Sistema de notas personales en `vim`. |
| `Mod + Shift + n` | `newsboat` | Lector de RSS en terminal. |
| `Mod + m` | `ncmpcpp` | Reproductor de música (`mpd`). |
| `Mod + Shift + Enter` | Terminal desplegable. |
| `Mod + '` | Calculadora desplegable (`qalc` o `bc`). |

---

## 🔊 Multimedia y Audio

| Atajo | Acción |
| :--- | :--- |
| `Mod + p` | Pausar/Reanudar `mpd` y `mpv`. |
| `Mod + ,` / `.` | Canción anterior / siguiente. |
| `Mod + <` / `>` | Reiniciar pista / alternar repetición. |
| `Mod + M` | Silenciar todo el audio. |
| `Mod + -` / `+` | Bajar/subir volumen (Shift para salto mayor). |
| `Mod + [` / `]` | Retroceder / avanzar 10 seg (Shift: 1 min). |
| `Mod + F4` | Abrir `pulsemixer` (control de volumen detallado). |

---

## 🖼️ Capturas y Grabación de Pantalla

| Atajo | Acción |
| :--- | :--- |
| `PrintScreen` | Captura de pantalla completa. |
| `Shift + PrintScreen` | Captura de área seleccionada. |
| `Mod + PrintScreen` | Menú para grabar video/audio del escritorio. |
| `Mod + Delete` | Detiene grabación activa. |
| `Mod + Shift + c` | Activa webcam para grabaciones (esquina inferior derecha). |
| `Mod + ScrollLock` | Activa `screenkey` para mostrar teclas en pantalla. |

---

## 🖥️ `st` — Terminal Simple

Terminal ultraligera y rápida. Integrada con atajos de navegación tipo `vim`.

| Atajo | Acción |
| :--- | :--- |
| `Alt + j` / `k` | Desplazamiento en el historial. |
| `Alt + u` / `d` | AvPág / RePág en scroll. |
| `Alt + Shift + j/k` | Cambia tamaño de fuente. |
| `Alt + l` / `y` | Extrae y copia URLs visibles. |
| `Alt + o` | Copia salida del último comando. |
| `Shift + Insert` | Pega texto desde portapapeles. |

---

## 📁 `lf` — File Manager

| Atajo | Acción |
| :--- | :--- |
| `h/j/k/l` | Navegación tipo `vim`. |
| `g` / `G` | Ir al principio / final. |
| `w` | Abre terminal en el directorio actual. |
| `b` (sobre imagen) | Establece fondo de pantalla (`setbg`). |
| `Espacio` | Selección múltiple de archivos. |
| `y/d/p` | Copiar / Cortar / Pegar archivos. |
| `B` | Renombrado masivo con `vidir`. |

---

## 📬 `neomutt` — Cliente de Correo Terminal

Gestión offline/IMAP en terminal usando `mutt-wizard`.

| Atajo | Acción |
| :--- | :--- |
| `j/k` | Moverse por los correos. |
| `Enter` / `l` | Abrir correo. |
| `h` / `Esc` | Volver al índice. |
| `m` | Redactar correo. |
| `r` / `R` | Responder / responder a todos. |
| `d` | Marcar para borrar. |
| `g + [i/d/s/a/j]` | Ir a carpeta: inbox, drafts, sent, archive, junk. |
| `M + [letra]` | Mover correo a carpeta. |
| `C + [letra]` | Copiar correo. |

---

## 📹 `mpv` — Reproductor de Video

| Atajo | Acción |
| :--- | :--- |
| `Espacio` | Pausar/Reanudar. |
| `h/l` | Retroceder / avanzar 10 seg. |
| `j/k` | Retroceder / avanzar 1 min. |
| `o/O` | Mostrar barra de progreso. |
| `S` | Cambiar subtítulos. |

---

## 🛠️ Configuración y Personalización

- Archivos de configuración: `~/.config/`
- Código fuente (dwm, dmenu, st): `~/.local/src/`
- Scripts del sistema: `~/.local/bin/`
- Wallpaper: establecer con `setbg` o `b` desde `lf`.
- DPI: editar `~/.xprofile` con `xrandr --dpi`.
- Colores: editar `~/.config/x11/xresources`.
- Email: configurar con `mw -a correo@ejemplo.com`.
- Música: agregar a `~/Music` y ejecutar `mpc update`.

---

## 📌 Enlaces de Referencia

- [GitHub de LARBS](https://github.com/LukeSmithxyz/LARBS)
- [Documentación de `st`](https://github.com/lukesmithxyz/st)
- [Página de Luke Smith](https://lukesmith.xyz)
