
hor = (keyboard_check(ord("D")) || keyboard_check(vk_right))
    - (keyboard_check(ord("A")) || keyboard_check(vk_left));

ver = (keyboard_check(ord("S")) || keyboard_check(vk_down))
    - (keyboard_check(ord("W")) || keyboard_check(vk_up));

if (hor != 0 || ver != 0) {

    var len = point_distance(0, 0, hor, ver);
    hor /= len;
    ver /= len;

    x += hor * move_speed;
    y += ver * move_speed;

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
