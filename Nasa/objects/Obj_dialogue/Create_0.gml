if (!variable_instance_exists(id, "text")) {
    text = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    ];
}

// Segundos antes de cerrarse solo; -1 = espera a que el jugador lo cierre.
if (!variable_instance_exists(id, "auto_close")) {
    auto_close = -1;
}

// Si bloquea, el jugador no se mueve y el reloj del Sol se detiene mientras esta abierto.
if (!variable_instance_exists(id, "blocking")) {
    blocking = true;
}

// Foto real que se muestra encima de la caja; -1 = sin imagen.
if (!variable_instance_exists(id, "photo")) {
    photo = -1;
}

// Ignora la tecla en el primer frame, para que la misma tecla que lo abrio no lo adelante
input_delay = 1;

text_speed = 0.65;
text_scale = 1.6;
line_sep_mult = 1.35;
max_lines_per_page = 3;

pages = [];
page_tips = [];
page_index = 0;
char_index = 0;
page_finished = false;
dialogue_initialized = false;
prev_text_key = "";

// Una entrada puede ser { text, tip: true }: consejo de Frot, se dibuja con otro color (ver Draw GUI).
// Guarda en page_tips si cada pagina es consejo.
function wrap_text_to_pages(_raw_text, _max_width, _scale, _max_lines) {
    var _entries = is_array(_raw_text) ? _raw_text : [_raw_text];
    var _result_pages = [];
    page_tips = [];

    for (var _e = 0; _e < array_length(_entries); _e++) {
        var _is_tip = is_struct(_entries[_e]) && variable_struct_exists(_entries[_e], "tip") && _entries[_e].tip;
        var _entry = is_struct(_entries[_e]) ? string(_entries[_e].text) : string(_entries[_e]);
        var _paragraphs = string_split(_entry, "\n");
        var _wrapped_lines = [];

        for (var _p = 0; _p < array_length(_paragraphs); _p++) {
            var _para = _paragraphs[_p];
            if (_para == "") {
                array_push(_wrapped_lines, "");
                continue;
            }

            var _words = string_split(_para, " ");
            var _current_line = "";

            for (var _w = 0; _w < array_length(_words); _w++) {
                var _word = _words[_w];
                var _candidate = (_current_line == "") ? _word : (_current_line + " " + _word);

                if (string_width(_candidate) * _scale <= _max_width || _current_line == "") {
                    _current_line = _candidate;
                } else {
                    array_push(_wrapped_lines, _current_line);
                    _current_line = _word;
                }
            }

            if (_current_line != "") {
                array_push(_wrapped_lines, _current_line);
            }
        }

        if (array_length(_wrapped_lines) == 0) {
            array_push(_result_pages, [""]);
            array_push(page_tips, _is_tip);
            continue;
        }

        for (var _i = 0; _i < array_length(_wrapped_lines); _i += _max_lines) {
            var _page_lines = [];
            var _end = min(_i + _max_lines, array_length(_wrapped_lines));
            for (var _j = _i; _j < _end; _j++) {
                array_push(_page_lines, _wrapped_lines[_j]);
            }
            array_push(_result_pages, _page_lines);
            array_push(page_tips, _is_tip);
        }
    }

    return _result_pages;
}

function get_box_layout() {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _spr_w = sprite_get_width(Sp_dialogue);
    var _spr_h = sprite_get_height(Sp_dialogue);

    var _scale = clamp(min((_gui_w * 0.85) / _spr_w, (_gui_h * 0.30) / _spr_h), 0.5, 2.0);
    var _box_w = _spr_w * _scale;
    var _box_h = _spr_h * _scale;
    var _box_x = (_gui_w - _box_w) * 0.5;
    var _box_y = _gui_h - _box_h - 24;

    var _pad_x = 34 * _scale;
    var _pad_y = 28 * _scale;

    return {
        scale: _scale,
        x: _box_x,
        y: _box_y,
        w: _box_w,
        h: _box_h,
        text_x: _box_x + _pad_x,
        text_y: _box_y + _pad_y,
        text_w: _box_w - (_pad_x * 2),
        text_h: _box_h - (_pad_y * 2)
    };
}

function rebuild_dialogue() {
    var _layout = get_box_layout();
    var _actual_text_scale = text_scale * _layout.scale;
    pages = wrap_text_to_pages(text, _layout.text_w, _actual_text_scale, max_lines_per_page);
    page_index = 0;
    char_index = 0;
    page_finished = false;
    dialogue_initialized = true;
    prev_text_key = string(text);
}
