if (!unlocked || info_text == "" || (instance_exists(Obj_player) && Obj_player.health_ <= 0)) {
    player_near = false;
    exit;
}

player_near = instance_exists(Obj_player)
    && distance_to_object(Obj_player) <= talk_distance;

var _talking = false;
with (Obj_dialogue) {
    if (blocking) {
        _talking = true;
    }
}
var _just_talked = was_talking;
was_talking = _talking;

if (_talking || _just_talked || !player_near || !keyboard_check_pressed(talk_key)) {
    exit;
}

with (Obj_dialogue) {
    instance_destroy();  // quita el aviso breve de ALERT
}
instance_create_depth(0, 0, 0, Obj_dialogue, {
    text: info_title + "\n" + info_text,
    photo: info_image
});
