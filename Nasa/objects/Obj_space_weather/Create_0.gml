// Clima espacial: recorre en orden los eventos reales de 2024 (datafile eventos_juego.json, de DONKI).
// Este objeto solo lleva el tiempo, avisa y aplica impactos. Frot es quien lee las alertas.

// Reloj comprimido
day_seconds = 20;          // segundos de juego por cada dia real
max_gap_seconds = 40;      // tope de espera entre dos eventos (se saltan los huecos tranquilos)

// Tiempo de llegada: segundos = arrival_scale * raiz(minutos reales), entre el minimo y el maximo.
// Asi se conserva el orden: llamarada ~8 s, tormenta de particulas ~30 s, CME ~2 min.
arrival_scale = 1.8;
arrival_min_seconds = 8;
arrival_max_seconds = 150;

// Aviso breve
popup_text = "ALERT! Talk to Frot.";
popup_seconds = 2.5;

// Cuantas alertas lee Frot de una vez: pocas, el juego es para 6 a 12 años (en mayo llegan muchas)
max_alerts_read = 2;

clock = 0;                 // segundos de juego en esta vuelta al año
survival_seconds = 0;      // tiempo acumulado de la partida, incluso si el año se reinicia
next_index = 0;            // siguiente evento por salir
impacts = [];              // { time, event }: eventos que vienen en camino a la base
alerts = [];               // { time, event }: eventos importantes que Frot aun no lee
explained_types = {};      // tipos que Frot ya explico (la analogia solo la primera vez)
events_survived = 0;       // score

important_survived = 0;    // eventos importantes que ya llegaron (para los premios)

// Radiacion ambiental en la base (escala 0-100). Solo la suben las tormentas de particulas
// y las llamaradas fuertes; dura unos segundos y vuelve a 0.
radiation = 0;
radiation_timer = 0;       // segundos que le quedan a la radiacion actual
radiation_from_sep = false;
radiation_seconds_sep = 30;
radiation_seconds_flare = 10;
radiation_damage_scale = 0.05; // vida perdida por segundo por cada punto de radiacion (fuera del domo)

// Apagon: sin energia se apagan la calefaccion y las maquinas de aire. Se arregla con baterias.
blackout = false;
blackouts_coming = 0;      // apagones avisados que aun no llegan (desbloquean las baterias)
batteries_needed = 3;
batteries_delivered = 0;   // se pueden entregar antes del apagon para prevenirlo
blackout_damage = 0.6;     // vida perdida por segundo durante el apagon
dome_heal = 1;             // vida recuperada por segundo dentro del domo (si no hay apagon)
blackout_explained = false;

// Mensajes cortos (premios, apagon) que esperan a que no haya otro cuadro en pantalla
message_queue = [];
awards_given = {};
told = [];                 // { time, event }: alertas que Frot ya conto (lista de proximos eventos)

// Premios: texto blanco con contorno arriba de la pantalla (sin cuadro de dialogo)
award_queue = [];
award_text = "";
award_timer = 0;
award_seconds = 4;

// Pantalla de titulo: todo esta congelado hasta presionar Enter
title_active = true;

// Musica: intro en el titulo, luego el tema; radiacion y apagon tienen su propia pista
audio_stop_all();  // al reiniciar desde Game Over no queda musica de la partida anterior
music_volume = 0.6;
music_track = mus_intro;
music_id = audio_play_sound(mus_intro, 10, true);
audio_sound_gain(music_id, music_volume, 0);

var _buffer = buffer_load("eventos_juego.json");
var _data = json_parse(buffer_read(_buffer, buffer_text));
buffer_delete(_buffer);
events = _data.events;     // ya vienen ordenados por fecha
explanations = _data.explanations;  // una analogia por tipo de evento

// DONKI usa fechas como "2024-05-11T02:10Z"
function parse_date(_s) {
    return date_create_datetime(
        real(string_copy(_s, 1, 4)), real(string_copy(_s, 6, 2)), real(string_copy(_s, 9, 2)),
        real(string_copy(_s, 12, 2)), real(string_copy(_s, 15, 2)), 0
    );
}

// Momento (segundos de juego) en que se detecta cada evento
date_set_timezone(timezone_utc);
event_times = array_create(array_length(events), 0);
var _prev = date_create_datetime(2024, 1, 1, 0, 0, 0);
var _t = 0;
for (var _i = 0; _i < array_length(events); _i++) {
    var _date = parse_date(events[_i].date);
    _t += min((_date - _prev) * day_seconds, max_gap_seconds);  // las fechas se miden en dias
    event_times[_i] = _t;
    _prev = _date;
}
year_seconds = _t + max_gap_seconds;

