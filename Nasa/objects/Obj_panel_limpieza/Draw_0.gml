if (sprite_index != -1) {
    draw_self();
}

if (instance_exists(Obj_player) && estado != "listo") {
    if (point_distance(x, y, Obj_player.x, Obj_player.y) < 42) {
        var mas_cercano = instance_nearest(Obj_player.x, Obj_player.y, object_index);
        if (mas_cercano == id) {
            draw_set_color(c_yellow);
            draw_text(x - 10, y - 28, "[E]");
        }
    }
}