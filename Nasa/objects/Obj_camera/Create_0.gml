camera_zoom = 1.8;
camera_sky_offset_ratio = 1 / 6;

function follow_player() {
    var cam = view_camera[0];
    if (!view_enabled || cam == -1) {
        return;
    }

    var player = instance_find(Obj_player, 0);
    if (player == noone) {
        return;
    }

    var view_width = camera_get_view_width(cam);
    var view_height = camera_get_view_height(cam);
    var sky_start_y = room_height / 5;
    var sky_offset_max = view_height * camera_sky_offset_ratio;
    var sky_progress = clamp((sky_start_y - player.y) / sky_offset_max, 0, 1);
    var sky_ease = sky_progress * sky_progress * (3 - 2 * sky_progress);
    var sky_offset = sky_offset_max * sky_ease;

    var view_x = clamp(player.x - view_width / 2, 0, room_width - view_width);
    var view_y = clamp(player.y - view_height / 2 - sky_offset, 0, room_height - view_height);
    camera_set_view_pos(cam, view_x, view_y);
}

if (view_enabled && view_camera[0] != -1) {
    var port_width = view_wport[0];
    var port_height = view_hport[0];
    var view_scale = min(1 / camera_zoom, room_width / port_width, room_height / port_height);
    camera_set_view_size(view_camera[0], max(1, round(port_width * view_scale)), max(1, round(port_height * view_scale)));
    follow_player();
}
