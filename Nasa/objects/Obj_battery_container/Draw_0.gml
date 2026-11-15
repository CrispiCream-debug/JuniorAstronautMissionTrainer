// 1. Dibuja el sprite normal de la batería
draw_self();

// 2. Si NO la están cargando y el jugador está cerca, dibuja "[E]" debajo
if (!siendo_cargada && instance_exists(Obj_player)) {
    if (point_distance(x, y, Obj_player.x, Obj_player.y) < 64) {
        
        // Guarda la alineación y color actuales para no afectar otros objetos
        var _prev_halign = draw_get_halign();
        var _prev_color  = draw_get_color();
        
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        
        // Dibuja el texto "[E]" debajo de la batería (ajusta el + 20 si lo quieres más arriba o abajo)
        draw_text(x, y + 25, "[E]");
        
        // Restaura la configuración original
        draw_set_halign(_prev_halign);
        draw_set_color(_prev_color);
    }
}