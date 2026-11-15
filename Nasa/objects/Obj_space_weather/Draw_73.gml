// Apagon: oscurece el mundo (el HUD se dibuja despues, en Draw GUI)
if (!blackout || !view_enabled || view_camera[0] == -1) {
    exit;
}

var _cam = view_camera[0];
var _vx = camera_get_view_x(_cam);
var _vy = camera_get_view_y(_cam);
var _prev_alpha = draw_get_alpha();
var _prev_color = draw_get_color();

draw_set_alpha(0.45 + sin(current_time * 0.004) * 0.05);  // parpadeo leve
draw_set_color(make_color_rgb(5, 5, 25));
draw_rectangle(_vx, _vy, _vx + camera_get_view_width(_cam), _vy + camera_get_view_height(_cam), false);

draw_set_alpha(_prev_alpha);
draw_set_color(_prev_color);
