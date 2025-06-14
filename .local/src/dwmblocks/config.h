// dwmblocks - config.h
// Archivo de configuración para los bloques de la barra de estado.
// Modifica este archivo para cambiar los comandos y su comportamiento.
// Recompila con `sudo make install` después de guardar los cambios.

static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

	// =================================================================
	// Módulos del Sistema
	// =================================================================

	{"", "sb-cpubars",      1, 18}, // Barras de uso de CPU (reemplaza sb-cpu)
	//{"", "sb-memory",      10, 14}, // Memoria RAM utilizada
	{"", "sb-pacpackages",3600,  8}, // Paquetes de Arch para actualizar (revisión cada hora)
	{"", "sb-battery",      5,  3}, // Estado de la batería
	// {"", "sb-volume",       0, 10}, // Control de volumen (actualizado por señal)
	{"", "sb-mic",          0, 20}, // Estado del micrófono (actualizado por señal)

	// =================================================================
	// Módulos de Aplicaciones y Productividad
	// =================================================================

	{"", "sb-music",        0, 11}, // Reproductor de música (MPD/ncmpcpp)
	{"", "sb-tasks",       10, 26}, // Tareas en segundo plano (tsp)
	{"", "sb-mailbox",    180, 12}, // Correo sin leer
	{"", "sb-news",       300,  6}, // Noticias sin leer (newsboat)
	{"", "cat /tmp/recordingicon 2>/dev/null", 0, 9}, // Indicador de grabación de pantalla

	// =================================================================
	// Módulos de Información General y Teclado
	// =================================================================

	//{"", "sb-forecast", 18000,  5}, // Pronóstico del tiempo (actualización cada 5 horas)
	{"", "sb-keylocks",     0, 22}, // Indicador de Bloq Mayús / Bloq Num (actualizado por señal)
	// {"", "sb-keyboard",     0, 30}, // Distribución de teclado actual (actualizado por señal)
	{"", "sb-clock",       30,  1}, // Fecha y hora (actualización cada 30 segundos)

	// =================================================================
	// Módulos de Red e Internet
	// =================================================================

	{"", "sb-internet",     5,  4}, // Conectividad (WiFi/Ethernet)
	{"", "sb-vpn",          5,  7}, // Estado de la conexión VPN
	{"", "sb-nettraf",      1, 16}, // Tráfico de red (subida/bajada)

	// =================================================================
	// Módulos Adicionales (Descomenta para usar)
	// =================================================================

	/* {"", "sb-moonphase", 18000, 17}, */
	/* {"", "sb-torrent",     20,  7}, */
	/* {"", "sb-iplocate",      0, 27}, */
	/* {"", "sb-doppler",       0, 13}, */
	/* {"", "sb-price btc Bitcoin ₿ 21", 9000, 21}, */
	// {"", "sb-help-icon",     0, 15},

};

// Define el delimitador que separa cada bloque en la barra de estado.
// Un espacio con padding a cada lado suele verse bien.
// Si quieres que no haya delimitador, usa: static char *delim = "";
static char *delim = " ";

// Para que dwmblocks se recompile y reinicie automáticamente al guardar este
// archivo en vim/neovim, puedes añadir la siguiente línea a tu vimrc/init.vim:
//
// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/ && sudo make install && { killall -q dwmblocks; setsid dwmblocks & }
