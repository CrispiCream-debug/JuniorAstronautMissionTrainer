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
}

