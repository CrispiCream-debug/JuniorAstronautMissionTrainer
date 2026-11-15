if (instance_exists(Obj_player)) {
    var _energia = Obj_player.energy_;
    var _frame = 0; // Frame por defecto (barra llena al 100%)

    if (_energia > 75) {
        _frame = 0; // 100% (4 cuadros llenos)
    } else if (_energia > 50) {
        _frame = 1; // 75% (3 cuadros)
    } else if (_energia > 25) {
        _frame = 2; // 50% (2 cuadros)
    } else if (_energia > 0) {
        _frame = 3; // 25% (1 cuadro)
    } else {
        _frame = 4; // 0% (barra completamente vacía)
    }

    var _scale = 2.5;
    var _left_x = 10 + sprite_get_xoffset(Sp_energybar) * _scale;
    draw_sprite_ext(Sp_energybar, _frame, _left_x, 100, _scale, _scale, 0, c_white, 1);

    // Valor actual a la derecha de la barra: rojo si esta bajando, verde si sube
    if (!variable_instance_exists(id, "shown_value")) {
        shown_value = _energia;
        shown_value_trend = 0;
    }
    if (_energia < shown_value - 0.0001) {
        shown_value_trend = 20;   // frames que se queda el color
    } else if (_energia > shown_value + 0.0001) {
        shown_value_trend = -20;
    } else if (shown_value_trend != 0) {
        shown_value_trend -= sign(shown_value_trend);
    }
    shown_value = _energia;

    var _prev_halign = draw_get_halign();
    var _prev_valign = draw_get_valign();
    var _prev_color = draw_get_color();
    var _texto = string(ceil(_energia));
    var _tx = _left_x + (sprite_get_width(Sp_energybar) - sprite_get_xoffset(Sp_energybar)) * _scale + 8;
    var _ty = 100 + (sprite_get_height(Sp_energybar) / 2 - sprite_get_yoffset(Sp_energybar)) * _scale;
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