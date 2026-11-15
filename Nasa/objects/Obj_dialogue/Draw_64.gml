if (!dialogue_initialized || array_length(pages) == 0) {
    exit;
}

var _layout = get_box_layout();

draw_sprite_ext(
    Sp_dialogue,
    0,
    _layout.x,
    _layout.y,
    _layout.scale,
    _layout.scale,
    0,
    c_white,
    1
);

var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

var _actual_scale = text_scale * _layout.scale;
var _line_height = string_height("Ay") * _actual_scale * line_sep_mult;
var _current_page = pages[page_index];
var _remaining = floor(char_index);

var _shadow_color = make_color_rgb(208, 208, 216);
var _text_color = make_color_rgb(30, 30, 40);
var _shadow_offset = max(1, round(_layout.scale));

for (var _i = 0; _i < array_length(_current_page); _i++) {
    if (_remaining <= 0) {
        break;
    }

    var _line = _current_page[_i];
    var _line_len = string_length(_line);
    var _chars_to_draw = min(_remaining, _line_len);
    var _visible_text = string_copy(_line, 1, _chars_to_draw);
    var _draw_y = _layout.text_y + (_i * _line_height);

    draw_set_color(_shadow_color);
    draw_text_transformed(
        _layout.text_x + _shadow_offset,
        _draw_y + _shadow_offset,
        _visible_text,
        _actual_scale,
        _actual_scale,
        0
    );

    draw_set_color(_text_color);
    draw_text_transformed(
        _layout.text_x,
        _draw_y,
        _visible_text,
        _actual_scale,
        _actual_scale,
        0
    );

    _remaining -= _chars_to_draw;
}

if (page_finished) {
    var _bob = sin(current_time * 0.008) * (3 * _layout.scale);
    var _tri_w = 10 * _layout.scale;
    var _tri_h = 8 * _layout.scale;
    var _tri_cx = _layout.x + _layout.w - (30 * _layout.scale);
    var _tri_cy = _layout.y + _layout.h - (26 * _layout.scale) + _bob;

    draw_set_color(make_color_rgb(168, 24, 24));
    draw_triangle(
        _tri_cx - _tri_w * 0.5, _tri_cy - _tri_h * 0.5,
        _tri_cx + _tri_w * 0.5, _tri_cy - _tri_h * 0.5,
        _tri_cx, _tri_cy + _tri_h * 0.5,
        false
    );
}

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
