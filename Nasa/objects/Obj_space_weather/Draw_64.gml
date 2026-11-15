// Proximos eventos (solo los que Frot ya conto), a la derecha debajo del HUD
if (array_length(told) > 0) {
    var _sorted = array_create(array_length(told));
    array_copy(_sorted, 0, told, 0, array_length(told));
    array_sort(_sorted, function(_a, _b) { return _a.time - _b.time; });

    var _lines = "Next events:";
    for (var _i = 0; _i < min(4, array_length(_sorted)); _i++) {
        _lines += "\n" + string(max(0, ceil(_sorted[_i].time - clock))) + "s  " + event_label(_sorted[_i].event);
    }

    var _prev_q_halign = draw_get_halign();
    var _prev_q_valign = draw_get_valign();
    var _prev_q_color = draw_get_color();
    var _qx = display_get_gui_width() - 16;
    var _qy = 150;
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    for (var _ox = -1; _ox <= 1; _ox++) {
        for (var _oy = -1; _oy <= 1; _oy++) {
            if (_ox != 0 || _oy != 0) {
                draw_text(_qx + _ox, _qy + _oy, _lines);
            }
        }
    }
    draw_set_color(c_white);
    draw_text(_qx, _qy, _lines);
    draw_set_halign(_prev_q_halign);
    draw_set_valign(_prev_q_valign);
    draw_set_color(_prev_q_color);
}

// Premio desbloqueado: letras blancas con contorno negro, sin cuadro, arriba al centro
if (award_timer <= 0 || award_text == "") {
    exit;
}

var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();

var _tx = display_get_gui_width() / 2;
var _ty = 110;
var _scale = 1.6;
var _sep = string_height("Ay") * 1.15;

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_alpha(min(1, award_timer / 0.5));  // se desvanece el ultimo medio segundo

draw_set_color(c_black);
for (var _ox = -2; _ox <= 2; _ox++) {
    for (var _oy = -2; _oy <= 2; _oy++) {
        if (_ox != 0 || _oy != 0) {
            draw_text_ext_transformed(_tx + _ox, _ty + _oy, award_text, _sep, -1, _scale, _scale, 0);
        }
    }
}
draw_set_color(c_white);
draw_text_ext_transformed(_tx, _ty, award_text, _sep, -1, _scale, _scale, 0);

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
