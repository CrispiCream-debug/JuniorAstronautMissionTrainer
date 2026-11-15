// Si Frot no se ve en pantalla y tiene alertas, un "!" en el borde indica hacia donde esta
if (instance_exists(Obj_player) && Obj_player.health_ <= 0) {
    exit;
}

if (!instance_exists(Obj_space_weather) || array_length(Obj_space_weather.alerts) == 0) {
    exit;
}
if (!view_enabled || view_camera[0] == -1) {
    exit;
}

var _cam = view_camera[0];
var _vx = camera_get_view_x(_cam);
var _vy = camera_get_view_y(_cam);
var _vw = camera_get_view_width(_cam);
var _vh = camera_get_view_height(_cam);
if (point_in_rectangle(x, y, _vx, _vy, _vx + _vw, _vy + _vh)) {
    exit;
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _margin = 28;
var _gx = clamp((x - _vx) / _vw * _gw, _margin, _gw - _margin);
var _gy = clamp((y - _vy) / _vh * _gh, _margin, _gh - _margin);

var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(168, 24, 24));
draw_circle(_gx, _gy, 16, false);
draw_set_color(c_white);
draw_text_transformed(_gx, _gy, "!", 2, 2, 0);

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
