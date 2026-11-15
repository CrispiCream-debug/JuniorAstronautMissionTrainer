in_dome = place_meeting(x, y, Obj_domo);

// No moverse mientras alguien habla
var _blocked = false;
with (Obj_dialogue) {
    if (blocking) {
        _blocked = true;
    }
}
if (_blocked) {
    hor = 0;
    ver = 0;
    update_sprite();
    exit;
}

hor = (keyboard_check(ord("D")) || keyboard_check(vk_right))
    - (keyboard_check(ord("A")) || keyboard_check(vk_left));

ver = (keyboard_check(ord("S")) || keyboard_check(vk_down))
    - (keyboard_check(ord("W")) || keyboard_check(vk_up));

if (hor != 0 || ver != 0) {

    var len = point_distance(0, 0, hor, ver);
    hor /= len;
    ver /= len;

    
var mov_x = hor * move_speed;
var mov_y = ver * move_speed;

    // Colisión horizontal
    if (!place_meeting(x + mov_x, y, tilemap)) {
        x += mov_x;
    }
    
    // Colisión vertical
    if (!place_meeting(x, y + mov_y, tilemap)) {
        y += mov_y;
    }


    if (abs(hor) >= abs(ver)) {
        if (hor > 0) {
            facing = "right";
        } else {
            facing = "left";
        }
    } else {
        if (ver > 0) {
            facing = "down";
        } else {
            facing = "up";
        }
    }
}

update_sprite();

