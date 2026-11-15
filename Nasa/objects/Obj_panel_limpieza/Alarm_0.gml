if (!abierto) {
    if (estado == "listo") {
        // Paso 1: Primero se ensucia
        estado = "sucio";
        porcentaje_limpio = 0;
        if (surface_exists(surf_suciedad)) {
            surface_free(surf_suciedad);
            surf_suciedad = -1;
        }
    } 
    else if (estado == "sucio") {
        // Paso 2: Si sigue sucio y no lo limpiaste, termina rompiéndose
        estado = "roto";
        fase = 0;
        tornillos_puestos = [true, true, true, true];
    }
}

// Tiempo antes de volver a revisar este panel (entre 50 y 80 segundos)
alarm[0] = room_speed * irandom_range(50, 80);
