// Barra verd

if (instance_exists(Obj_player)) {
    var _vida = Obj_player.health_;
    var _frame = 0; // Frame por defecto (barra llena al 100%)

    if (_vida > 80) {
        _frame = 0; // 100% (5 cuadros llenos)
    } else if (_vida > 60) {
        _frame = 1; // 80% (4 cuadros)
    } else if (_vida > 40) {
        _frame = 2; // 60% (3 cuadros)
    } else if (_vida > 20) {
        _frame = 3; // 40% (2 cuadros)
    } else if (_vida > 0) {
        _frame = 4; // 20% (1 cuadro)
    } else {
        _frame = 5; // 0% (barra completamente vacía)
    }

    draw_sprite_ext(Sp_healthbar, _frame, 10, 10, 2.5, 2.5, 0, c_white, 1);

    // Valor actual a la derecha de la barra: rojo si esta bajando, verde si sube
    if (!variable_instance_exists(id, "shown_value")) {
        shown_value = _vida;
        shown_value_trend = 0;
    }
    if (_vida < shown_value - 0.0001) {
        shown_value_trend = 20;   // frames que se queda el color
    } else if (_vida > shown_value + 0.0001) {
        shown_value_trend = -20;
    } else if (shown_value_trend != 0) {
        shown_value_trend -= sign(shown_value_trend);
    }
    shown_value = _vida;

    var _prev_halign = draw_get_halign();
    var _prev_valign = draw_get_valign();
    var _prev_color = draw_get_color();
    var _texto = string(ceil(_vida));
    var _tx = 10 + sprite_get_width(Sp_healthbar) * 2.5 + 8;
    var _ty = 10 + sprite_get_height(Sp_healthbar) * 2.5 / 2;
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text_transformed(_tx - 1, _ty, _texto, 1.5, 1.5, 0);
    draw_text_transformed(_tx + 1, _ty, _texto, 1.5, 1.5, 0);
    draw_text_transformed(_tx, _ty - 1, _texto, 1.5, 1.5, 0);
    draw_text_transformed(_tx, _ty + 1, _texto, 1.5, 1.5, 0);
    draw_set_color(shown_value_trend > 0 ? make_color_rgb(255, 90, 80) : (shown_value_trend < 0 ? make_color_rgb(110, 255, 120) : c_white));
    draw_text_transformed(_tx, _ty, _texto, 1.5, 1.5, 0);
    draw_set_halign(_prev_halign);
    draw_set_valign(_prev_valign);
    draw_set_color(_prev_color);
}

