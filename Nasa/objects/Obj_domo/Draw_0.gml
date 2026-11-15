var local_x = cover_offset_x * image_xscale;
var local_y = cover_offset_y * image_yscale;
var cos_angle = dcos(image_angle);
var sin_angle = dsin(image_angle);
var cover_x = x + local_x * cos_angle + local_y * sin_angle;
var cover_y = y - local_x * sin_angle + local_y * cos_angle;

draw_sprite_ext(domo_vegetation, 0, cover_x, cover_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(domo_glass, 0, cover_x, cover_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(domo_door, 0, cover_x, cover_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
