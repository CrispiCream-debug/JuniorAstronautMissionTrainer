// Texto de premio: uno a la vez, corre aunque Frot este hablando
if (award_timer > 0) {
    award_timer -= 1 / game_get_speed(gamespeed_fps);
} else if (array_length(award_queue) > 0) {
    award_text = award_queue[0];
    array_delete(award_queue, 0, 1);
    award_timer = award_seconds;
    play_sfx(snd_success);
}

// Pantalla de titulo: Enter (o espacio) empieza el juego
if (title_active && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
    title_active = false;
}

// Musica segun la situacion (sigue sonando aunque Frot hable)
var _wanted = title_active ? mus_intro : (blackout ? mus_blackout : (radiation > 0 ? mus_radiation : mus_theme));
if (_wanted != music_track) {
    audio_stop_sound(music_id);
    music_track = _wanted;
    music_id = audio_play_sound(_wanted, 10, true);
    audio_sound_gain(music_id, 0, 0);
    audio_sound_gain(music_id, music_volume, 1000);  // entra suave
}

if (title_active) {
    exit;
}

// El tiempo se detiene mientras Frot habla
var _blocked = false;
with (Obj_dialogue) {
    if (blocking) {
        _blocked = true;
    }
}
if (_blocked) {
    exit;
}

// Mensajes en cola (premios, apagon) cuando no hay otro cuadro
if (array_length(message_queue) > 0 && !instance_exists(Obj_dialogue)) {
    var _msg = message_queue[0];
    array_delete(message_queue, 0, 1);
    instance_create_depth(0, 0, 0, Obj_dialogue, { text: _msg.text, auto_close: _msg.seconds, blocking: false });
    play_sfx(snd_call);
}

var _dt = 1 / game_get_speed(gamespeed_fps);
clock += _dt;

// Eventos que se detectan ahora
while (next_index < array_length(events) && event_times[next_index] <= clock) {
    var _ev = events[next_index];
    next_index += 1;
    var _arrival = clock + arrival_seconds(_ev);
    array_push(impacts, { time: _arrival, event: _ev });
    if (_ev.blackout) {
        blackouts_coming += 1;  // ya se pueden cargar baterias
    }
    if (is_important(_ev)) {
        array_push(alerts, { time: _arrival, event: _ev });
        show_alert_popup();
        play_sfx_once(snd_alert);
    }
}

// Eventos que llegan a la base
for (var _i = array_length(impacts) - 1; _i >= 0; _i--) {
    if (impacts[_i].time <= clock) {
        var _hit = impacts[_i].event;
        array_delete(impacts, _i, 1);
        on_impact(_hit);
    }
}

// Lista de proximos eventos: se quitan los que ya llegaron
for (var _i = array_length(told) - 1; _i >= 0; _i--) {
    if (told[_i].time <= clock) {
        array_delete(told, _i, 1);
    }
}

// La radiacion dura unos segundos y vuelve a 0
if (radiation_timer > 0) {
    radiation_timer -= _dt;
    if (radiation_timer <= 0) {
        radiation_timer = 0;
        radiation = 0;
        if (radiation_from_sep) {
            radiation_from_sep = false;
            unlock_award(Obj_satelite_lro);  // sobreviviste una tormenta de particulas
        }
    }
}

// Dano por radiacion si el jugador esta fuera del domo
if (radiation > 0 && instance_exists(Obj_player) && !Obj_player.in_dome) {
    Obj_player.health_ = max(0, Obj_player.health_ - radiation * radiation_damage_scale * _dt);
}

// Apagon: sin calefaccion ni aire se pierde vida poco a poco
if (blackout && instance_exists(Obj_player)) {
    Obj_player.health_ = max(0, Obj_player.health_ - blackout_damage * _dt);
}

// Dentro del domo, con energia en la base, se recupera vida poco a poco
if (!blackout && instance_exists(Obj_player) && Obj_player.in_dome) {
    Obj_player.health_ = min(100, Obj_player.health_ + dome_heal * _dt);
}

// Fin del año: vuelve a enero sin avisar (casi nadie llega hasta aqui)
if (next_index >= array_length(events) && clock >= year_seconds) {
    for (var _i = 0; _i < array_length(impacts); _i++) {
        impacts[_i].time -= clock;
    }
    for (var _i = 0; _i < array_length(alerts); _i++) {
        alerts[_i].time -= clock;
    }
    for (var _i = 0; _i < array_length(told); _i++) {
        told[_i].time -= clock;
    }
    clock = 0;
    next_index = 0;
}
