if (player_near) {
    draw_interaction_outline();
}

draw_self();

if (!instance_exists(Obj_space_weather) || array_length(Obj_space_weather.alerts) == 0) {
    exit;
}

// "!" encima de Frot mientras tenga alertas sin leer
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
var _bob = sin(current_time * 0.008) * 2;
draw_set_color(make_color_rgb(168, 24, 24));
draw_text_transformed(x, bbox_top - 2 + _bob, "!", 1.5, 1.5, 0);

if (player_near) {
    draw_set_color(c_white);
    draw_set_valign(fa_top);
    draw_text_transformed(x, bbox_bottom + 2, "[Enter]", 0.6, 0.6, 0);
}

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
