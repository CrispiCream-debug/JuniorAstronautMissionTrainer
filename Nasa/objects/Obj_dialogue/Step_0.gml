if (!dialogue_initialized || string(text) != prev_text_key) {
    rebuild_dialogue();
}

if (array_length(pages) == 0) {
    exit;
}

var _current_page = pages[page_index];
var _total_chars = 0;
for (var _i = 0; _i < array_length(_current_page); _i++) {
    _total_chars += string_length(_current_page[_i]);
}

var _advance_pressed = keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(ord("Z"))
    || mouse_check_button_pressed(mb_left);

if (!page_finished) {
    if (_advance_pressed) {
        char_index = _total_chars;
        page_finished = true;
    } else {
        char_index = min(char_index + text_speed, _total_chars);
        if (floor(char_index) >= _total_chars) {
            page_finished = true;
        }
    }
} else if (_advance_pressed) {
    if (page_index < array_length(pages) - 1) {
        page_index += 1;
        char_index = 0;
        page_finished = false;
    } else {
        instance_destroy();
    }
}
