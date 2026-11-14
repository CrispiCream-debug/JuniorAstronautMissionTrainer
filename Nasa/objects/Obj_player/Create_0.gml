//stats
move_speed = 2;
hor = 0;
ver = 0;
facing = "up";
tilemap = layer_tilemap_get_id("Col_tiles");


function update_sprite() {
    var moving = (hor != 0 || ver != 0);
    switch (facing) {

        case "up":
            sprite_index = moving ? tabo_up_move : tabo_up_iddle;
            break;

        case "down":
            sprite_index = moving ? tabo_down_move : tabo_down_iddle;
            break;

        case "left":
            sprite_index = moving ? tabo_left_move : tabo_left_iddle;
            break;

        case "right":
            sprite_index = moving ? tabo_right_move : tabo_right_iddle;
            break;
    }
}