// Importantes = disparan misiones: apagones, tormentas de particulas y llamaradas X.
// Las demas (llamaradas M, viento solar) llegan sin alerta.
function is_important(_ev) {
    return _ev.blackout || _ev.type == "SEP" || _ev.radiation_points >= 10;
}

// Inicio: se salta el principio tranquilo del año para que la primera alerta llegue
// despues de un rato corto para explorar el mapa
first_alert_seconds = 15;
for (var _i = 0; _i < array_length(events); _i++) {
    if (is_important(events[_i])) {
        clock = max(0, event_times[_i] - first_alert_seconds);
        next_index = _i;  // los eventos menores de antes no hacen nada, se omiten
        break;
    }
}

function danger(_ev) {
    return _ev.radiation_points + (_ev.blackout ? 100 : 0);
}

function arrival_seconds(_ev) {
    return clamp(arrival_scale * sqrt(_ev.arrival_minutes), arrival_min_seconds, arrival_max_seconds);
}

function show_alert_popup() {
    if (instance_exists(Obj_dialogue)) {
        return;  // ya hay un cuadro en pantalla
    }
    instance_create_depth(0, 0, 0, Obj_dialogue, { text: popup_text, auto_close: popup_seconds, blocking: false });
}

function queue_message(_text, _seconds) {
    array_push(message_queue, { text: _text, seconds: _seconds });
}

// Premios: los objetos con foto empiezan desactivados (ver Obj_info_item) y aparecen al lograr algo
function unlock_award(_obj) {
    var _key = object_get_name(_obj);
    if (variable_struct_exists(awards_given, _key)) {
        return;
    }
    awards_given[$ _key] = true;
    instance_activate_object(_obj);
    var _title = "";
    with (_obj) {
        _title = info_title;
    }
    array_push(award_queue, _title == "" ? "You won a new object for the lunar base!"
        : "You won a new object for the lunar base!\n" + _title);
}

// Eventos que suben la radiacion al llegar (tormentas de particulas y llamaradas fuertes)
// Nombre corto para la lista de proximos eventos, con lo que provoca
function event_label(_ev) {
    var _name = _ev.name;
    if (_ev.type == "SEP") {
        _name = "Particle Storm";
    } else if (_ev.type == "CME") {
        _name = "Plasma Cloud (CME)";
    }
    if (_ev.blackout) {
        _name += " - blackout";
    } else if (raises_radiation(_ev)) {
        _name += " - radiation";
    }
    return _name;
}

function raises_radiation(_ev) {
    return _ev.type == "SEP" || (_ev.type == "FLR" && _ev.radiation_points >= 10);
}

function batteries_available() {
    return blackout || blackouts_coming > 0;
}

function deliver_battery() {
    batteries_delivered += 1;
    if (blackout && batteries_delivered >= batteries_needed) {
        end_blackout();
    }
}

function start_blackout() {
    if (blackout) {
        return;
    }
    if (batteries_delivered >= batteries_needed) {
        batteries_delivered -= batteries_needed;
        queue_message("The Sun hit the power, but your spare batteries kept the lights on. Great job!", 4);
        play_sfx(snd_success);
        unlock_award(Obj_dish);
        return;
    }
    blackout = true;
    play_sfx(snd_fail);
    queue_message("Blackout! The heaters and air machines stopped. Bring "
        + string(batteries_needed - batteries_delivered) + " batteries to the console!", 4);
}

function end_blackout() {
    blackout = false;
    batteries_delivered = max(0, batteries_delivered - batteries_needed);
    queue_message("Power is back! The heaters and air machines are working again.", 3);
    play_sfx(snd_success);
    unlock_award(Obj_dish);
}

// Un golpe del Sol a los paneles: los limpios se ensucian, los sucios (o con _break) se rompen
function damage_panels(_count, _break) {
    var _panels = [];
    with (Obj_panel_limpieza) {
        if (!abierto && estado != "roto") {
            array_push(_panels, id);
        }
    }
    for (var _i = 0; _i < min(_count, array_length(_panels)); _i++) {
        var _pick = irandom_range(_i, array_length(_panels) - 1);
        var _panel = _panels[_pick];
        _panels[_pick] = _panels[_i];
        with (_panel) {
            hit_by_sun(_break);
        }
    }
}

