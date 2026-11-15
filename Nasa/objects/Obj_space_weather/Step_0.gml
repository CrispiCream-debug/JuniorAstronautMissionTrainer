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

clock += 1 / game_get_speed(gamespeed_fps);

// Eventos que se detectan ahora
while (next_index < array_length(events) && event_times[next_index] <= clock) {
    var _ev = events[next_index];
    next_index += 1;
    var _arrival = clock + arrival_seconds(_ev);
    array_push(impacts, { time: _arrival, event: _ev });
    if (is_important(_ev)) {
        array_push(alerts, { time: _arrival, event: _ev });
        show_alert_popup();
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

// Fin del año: vuelve a enero sin avisar (casi nadie llega hasta aqui)
if (next_index >= array_length(events) && clock >= year_seconds) {
    for (var _i = 0; _i < array_length(impacts); _i++) {
        impacts[_i].time -= clock;
    }
    for (var _i = 0; _i < array_length(alerts); _i++) {
        alerts[_i].time -= clock;
    }
    clock = 0;
    next_index = 0;
}
