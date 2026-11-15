if (!variable_instance_exists(id, "baterias_recogidas")) {
    baterias_recogidas = 0;
}

// Más centrada debajo del triángulo verde y más despegada verticalmente
var _gui_x = display_get_gui_width() - 64;
var _gui_y = 74;

var _spr_bat = object_get_sprite(Obj_battery_container);
var _centro_x = _gui_x;
var _abajo_y  = _gui_y;

if (sprite_exists(_spr_bat)) {
    draw_sprite(_spr_bat, 0, _gui_x, _gui_y);
    
    // Calcula el centro exacto en X y la base en Y de la cajita
    _centro_x = _gui_x - sprite_get_xoffset(_spr_bat) + (sprite_get_width(_spr_bat) / 2);
    _abajo_y  = _gui_y - sprite_get_yoffset(_spr_bat) + sprite_get_height(_spr_bat);
}

var _prev_valign = draw_get_valign();
var _prev_halign = draw_get_halign();
var _prev_color  = draw_get_color();

draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _texto  = "x" + string(baterias_recogidas);
// Durante un aviso o apagon muestra cuantas faltan para la consola
if (instance_exists(Obj_space_weather) && Obj_space_weather.batteries_available()) {
    _texto = string(min(Obj_space_weather.batteries_delivered, Obj_space_weather.batteries_needed))
        + "/" + string(Obj_space_weather.batteries_needed);
}
var _tx     = _centro_x;
var _ty     = _abajo_y + 4;
var _escala = 1.3; // <-- Cambia este valor: > 1 más grande (ej. 1.3, 1.5), < 1 más pequeño (ej. 0.8)

// 1. Contorno negro (4 direcciones)
draw_set_color(c_black);
draw_text_transformed(_tx - 1, _ty, _texto, _escala, _escala, 0);
draw_text_transformed(_tx + 1, _ty, _texto, _escala, _escala, 0);
draw_text_transformed(_tx, _ty - 1, _texto, _escala, _escala, 0);
draw_text_transformed(_tx, _ty + 1, _texto, _escala, _escala, 0);

// 2. Relleno blanco encima
draw_set_color(c_white);
draw_text_transformed(_tx, _ty, _texto, _escala, _escala, 0);

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);

// Flecha hacia la consola mientras carga una bateria
if (bateria_cargada != noone && instance_exists(Obj_console) && view_enabled && view_camera[0] != -1) {
    var _cam = view_camera[0];
    var _sx = display_get_gui_width() / camera_get_view_width(_cam);
    var _sy = display_get_gui_height() / camera_get_view_height(_cam);
    var _px = (x - camera_get_view_x(_cam)) * _sx;
    var _py = (y - 12 - camera_get_view_y(_cam)) * _sy;
    var _consola = instance_nearest(x, y, Obj_console);

    if (distance_to_object(_consola) >= 24) {  // ya en la consola no hace falta
        var _dir = point_direction(x, y, _consola.x, _consola.y);
        var _bob = sin(current_time * 0.01) * 3;
        var _dist = 46 + _bob;
        var _ax = _px + lengthdir_x(_dist, _dir);
        var _ay = _py + lengthdir_y(_dist, _dir);
        var _len = 14;
        var _half = 9;

        var _tip_x = _ax + lengthdir_x(_len, _dir);
        var _tip_y = _ay + lengthdir_y(_len, _dir);
        var _l_x = _ax + lengthdir_x(_half, _dir + 90);
        var _l_y = _ay + lengthdir_y(_half, _dir + 90);
        var _r_x = _ax + lengthdir_x(_half, _dir - 90);
        var _r_y = _ay + lengthdir_y(_half, _dir - 90);

        var _prev_arrow_color = draw_get_color();
        draw_set_color(c_black);
        draw_triangle(_tip_x + lengthdir_x(3, _dir), _tip_y + lengthdir_y(3, _dir),
            _l_x + lengthdir_x(3, _dir + 90) - lengthdir_x(2, _dir), _l_y + lengthdir_y(3, _dir + 90) - lengthdir_y(2, _dir),
            _r_x + lengthdir_x(3, _dir - 90) - lengthdir_x(2, _dir), _r_y + lengthdir_y(3, _dir - 90) - lengthdir_y(2, _dir), false);
        draw_set_color(make_color_rgb(255, 220, 60));
        draw_triangle(_tip_x, _tip_y, _l_x, _l_y, _r_x, _r_y, false);
        draw_set_color(_prev_arrow_color);
    }
}
