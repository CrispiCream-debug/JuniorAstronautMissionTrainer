var previous_panel = selected_panel;
var closest_panel = noone;
var closest_distance = 8;
var panel_open = false;

with (Obj_panel_limpieza) {
    if (abierto) {
        panel_open = true;
    }
    if (!visible || estado == "listo") {
        continue;
    }

    var panel_distance = distance_to_object(other.id);
    if (panel_distance <= closest_distance
        && (panel_distance < closest_distance || closest_panel == noone || id == previous_panel)) {
        closest_panel = id;
        closest_distance = panel_distance;
    }
}

selected_panel = panel_open ? noone : closest_panel;
if (instance_exists(Obj_space_weather) && Obj_space_weather.title_active) {
    selected_panel = noone;
}
if (selected_panel != noone && keyboard_check_pressed(ord("E"))) {
    selected_panel.abierto = true;
    selected_panel = noone;
}

with (all) {
    if (object_index != Obj_domo) {
        depth = -bbox_bottom;
    }
}
