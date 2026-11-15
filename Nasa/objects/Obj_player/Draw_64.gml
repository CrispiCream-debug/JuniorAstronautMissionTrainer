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