// 1. ACTUALIZAR FRAME FÍSICO Y MODIFICAR ENERGÍA SEGÚN EL ESTADO DE ESTE PANEL
if (estado == "listo") {
    image_index = 0; // Frame limpio
    if (instance_exists(Obj_player)) {
        Obj_player.energy_ = min(100, Obj_player.energy_ + 0.001);
    }
} 
else if (estado == "sucio") {
    image_index = 1; // Frame sucio
    if (instance_exists(Obj_player)) {
        Obj_player.energy_ = max(0, Obj_player.energy_ - 0.0015);
    }
} 
else if (estado == "roto") {
    image_index = 2; // Frame roto
    if (instance_exists(Obj_player)) {
        Obj_player.energy_ = max(0, Obj_player.energy_ - 0.003);
    }
}

// Asignar el frame exacto del sprite según su estado
// (Ajusta 0, 1, 2 si el orden de tus sub-imágenes es diferente)
if (estado == "listo") {
    image_index = 0; // Frame limpio
} else if (estado == "sucio") {
    image_index = 1; // Frame sucio
} else if (estado == "roto") {
    image_index = 2; // Frame roto
}

// Recargar energía pasivamente si el panel está limpio
if (estado == "listo" && instance_exists(Obj_player)) {
    Obj_player.energy_ = min(100, Obj_player.energy_ + 0.005);
}

// 2. El jugador abre el panel seleccionado desde su End Step.
if (!abierto) {
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
            
            porcentaje_limpio = min(100, porcentaje_limpio + 0.6);
            play_sfx_once([snd_glass_clean_1, snd_glass_clean_2, snd_glass_clean_3, snd_glass_clean_4, snd_glass_clean_5], 0.7);

            if (porcentaje_limpio >= 100) {
                estado = "listo";
                abierto = false;
                play_sfx(snd_success);
                if (instance_exists(Obj_player)) {
                    Obj_player.energy_ = min(100, Obj_player.energy_ + 15);
                }
                if (instance_exists(Obj_space_weather)) {
                    Obj_space_weather.unlock_award(Obj_box);  // premio: primer panel limpio
                }
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
                play_sfx([snd_screw_out_1, snd_screw_out_2, snd_screw_out_3, snd_screw_out_4]);
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
                play_sfx(snd_screw_in);
            }
        }
        if (tornillos_puestos[0] && tornillos_puestos[1] && tornillos_puestos[2] && tornillos_puestos[3]) {
            estado = "listo";
            abierto = false;
            play_sfx(snd_success);
            if (instance_exists(Obj_player)) {
                Obj_player.energy_ = min(100, Obj_player.energy_ + 20);
            }
            if (instance_exists(Obj_space_weather)) {
                Obj_space_weather.unlock_award(Obj_lunar_rover);  // premio: primer panel reparado
            }
        }
    }
}
