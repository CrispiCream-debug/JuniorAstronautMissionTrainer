// Si el panel estaba limpio y no lo estás reparando ahora mismo, se ensucia o se rompe
if (estado == "listo" && !abierto) {
    estado = choose("sucio", "roto");

    // Reiniciar variables del minijuego según el nuevo estado
    if (estado == "sucio") {
        porcentaje_limpio = 0;
        if (surface_exists(surf_suciedad)) {
            surface_free(surf_suciedad);
            surf_suciedad = -1;
        }
    } else if (estado == "roto") {
        fase = 0;
        tornillos_puestos = [true, true, true, true];
    }
}

// Volver a programar la alarma para más adelante
alarm[0] = room_speed * irandom_range(25, 50);