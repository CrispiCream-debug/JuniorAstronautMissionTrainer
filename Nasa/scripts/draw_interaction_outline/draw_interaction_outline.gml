function draw_interaction_outline() {
    if (sprite_index == -1 || !shader_is_compiled(Sh_interaction_outline)) {
        return;
    }

    var outline_color = make_color_rgb(255, 240, 168);
    var outline_radius = 2;
    shader_set(Sh_interaction_outline);
    for (var offset_y = -outline_radius; offset_y <= outline_radius; offset_y++) {
        var row_radius = outline_radius - abs(offset_y);
        for (var offset_x = -row_radius; offset_x <= row_radius; offset_x++) {
            if (offset_x == 0 && offset_y == 0) {
                continue;
            }
            draw_sprite_ext(sprite_index, image_index, x + offset_x, y + offset_y,
                image_xscale, image_yscale, image_angle, outline_color, image_alpha);
        }
    }
    shader_reset();
}
