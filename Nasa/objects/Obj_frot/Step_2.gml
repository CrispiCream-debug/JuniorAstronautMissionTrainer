var player = instance_nearest(x, y, Obj_player);
if (player == noone) {
    exit;
}

var dx = player.x - x;
var dy = player.y - y;
if (dx == 0 && dy == 0) {
    exit;
}

if (abs(dx) >= abs(dy)) {
    sprite_index = dx > 0 ? frot_right_iddle : frot_left_iddle;
} else {
    sprite_index = dy > 0 ? frot_down_iddle : frot_up_iddle;
}
