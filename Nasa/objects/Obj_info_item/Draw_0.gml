if (!unlocked) {
    exit;
}

if (player_near) {
    draw_interaction_outline();
}

draw_self();

if (!player_near || info_text == "") {
    exit;
}

// "[E]" debajo del objeto para indicar que se puede interactuar
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_transformed(x, bbox_bottom + 2, "[E]", 0.6, 0.6, 0);

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
