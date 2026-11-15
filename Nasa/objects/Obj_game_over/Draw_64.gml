var _width = display_get_gui_width();
var _height = display_get_gui_height();
var _scale = min(_width / 1366, _height / 768);
var _center_x = _width / 2;
var _title_y = _height * 0.10;
var _score_y = _height * 0.19;
var _restart_y = _height * 0.90;

var _old_color = draw_get_color();
var _old_alpha = draw_get_alpha();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();
var _old_font = draw_get_font();
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1);

draw_set_color(make_color_rgb(25, 18, 47));
draw_text_transformed(_center_x, _title_y + 3 * _scale, "GAME OVER", 4 * _scale, 4 * _scale, 0);
draw_text_transformed(_center_x, _score_y + 2 * _scale, survival_text, 2 * _scale, 2 * _scale, 0);

draw_set_alpha(0.84);
draw_roundrect(_center_x - 145 * _scale, _restart_y - 23 * _scale,
    _center_x + 145 * _scale, _restart_y + 23 * _scale, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 235, 192));
draw_text_transformed(_center_x, _title_y, "GAME OVER", 4 * _scale, 4 * _scale, 0);
draw_set_color(c_white);
draw_text_transformed(_center_x, _score_y, survival_text, 2 * _scale, 2 * _scale, 0);
draw_text_transformed(_center_x, _restart_y, "Press Enter to restart", 1.6 * _scale, 1.6 * _scale, 0);

draw_set_font(_old_font);
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
