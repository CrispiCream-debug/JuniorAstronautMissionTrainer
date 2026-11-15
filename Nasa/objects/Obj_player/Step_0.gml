if (defeated || health_ <= 0) {
    exit;
}

in_dome = place_meeting(x, y, Obj_domo);

// No moverse mientras alguien habla
var _blocked = instance_exists(Obj_space_weather) && Obj_space_weather.title_active;
with (Obj_dialogue) {
    if (blocking) {
        _blocked = true;
    }
}
if (_blocked) {
    hor = 0;
    ver = 0;
    update_sprite();
    exit;
}

// La energía baja constantemente sola
if (instance_exists(Obj_player)) {
    // Obj_player.energy_ = max(0, Obj_player.energy_ - 0.005);
}

hor = (keyboard_check(ord("D")) || keyboard_check(vk_right))
    - (keyboard_check(ord("A")) || keyboard_check(vk_left));

ver = (keyboard_check(ord("S")) || keyboard_check(vk_down))
    - (keyboard_check(ord("W")) || keyboard_check(vk_up));

// --- AGARRAR, ENTREGAR EN CONSOLA O SOLTAR LA BATERÍA ---
if (keyboard_check_pressed(ord("E"))) {
    
    // CASO A: No tiene batería -> Intenta agarrar una cercana
    if (bateria_cargada == noone) {
        var _bat = instance_nearest(x, y, Obj_battery_container);
        // Solo se pueden cargar cuando Frot avisa de un apagon (o durante el apagon)
        var _unlocked = instance_exists(Obj_space_weather) && Obj_space_weather.batteries_available();
        if (_unlocked && _bat != noone && distance_to_object(_bat) < 16) {
            bateria_cargada = _bat;
            _bat.siendo_cargada = true;
            play_sfx([snd_grab_1, snd_grab_2, snd_grab_3]);
        }
    } 
    // CASO B: Ya lleva una batería -> Revisa si está frente a Obj_console
    else {
        var _consola = instance_nearest(x, y, Obj_console);
        var _vida_maxima = 100; // Máximo de vida (la que muestra Obj_healthbar)

        // Si está cerca de Obj_console -> deposita la batería
        if (_consola != noone && distance_to_object(_consola) < 24) {

            // Suma 1 al contador únicamente al entregarla en la consola
            baterias_recogidas += 1;
            if (instance_exists(Obj_space_weather)) {
                Obj_space_weather.deliver_battery();
            }
            play_sfx([snd_drop_1, snd_drop_2, snd_drop_3]);

            // Recarga la vida sin sobrepasar el máximo
            health_ = min(health_ + bateria_cargada.valor_energia, _vida_maxima);
            
            // Devuelve la batería a su posición inicial para repetir el proceso
            bateria_cargada.siendo_cargada = false;
            bateria_cargada.x = bateria_cargada.xstart;
            bateria_cargada.y = bateria_cargada.ystart;
            bateria_cargada = noone;
        } 
        // Si NO está frente a la consola, la suelta al suelo
        else {
            bateria_cargada.siendo_cargada = false;
            bateria_cargada = noone;
            play_sfx([snd_drop_1, snd_drop_2, snd_drop_3], 0.6);
        }
    }
}

// --- AJUSTAR TU VELOCIDAD REAL SEGÚN LA BATERÍA ---
if (bateria_cargada != noone) {
    move_speed = vel_cargando;
} else {
    move_speed = vel_normal;
}

// --- TU MOVIMIENTO CON COLISIONES ---
if (hor != 0 || ver != 0) {

    var len = point_distance(0, 0, hor, ver);
    hor /= len;
    ver /= len;
    
    // Gasto constante de energía del jugador (aprox. 1.5 puntos por segundo)
    if (instance_exists(Obj_player)) {
        Obj_player.energy_ = max(0, Obj_player.energy_ - 0.025);
    }

    var mov_x = hor * move_speed;
    var mov_y = ver * move_speed;

    // Colisión horizontal
    if (!place_meeting(x + mov_x, y, movement_obstacles)) {
        x += mov_x;
    }
    
    // Colisión vertical
    if (!place_meeting(x, y + mov_y, movement_obstacles)) {
        y += mov_y;
    }

    if (abs(hor) >= abs(ver)) {
        if (hor > 0) {
            facing = "right";
        } else {
            facing = "left";
        }
    } else {
        if (ver > 0) {
            facing = "down";
        } else {
            facing = "up";
        }
    }
}

update_sprite();
