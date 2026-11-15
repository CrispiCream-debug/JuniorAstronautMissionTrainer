// La posición de la instancia coincide con el suelo que se ve en el editor.
cover_offset_x = (sprite_get_width(domo_floor) - sprite_get_width(domo_door)) / 2;
cover_offset_y = sprite_get_bbox_bottom(domo_floor) - sprite_get_bbox_bottom(domo_door);
floor_layer = layer_create(depth);
floor_element = layer_sprite_create(floor_layer, x, y, domo_floor);

function update_dome_layers() {
    var cos_angle = dcos(image_angle);
    var sin_angle = dsin(image_angle);
    // Separa el suelo y la cubierta por todo el tramo donde pueden quedar los pies.
    var width_y = -sprite_get_bbox_right(domo_floor) * image_xscale * sin_angle;
    var height_y = sprite_get_bbox_bottom(domo_floor) * image_yscale * cos_angle;
    var back_y = y + min(0, width_y) + min(0, height_y);
    var front_y = y + max(0, width_y) + max(0, height_y);
    layer_depth(floor_layer, 1 - floor(back_y));
    depth = -ceil(front_y) - 1;

    layer_sprite_x(floor_element, x);
    layer_sprite_y(floor_element, y);
    layer_sprite_xscale(floor_element, image_xscale);
    layer_sprite_yscale(floor_element, image_yscale);
    layer_sprite_angle(floor_element, image_angle);
    layer_sprite_blend(floor_element, image_blend);
    layer_sprite_alpha(floor_element, image_alpha);
    layer_set_visible(floor_layer, visible);
}

update_dome_layers();