// El evento llega a la base
function on_impact(_ev) {
    events_survived += 1;
    if (is_important(_ev)) {
        important_survived += 1;
        if (important_survived >= 10) {
            unlock_award(Obj_suit);
        }
        if (important_survived >= 25) {
            unlock_award(Obj_flag);
        }
    }

    // Radiacion: tormentas de particulas y llamaradas fuertes
    var _rad_seconds = 0;
    if (_ev.type == "SEP") {
        _rad_seconds = radiation_seconds_sep;
        radiation_from_sep = true;
    } else if (raises_radiation(_ev)) {
        _rad_seconds = radiation_seconds_flare;
    }
    if (_rad_seconds > 0) {
        if (radiation <= 0) {
            play_sfx(snd_radioactive);
        }
        radiation = max(radiation, min(_ev.radiation_points, 100));
        radiation_timer = max(radiation_timer, _rad_seconds);
    }

    // Paneles: el destello de una llamarada fuerte los ensucia; una tormenta que apaga la base rompe uno
    if (_ev.type == "FLR" && _ev.radiation_points >= 10) {
        damage_panels(irandom_range(1, 2), false);
    } else if (_ev.type == "SEP" && _ev.blackout) {
        damage_panels(1, true);
    }

    if (_ev.blackout) {
        blackouts_coming = max(0, blackouts_coming - 1);
        start_blackout();
    }
    show_debug_message("Impacto: " + _ev.id + " | Radiacion: " + string(radiation) + " | Apagon: " + string(blackout));
}

// Que hacer, en tono de sugerencia. Reemplaza dialog[1] del JSON (solo hay 5 textos distintos).
function mission_tip(_ev) {
    var _original = _ev.dialog[1];
    switch (_original) {
        case "Stay inside the base and keep away from radiation zones until it passes!":
            return "I recommend you go inside the dome and stay there until the radiation passes.";
        case "When it hits, the power will go out. Get the spare batteries ready!":
            return "When it hits, the power will go out. I recommend you carry " + string(batteries_needed)
                + " spare batteries to the console before it arrives, so the lights stay on.";
        case "Radiation may come next. Get the base ready and stay close to it!":
            return "Radiation may come next. I recommend you stay close to the dome.";
        case "Its flash can harm the solar panels. Check them!":
            return "Its flash can get the solar panels dirty. I recommend you check them after it hits.";
        case "It is so strong it can break machines! Stay inside, keep away from radiation zones and check the oxygen machine.":
            return "It is so strong it can break machines! I recommend you stay inside the dome, and then fix the broken solar panels.";
    }
    return _original;
}

// Lo que dice Frot cuando hablas con el. Vacia las alertas pendientes.
function take_alert_dialogue() {
    var _upcoming = [];
    var _already_hit = 0;
    for (var _i = 0; _i < array_length(alerts); _i++) {
        if (alerts[_i].time > clock) {
            array_push(_upcoming, alerts[_i]);
        } else {
            _already_hit += 1;
        }
    }
    alerts = [];

    // Si son demasiadas, se leen las mas peligrosas, en el orden en que van a llegar
    if (array_length(_upcoming) > max_alerts_read) {
        array_sort(_upcoming, function(_a, _b) { return danger(_b.event) - danger(_a.event); });
        array_resize(_upcoming, max_alerts_read);
    }
    array_sort(_upcoming, function(_a, _b) { return _a.time - _b.time; });

    var _lines = [];
    if (_already_hit > 0) {
        array_push(_lines, "While you were away, the Sun hit the base " + string(_already_hit) + (_already_hit == 1 ? " time." : " times."));
    }
    // Alerta real, la analogia si es la primera vez de ese tipo, y al final que hacer
    for (var _i = 0; _i < array_length(_upcoming); _i++) {
        var _ev = _upcoming[_i].event;
        array_push(_lines, _ev.dialog[0]);
        if (!variable_struct_exists(explained_types, _ev.type)) {
            explained_types[$ _ev.type] = true;
            array_push(_lines, explanations[$ _ev.type]);
        }
        if (_ev.blackout && !blackout_explained) {
            blackout_explained = true;
            array_push(_lines, "Without power, the heaters and air machines stop, and the Moon gets super cold!");
        }
        array_push(_lines, { text: "TIP: " + mission_tip(_ev), tip: true });
        array_push(told, _upcoming[_i]);  // ahora sale en la lista de proximos eventos
    }
    unlock_award(Obj_retroflector);  // primera vez que hablas con Frot
    if (array_length(_lines) == 0) {
        array_push(_lines, "The Sun is calm right now. I will tell you if anything is coming!");
    }
    return _lines;
}
