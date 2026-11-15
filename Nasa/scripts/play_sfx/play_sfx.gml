// Toca un efecto de sonido. Si recibe un arreglo, elige uno al azar (variedad en sonidos repetidos).
function play_sfx(_sound, _gain = 1) {
    if (is_array(_sound)) {
        _sound = _sound[irandom(array_length(_sound) - 1)];
    }
    var _id = audio_play_sound(_sound, 5, false);
    audio_sound_gain(_id, _gain, 0);
    return _id;
}

// Igual que play_sfx, pero no lo repite si alguno de esos sonidos ya esta sonando (para acciones continuas)
function play_sfx_once(_sound, _gain = 1) {
    var _list = is_array(_sound) ? _sound : [_sound];
    for (var _i = 0; _i < array_length(_list); _i++) {
        if (audio_is_playing(_list[_i])) {
            return -1;
        }
    }
    return play_sfx(_sound, _gain);
}
