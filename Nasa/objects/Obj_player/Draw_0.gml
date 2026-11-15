var shadow_half_width = 7;
var shadow_half_height = 4;
var shadow_x = round(x);
var shadow_y = round(bbox_bottom) + 2;
var shadow_left = shadow_x - shadow_half_width;
var shadow_right = shadow_x + shadow_half_width;
var shadow_top = shadow_y - shadow_half_height;
var shadow_bottom = shadow_y + shadow_half_height;
var shadow_color = make_color_rgb(68, 58, 84);
var shadow_alpha = 0.35 * image_alpha;

draw_primitive_begin(pr_trianglefan);
draw_vertex_color(shadow_x, shadow_top, shadow_color, shadow_alpha);
draw_vertex_color(shadow_right, shadow_top, shadow_color, shadow_alpha);

// Las dos últimas filas se estrechan un píxel por lado en cada escalón.
draw_vertex_color(shadow_right, shadow_bottom - 2, shadow_color, shadow_alpha);
draw_vertex_color(shadow_right - 1, shadow_bottom - 2, shadow_color, shadow_alpha);
draw_vertex_color(shadow_right - 1, shadow_bottom - 1, shadow_color, shadow_alpha);
draw_vertex_color(shadow_right - 2, shadow_bottom - 1, shadow_color, shadow_alpha);
draw_vertex_color(shadow_right - 2, shadow_bottom, shadow_color, shadow_alpha);
draw_vertex_color(shadow_left + 2, shadow_bottom, shadow_color, shadow_alpha);
draw_vertex_color(shadow_left + 2, shadow_bottom - 1, shadow_color, shadow_alpha);
draw_vertex_color(shadow_left + 1, shadow_bottom - 1, shadow_color, shadow_alpha);
draw_vertex_color(shadow_left + 1, shadow_bottom - 2, shadow_color, shadow_alpha);
draw_vertex_color(shadow_left, shadow_bottom - 2, shadow_color, shadow_alpha);
draw_vertex_color(shadow_left, shadow_top, shadow_color, shadow_alpha);
draw_primitive_end();

draw_self();
