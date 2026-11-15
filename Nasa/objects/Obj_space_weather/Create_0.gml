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
next_index = 0;            // siguiente evento por salir
impacts = [];              // { time, event }: eventos que vienen en camino a la base
alerts = [];               // { time, event }: eventos importantes que Frot aun no lee
explained_types = {};      // tipos que Frot ya explico (la analogia solo la primera vez)
events_survived = 0;       // score

// Radiacion ambiental en la base (escala 0-100, alimentada por radiation_points de cada impacto)
radiation = 100;
radiation_decay_per_second = 4;
radiation_damage_scale = 0.08; // vida perdida por segundo por cada punto de radiacion

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

// El evento llega a la base
function on_impact(_ev) {
    events_survived += 1;
    radiation = clamp(radiation + _ev.radiation_points, 0, 100);
    // Aqui se conectan las misiones (paneles, apagon, zonas radiactivas, maquina de oxigeno)
    // usando _ev.type, _ev.blackout y _ev.radiation_points.
    show_debug_message("Impacto: " + _ev.id + " | Radiacion: " + string(radiation));
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
        array_push(_lines, _ev.dialog[1]);
    }
    if (array_length(_lines) == 0) {
        array_push(_lines, "The Sun is calm right now. I will tell you if anything is coming!");
    }
    return _lines;
}
