// 1. RECARGAR ENERGÍA DEL JUGADOR SI EL PANEL ESTÁ LIMPIO
if (estado == "listo" && instance_exists(Obj_player)) {
    // Cada panel limpio regenera energía poco a poco hasta un máximo de 100
    Obj_player.energy_ = min(100, Obj_player.energy_ + 0.03);
}

// 2. DETECTAR SI EL JUGADOR SE ACERCA Y PRESIONA "E"
if (!abierto) {
    if (instance_exists(Obj_player) && point_distance(x, y, Obj_player.x, Obj_player.y) < 60) {
        if (keyboard_check_pressed(ord("E")) && estado != "listo") {
            var otro_abierto = false;
            with (object_index) {
                if (abierto) otro_abierto = true;
            }
            if (!otro_abierto) {
                abierto = true;
            }
        }
    }
    exit;
}

// 3. CERRAR CON ESCAPE
if (keyboard_check_pressed(vk_escape)) {
    abierto = false;
}

var gui_x = (display_get_gui_width() / 2) - (ancho / 2);
var gui_y = (display_get_gui_height() / 2) - (alto / 2);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// 4. SI EL PANEL ESTÁ SUCIO -> MINIJUEGO DE LIMPIEZA
if (estado == "sucio") {
    if (mouse_check_button(mb_left)) {
        var local_x = mx - gui_x;
        var local_y = my - gui_y;
        
        if (local_x >= 0 && local_x <= ancho && local_y >= 0 && local_y <= alto) {
            if (surface_exists(surf_suciedad)) {
                surface_set_target(surf_suciedad);
                gpu_set_blendmode(bm_subtract);
                draw_circle(local_x, local_y, 14, false);
                gpu_set_blendmode(bm_normal);
                surface_reset_target();
            }
            
            // Gastar un poco de energía al limpiar
            if (instance_exists(Obj_player)) {
                Obj_player.energy_ = max(0, Obj_player.energy_ - 0.05);
            }
            
            porcentaje_limpio = min(100, porcentaje_limpio + 0.6);
            
            if (porcentaje_limpio >= 100) {
                estado = "listo";
                abierto = false;
            }
        }
    }
}

// 5. SI EL PANEL ESTÁ ROTO -> MINIJUEGO DE REEMPLAZO
else if (estado == "roto") {
    if (fase == 0 && mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < 4; i++) {
            if (tornillos_puestos[i] && point_distance(mx, my, gui_x + tornillos_x[i], gui_y + tornillos_y[i]) < 15) {
                tornillos_puestos[i] = false;
                if (instance_exists(Obj_player)) {
                    Obj_player.energy_ = max(0, Obj_player.energy_ - 1);
                }
            }
        }
        if (!tornillos_puestos[0] && !tornillos_puestos[1] && !tornillos_puestos[2] && !tornillos_puestos[3]) fase = 1;
    }
    else if (fase == 1 && mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mx, my, gui_x, gui_y, gui_x + ancho, gui_y + alto)) fase = 2;
    }
    else if (fase == 2) {
        var slot_x = gui_x + ancho + 30;
        var slot_y = gui_y + 20;
        if (mouse_check_button_pressed(mb_left) && paneles_repuesto > 0) {
            if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + 60, slot_y + 60)) arrastrando_panel = true;
        }
        if (arrastrando_panel && mouse_check_button_released(mb_left)) {
            arrastrando_panel = false;
            if (point_in_rectangle(mx, my, gui_x, gui_y, gui_x + ancho, gui_y + alto)) {
                paneles_repuesto -= 1;
                fase = 3;
            }
        }
    }
    else if (fase == 3 && mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < 4; i++) {
            if (!tornillos_puestos[i] && point_distance(mx, my, gui_x + tornillos_x[i], gui_y + tornillos_y[i]) < 15) {
                tornillos_puestos[i] = true;
                if (instance_exists(Obj_player)) {
                    Obj_player.energy_ = max(0, Obj_player.energy_ - 1);
                }
            }
        }
        if (tornillos_puestos[0] && tornillos_puestos[1] && tornillos_puestos[2] && tornillos_puestos[3]) {
            estado = "listo";
            abierto = false;
        }
    }
}