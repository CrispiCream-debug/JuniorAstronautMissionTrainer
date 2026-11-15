var selected = !abierto && instance_exists(Obj_player) && Obj_player.selected_panel == id;

if (sprite_index != -1) {
    if (selected) {
        draw_interaction_outline();
    }

    var panel_color = image_blend;
    if (estado == "sucio") {
        panel_color = make_color_rgb(190, 170, 140);
    } else if (estado == "roto") {
        panel_color = make_color_rgb(255, 120, 120);
    }
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, panel_color, image_alpha);
}

// Dibujar un pequeño punto de alerta encima si está dañado
var previous_color = draw_get_color();
if (estado == "sucio") {
    draw_set_color(c_orange);
    draw_circle(x, y - 18, 4, false);
} else if (estado == "roto") {
    draw_set_color(c_red);
    draw_circle(x, y - 18, 4, false);
}

if (selected) {
    draw_set_color(c_yellow);
    draw_text(x - 10, y - 32, "[E]");
}
draw_set_color(previous_color);
