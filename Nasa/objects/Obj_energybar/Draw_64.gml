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
}