// Dibujar el sprite del panel si tiene uno asignado
if (sprite_index != -1) {
    draw_self();
}

// Mostrar el aviso [E] si el jugador está a menos de 60 píxeles
if (instance_exists(Obj_player) && point_distance(x, y, Obj_player.x, Obj_player.y) < 60 && estado != "listo") {
    draw_set_color(c_yellow);
    draw_text(x - 10, y - 30, "[E]");
}

if (sprite_index != -1) {
    // Cambiar ligeramente el color del panel en el mapa según su estado
    if (estado == "sucio") {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, make_color_rgb(190, 170, 140), 1);
    } else if (estado == "roto") {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, make_color_rgb(255, 120, 120), 1);
    } else {
        draw_self(); // Normal (limpio)
    }
}

// Dibujar un pequeño punto de alerta encima si está dañado
if (estado == "sucio") {
    draw_set_color(c_orange);
    draw_circle(x, y - 18, 4, false);
} else if (estado == "roto") {
    draw_set_color(c_red);
    draw_circle(x, y - 18, 4, false);
}

// Mostrar [E] al acercarse
if (instance_exists(Obj_player) && point_distance(x, y, Obj_player.x, Obj_player.y) < 60 && estado != "listo") {
    draw_set_color(c_yellow);
    draw_text(x - 10, y - 32, "[E]");
}