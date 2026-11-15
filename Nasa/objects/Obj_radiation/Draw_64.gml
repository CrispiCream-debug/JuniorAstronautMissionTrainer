if (instance_exists(Obj_space_weather) && Obj_space_weather.radiation > 0) {
    var _target_size = 56;
    var _scale = _target_size / sprite_get_width(Sp_radiation);
    var _draw_w = sprite_get_width(Sp_radiation) * _scale;
    var _margin = 16;

    var _x = display_get_gui_width() - _draw_w - _margin + sprite_get_xoffset(Sp_radiation) * _scale;
    var _y = _margin + sprite_get_yoffset(Sp_radiation) * _scale;

    // Animar los 4 frames (ajusta 0.008 para cambiar la velocidad)
    var _fps_anim = 8; // 8 frames por segundo
    var _frame = floor((current_time / 1000) * _fps_anim) % 4;

    draw_sprite_ext(Sp_radiation, _frame, _x, _y, _scale, _scale, 0, c_white, 1);
}