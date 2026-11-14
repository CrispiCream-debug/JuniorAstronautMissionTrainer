camera_zoom = 3.5;

function follow_player() {
    var cam = view_camera[0];
    if (!view_enabled || cam == -1) {
        return;
    }

    var player = instance_find(Obj_player, 0);
    if (player == noone) {
        return;
    }

    var half_width = camera_get_view_width(cam) / 2;
    var half_height = camera_get_view_height(cam) / 2;
    camera_set_view_pos(cam, player.x - half_width, player.y - half_height);
}

if (view_enabled && view_camera[0] != -1) {
    camera_set_view_size(view_camera[0], view_wport[0] / camera_zoom, view_hport[0] / camera_zoom);
    follow_player();
}
