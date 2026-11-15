player_near = instance_exists(Obj_player)
    && point_distance(x, y, Obj_player.x, Obj_player.y) <= talk_distance;

var _talking = false;
with (Obj_dialogue) {
    if (blocking) {
        _talking = true;
    }
}
var _just_talked = was_talking;
was_talking = _talking;

if (_talking || _just_talked || !player_near || !instance_exists(Obj_space_weather) || !keyboard_check_pressed(talk_key)) {
    exit;
}

with (Obj_dialogue) {
    instance_destroy();  // quita el aviso breve de ALERT
}
instance_create_depth(0, 0, 0, Obj_dialogue, { text: Obj_space_weather.take_alert_dialogue() });
