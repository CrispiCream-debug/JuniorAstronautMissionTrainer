if (rescue_target != noone) {
    if (instance_exists(rescue_target)) {
        if (!rescue_arrived) {
            walk_to_player();
        }
        if (rescue_arrived) {
            face_player_direction(rescue_target.x - x, rescue_target.y - y, false);
        }
    }
    exit;
}

var player = instance_nearest(x, y, Obj_player);
if (player == noone) {
    exit;
}

var dx = player.x - x;
var dy = player.y - y;
if (dx == 0 && dy == 0) {
    exit;
}

face_player_direction(dx, dy, false);
