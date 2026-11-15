var selected = !abierto && instance_exists(Obj_player) && Obj_player.selected_panel == id;

if (sprite_index != -1) {
    if (selected) {
        draw_interaction_outline();
    }
    draw_self(); // El frame (limpio/sucio/roto) ya indica el estado
}

if (selected) {
    var previous_color = draw_get_color();
    draw_set_color(c_yellow);
    draw_text(x - 10, y - 28, "[E]");
    draw_set_color(previous_color);
}
