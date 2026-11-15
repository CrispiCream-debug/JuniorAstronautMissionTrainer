abierto = false; // El minijuego empieza cerrado
estado = choose("sucio", "roto"); // Cada panel empieza sucio o roto al azar

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