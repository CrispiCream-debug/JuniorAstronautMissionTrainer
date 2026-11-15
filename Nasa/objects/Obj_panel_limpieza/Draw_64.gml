// Si este panel no está abierto, NO dibuja nada en pantalla
if (!abierto) exit;

var gui_x = (display_get_gui_width() / 2) - (ancho / 2);
var gui_y = (display_get_gui_height() / 2) - (alto / 2);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Fondo oscuro de ventana
draw_set_color(make_color_rgb(35, 25, 55));
draw_rectangle(gui_x - 30, gui_y - 45, gui_x + ancho + 110, gui_y + alto + 50, false);

// --- DIBUJAR MINIJUEGO DE LIMPIEZA ---
if (estado == "sucio") {
    if (!surface_exists(surf_suciedad)) {
        surf_suciedad = surface_create(ancho, alto);
        surface_set_target(surf_suciedad);
        draw_clear(make_color_rgb(130, 110, 90));
        surface_reset_target();
    }
    draw_set_color(make_color_rgb(45, 110, 210));
    draw_rectangle(gui_x, gui_y, gui_x + ancho, gui_y + alto, false);
    draw_surface(surf_suciedad, gui_x, gui_y);
    
    draw_set_color(c_white);
    draw_text(gui_x - 10, gui_y - 30, "LIMPIEZA (" + string(floor(porcentaje_limpio)) + "%)");
    draw_text(gui_x - 10, gui_y + alto + 15, "Arrastra el clic para limpiar | ESC: Salir");
}

// --- DIBUJAR MINIJUEGO DE REEMPLAZO ---
else if (estado == "roto") {
    draw_set_color(c_white);
    draw_text(gui_x - 10, gui_y - 30, "REEMPLAZO DE PANEL");
    
    if (fase == 0 || fase == 1) {
        draw_set_color(make_color_rgb(160, 45, 55));
        draw_rectangle(gui_x, gui_y, gui_x + ancho, gui_y + alto, false);
        draw_set_color(c_red);
        draw_line(gui_x + 20, gui_y + 10, gui_x + 130, gui_y + 140);
        draw_line(gui_x + 140, gui_y + 20, gui_x + 30, gui_y + 130);
    } else if (fase == 2) {
        draw_set_color(c_black);
        draw_rectangle(gui_x, gui_y, gui_x + ancho, gui_y + alto, false);
    } else if (fase == 3) {
        draw_set_color(make_color_rgb(45, 110, 210));
        draw_rectangle(gui_x, gui_y, gui_x + ancho, gui_y + alto, false);
    }
    
    for (var i = 0; i < 4; i++) {
        if (tornillos_puestos[i]) {
            draw_set_color(c_silver);
            draw_circle(gui_x + tornillos_x[i], gui_y + tornillos_y[i], 7, false);
        } else if (fase == 3) {
            draw_set_color(c_yellow);
            draw_circle(gui_x + tornillos_x[i], gui_y + tornillos_y[i], 7, true);
        }
    }
    
    // Slot de repuestos
    var slot_x = gui_x + ancho + 30;
    var slot_y = gui_y + 20;
    draw_set_color(c_gray);
    draw_rectangle(slot_x, slot_y, slot_x + 60, slot_y + 60, false);
    if (paneles_repuesto > 0) {
        draw_set_color(make_color_rgb(45, 110, 210));
        draw_rectangle(slot_x + 8, slot_y + 8, slot_x + 52, slot_y + 52, false);
    }
    draw_set_color(c_white);
    draw_text(slot_x - 5, slot_y + 68, "Stock: " + string(paneles_repuesto));
    
    var msg = ["1. Quita 4 tornillos", "2. Clic panel roto", "3. Arrastra repuesto", "4. Pon 4 tornillos"][fase];
    draw_text(gui_x - 10, gui_y + alto + 15, msg + " | ESC: Salir");
    
    if (arrastrando_panel) {
        draw_set_color(make_color_rgb(45, 110, 210));
        draw_rectangle(mx - 40, my - 40, mx + 40, my + 40, false);
    }
}