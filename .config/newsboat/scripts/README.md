# 🚀 Gallery Tool v5.0

Un script de shell robusto y extensible diseñado para extraer, descargar y visualizar galerías de imágenes y videos desde cualquier URL, con soporte especializado para sitios complejos.

## ✨ Características Principales

* **Arquitectura Modular Inteligente:** El script utiliza un "cerebro" central (`reglas/generic.sh`) que carga dinámicamente "módulos" de reglas (`*-module.sh`) para añadir soporte a sitios específicos sin necesidad de modificar el código principal.
* **Renombrado para Orden Natural:** ¡Se acabaron las galerías desordenadas! Los archivos se renombran automáticamente con un prefijo numérico (ej. `001_foto.jpg`, `002_foto.jpg`) para garantizar que siempre se muestren en el orden correcto, tanto en la galería HTML como en visores de imágenes como `nsxiv`.
* **Descarga de Galería Completa:** Genera automáticamente un archivo `.zip` con todo el contenido de la galería para una descarga fácil y cómoda con un solo clic desde la página HTML.
* **Caché Simple y Eficaz:** Crea directorios predecibles basados en la URL (`/tmp/gallery-tool/sitio.com/galeria`). Si el directorio ya existe, se salta la descarga y muestra el contenido local inmediatamente, incluyendo los archivos ya renombrados y el `.zip`.
* **Limpieza Automática Post-Descarga:** Elimina automáticamente imágenes pequeñas como avatares, iconos y banners basándose en sus dimensiones (requiere `ImageMagick`).
* **Extracción Multi-Sitio:** Funciona en la mayoría de los sitios web gracias a un extractor genérico y robusto basado en `pup`.
* **Soporte Especializado Avanzado:**
    * **Reddit:** Utiliza un navegador headless (`chromium`) para sobrepasar protecciones y extraer galerías complejas.
* **Dos Modos de Visualización:**
    * `--html`: Genera una elegante galería HTML local, moderna y responsiva, con contador de archivos y botón de descarga.
    * `--nsxiv`: Lanza las imágenes descargadas (ya ordenadas) directamente en el visor de imágenes `nsxiv`.
* **Descargas Paralelas:** Utiliza `xargs` para descargar múltiples archivos de forma simultánea, acelerando significativamente el proceso.
* **Logging Detallado:** Proporciona logs informativos con emojis para seguir cada paso del proceso y depurar fácilmente.

---

## 🏗️ Estructura del Proyecto

La arquitectura modular facilita enormemente la expansión:

```
.
├── 📜 gallery-tool.sh         # El lanzador principal.
├── 🛠️ gallery-functions.sh    # La caja de herramientas con funciones compartidas.
├── 🖼️ gallery-template.html   # La plantilla visual para la galería HTML.
└── 📁 reglas/
    ├── 🧠 generic.sh           # El CEREBRO: orquesta la extracción y carga módulos.
    ├── 👽 reddit-module.sh      # Módulo con la lógica especial para Reddit.
```

---

## ⚙️ Instalación y Dependencias

Para que el script funcione en su totalidad, necesitas las siguientes herramientas:

* **Esenciales:** `curl`, `wget`, `pup`, `sed`, `zip`.
* **Para Limpieza por Dimensiones (Recomendado):** `imagemagick` (que provee el comando `identify`).
* **Para Extracción Avanzada (JS y Reddit):** Un navegador basado en `chromium`.
* **Para Visualización Alternativa (Opcional):** `nsxiv`.

**Comando de instalación (ejemplo para Arch Linux):**

```bash
sudo pacman -S curl wget pup sed imagemagick chromium nsxiv zip gawk
```

## **Uso**

### **Uso Básico**

`bash gallery-tool.sh [OPCIONES] <URL>`

### **Ejemplos Prácticos**

* **Extraer una galería con ordenamiento y ZIP:**
    ```bash
    # El script descargará, renombrará, creará un .zip y mostrará la galería HTML.
    bash gallery-tool.sh "URL_DEL_SITIO"
    ```

* **Extraer una galería de Reddit:**
    ```bash
    bash gallery-tool.sh "[https://www.reddit.com/gallery/123abc](https://www.reddit.com/gallery/123abc)"
    ```

