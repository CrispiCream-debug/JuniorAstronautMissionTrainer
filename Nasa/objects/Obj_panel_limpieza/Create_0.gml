abierto = false; // El minijuego empieza cerrado


image_speed = 0;
image_index = 0; // Forzar frame limpio al iniciar
estado = "listo"; // Forzar estado perfecto al iniciar

image_speed = 0; // Detener reproducción automática de frames

// Variables de limpieza
ancho = 160;
alto = 160;
surf_suciedad = -1;
porcentaje_limpio = 0;

// Variables de reemplazo
fase = 0;
arrastrando_panel = false;
paneles_repuesto = 3;
tornillos_x = [15, ancho - 15, 15, ancho - 15];
tornillos_y = [15, 15, alto - 15, alto - 15];
tornillos_puestos = [true, true, true, true];

// Temporizador para deterioro (60 pasos = 1 segundo aprox. Aquí son 30 segundos)
alarm[0] = room_speed * irandom_range(20, 45);

image_speed = 0;
image_index = 0;
estado = "listo";
abierto = false;
alarm[0] = room_speed * irandom_range(45, 90);

// Cada panel tardará un tiempo distinto en empezar a ensuciarse (ej. entre 15 y 40 segundos)
alarm[0] = room_speed * irandom_range(15, 40);

// Dimensiones y variables de los minijuegos
ancho = 220;
alto = 160;
surf_suciedad = -1;
porcentaje_limpio = 0;

fase = 0;
tornillos_puestos = [true, true, true, true];
tornillos_x = [20, ancho - 20, 20, ancho - 20];
tornillos_y = [20, 20, alto - 20, alto - 20];
paneles_repuesto = 99;
arrastrando_panel = false;