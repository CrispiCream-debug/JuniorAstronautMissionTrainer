if (!instance_exists(Obj_space_weather)) {
    exit;
}

// Solo durante un evento con radiacion (los que vienen salen en la lista de proximos eventos)
if (Obj_space_weather.radiation <= 0) {
    exit;
}

var _target_size = 56;
var _scale = _target_size / sprite_get_width(Sp_radiation);
var _draw_w = sprite_get_width(Sp_radiation) * _scale;
var _draw_h = sprite_get_height(Sp_radiation) * _scale;
var _margin = 16;

var _x = display_get_gui_width() - _draw_w - _margin + sprite_get_xoffset(Sp_radiation) * _scale;
var _y = _margin + sprite_get_yoffset(Sp_radiation) * _scale;

// Animar los 4 frames
var _fps_anim = 8; // 8 frames por segundo
var _frame = floor((current_time / 1000) * _fps_anim) % 4;

draw_sprite_ext(Sp_radiation, _frame, _x, _y, _scale, _scale, 0, c_white, 1);

// Nivel de radiacion a la izquierda del icono
var _texto = string(round(Obj_space_weather.radiation));
var _tx = _x - sprite_get_xoffset(Sp_radiation) * _scale - 8;
var _ty = _y - sprite_get_yoffset(Sp_radiation) * _scale + _draw_h / 2;

var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(_tx - 1, _ty, _texto, 1.3, 1.3, 0);
draw_text_transformed(_tx + 1, _ty, _texto, 1.3, 1.3, 0);
draw_text_transformed(_tx, _ty - 1, _texto, 1.3, 1.3, 0);
draw_text_transformed(_tx, _ty + 1, _texto, 1.3, 1.3, 0);
draw_set_color(make_color_rgb(255, 230, 60));
draw_text_transformed(_tx, _ty, _texto, 1.3, 1.3, 0);
draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