* **Usar la caché:**
    ```bash
    # La primera vez descargará y procesará todo.
    bash gallery-tool.sh "URL_DEL_SITIO"

    # La segunda vez, abrirá la galería ordenada al instante.
    bash gallery-tool.sh "URL_DEL_SITIO"
    ```

* **Ver con `nsxiv`:**
    ```bash
    # Las imágenes se abrirán en nsxiv ya en orden numérico correcto.
    bash gallery-tool.sh --nsxiv "URL_DEL_SITIO"
    ```
---

## **🎓 Lecciones Aprendidas (La Bitácora del Detective)**

El camino para estabilizar la v5 fue una clase magistral de scripting en Bash. Estas son las lecciones clave que nos hicieron más fuertes:

1.  **El Peligro de `set -e` con Tuberías (`|`):** Aprendimos a la mala que `set -e` es muy estricto. Si un comando en una tubería como `pup | grep` falla (porque no encuentra nada), todo el script se detiene. La solución fue añadir `|| true` al final de las tuberías críticas para "atrapar" el error y permitir que el script continúe.
2.  **La Diferencia Vital entre `$0` y `$BASH_SOURCE`:** `$0` siempre se refiere al script principal que se ejecutó, mientras que `$BASH_SOURCE` se refiere al archivo actual. Este conocimiento fue crucial para arreglar la carga dinámica de módulos, que buscaba en la carpeta equivocada.
3.  **La Fragilidad de `command -v` para Funciones:** Descubrimos que `command -v mi_funcion` no es fiable para saber si una función existe, especialmente cuando ha sido cargada con `source`. El método a prueba de balas es `declare -f mi_funcion`.
4.  **No Borres de una Lista Mientras la Recorres:** El error clásico. Nuestro primer intento de limpiar archivos basura se congelaba porque el bucle `for file in *.jpg` se confundía cuando borrábamos un archivo de esa misma lista. La solución fue hacer un primer recorrido para *anotar* qué borrar, y un segundo recorrido para *borrar* lo anotado.
5.  **Pasa las Dependencias de Forma Explícita:** La fuente de la URL y la ruta a la plantilla se perdían en la cadena de llamadas. La solución fue dejar de pasar la URL como argumento y guardarla en un archivo `.source_url`, y pasar la ruta del script (`$SCRIPT_DIR`) explícitamente a las funciones que la necesitaban.

---

## **🗺️ Hoja de Ruta para el Futuro**

Con una base sólida y estable, el futuro es brillante. Aquí está el plan de acción para las siguientes versiones:

### **Fase 1: Mejoras de Usabilidad y Orden (¡Completada!)**

* **[Renombrado Inteligente]:** ¡Hecho! Los archivos se renombran para un orden natural.
* **[Mejoras a la Galería HTML]:** ¡Hecho! Se añadió contador de imágenes y botón de descarga ZIP.

### **Fase 2: Caché Avanzada y Rendimiento**

* **[Sistema de Caché por Hash]:** Ir más allá de la simple comprobación de directorios.
    * **Lógica:** Antes de descargar una URL, obtener su `Content-Length` (tamaño del archivo). Guardar en un archivo de manifiesto (ej. `.manifest.txt`) dentro de la carpeta de la galería una línea por cada archivo: `nombre_del_archivo.jpg|123456_bytes`.
    * **Ventaja:** Si volvemos a ejecutar el script y una imagen ya existe con el mismo tamaño, podemos saltar la descarga de forma segura. Esto abre la puerta a "actualizar" galerías sin volver a bajar todo.

### **Fase 3: Expansión de Capacidades**

* **[Integración con `yt-dlp`]:** Para URLs que son claramente de video (YouTube, Vimeo, etc.), en lugar de intentar extraerlas manualmente, delegar la tarea a `yt-dlp`, que es la herramienta definitiva para ello. Esto se puede añadir como otra condición en el "cerebro" `generic.sh`.
* **[Soporte para Más Sitios]:** Usando nuestra nueva y flamante arquitectura de módulos, será trivial añadir soporte para sitios como Imgur, Flickr, etc., creando nuevos archivos `sitio-module.sh`.
