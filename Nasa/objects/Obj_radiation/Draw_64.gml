if (instance_exists(Obj_space_weather) && Obj_space_weather.radiation > 0) {
    var _target_size = 56;
    var _scale = _target_size / sprite_get_width(Sp_radiation);
    var _draw_w = sprite_get_width(Sp_radiation) * _scale;
    var _margin = 16;

    var _x = display_get_gui_width() - _draw_w - _margin + sprite_get_xoffset(Sp_radiation) * _scale;
    var _y = _margin + sprite_get_yoffset(Sp_radiation) * _scale;

    draw_sprite_ext(Sp_radiation, 0, _x, _y, _scale, _scale, 0, c_white, 1);
}
