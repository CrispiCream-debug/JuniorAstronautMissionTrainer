if (health_ <= 0 || defeated) {
    if (!defeated) {
        defeated = true;
        health_ = 0;
        hor = 0;
        ver = 0;
        update_sprite();
        image_speed = 0;
        selected_panel = noone;

        global.game_over_days = 0;
        if (instance_exists(Obj_space_weather)) {
            global.game_over_days = floor(Obj_space_weather.survival_seconds / Obj_space_weather.day_seconds + 0.000001);
        }

        with (Obj_dialogue) {
            instance_destroy();
        }
        with (Obj_panel_limpieza) {
            abierto = false;
            arrastrando_panel = false;
        }
        rescue_frot = instance_nearest(x, y, Obj_frot);
        if (rescue_frot != noone) {
            rescue_frot.start_rescue(id, movement_obstacles);
        }
    }

    if (defeat_dialogue != noone) {
        if (!instance_exists(defeat_dialogue)) {
            room_goto(game_over_room);
        }
    } else if (!instance_exists(rescue_frot) || rescue_frot.rescue_arrived) {
        defeat_dialogue = instance_create_depth(0, 0, 0, Obj_dialogue, {
            text: "Your mission is over, rookie. We're heading back home.",
            auto_close: 5,
        });
    }

} else {
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
}

with (all) {
    if (object_index != Obj_domo) {
        depth = -bbox_bottom;
    }
}
