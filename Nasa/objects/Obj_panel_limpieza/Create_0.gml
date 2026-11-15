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


image_speed = 0;
image_index = 0;
estado = "listo";
abierto = false;


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
// Ya no se danan al azar: Obj_space_weather llama esto cuando llega una llamarada o tormenta.
// Limpio -> sucio; sucio (o _break) -> roto. Devuelve si cambio.
function hit_by_sun(_break) {
    if (abierto || estado == "roto") {
        return false;
    }
    if (_break || estado == "sucio") {
        estado = "roto";
        fase = 0;
        tornillos_puestos = [true, true, true, true];
    } else {
        estado = "sucio";
        porcentaje_limpio = 0;
        if (surface_exists(surf_suciedad)) {
            surface_free(surf_suciedad);
            surf_suciedad = -1;
        }
    }
    return true;
}
