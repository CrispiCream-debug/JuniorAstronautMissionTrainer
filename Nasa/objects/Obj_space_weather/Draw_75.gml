// Pantalla de titulo encima de todo (Draw GUI End: despues del HUD)
if (!title_active) {
    exit;
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();

// Fondo oscuro: la base se ve detras
draw_set_alpha(0.7);
draw_set_color(make_color_rgb(5, 5, 25));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Texto con contorno negro
function title_text(_x, _y, _text, _scale, _color, _outline) {
    draw_set_color(c_black);
    for (var _ox = -_outline; _ox <= _outline; _ox++) {
        for (var _oy = -_outline; _oy <= _outline; _oy++) {
            if (_ox != 0 || _oy != 0) {
                draw_text_transformed(_x + _ox, _y + _oy, _text, _scale, _scale, 0);
            }
        }
    }
    draw_set_color(_color);
    draw_text_transformed(_x, _y, _text, _scale, _scale, 0);
}

var _bob = sin(current_time * 0.002) * 4;
title_text(_gw / 2, _gh * 0.32 + _bob, "Junior Astronaut", 4, c_white, 3);
title_text(_gw / 2, _gh * 0.32 + 60 + _bob, "Mission Trainer", 3, make_color_rgb(255, 220, 60), 3);
title_text(_gw / 2, _gh * 0.32 + 120, "Protect the lunar base from real 2024 space weather", 1.3, make_color_rgb(200, 210, 255), 2);

// "Press Enter" parpadeando
if ((current_time div 500) mod 2 == 0) {
    title_text(_gw / 2, _gh * 0.72, "Press Enter to start", 2, c_white, 2);
}

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
