//stats
energy_ = 100;
health_ = 100;
move_speed = 3;
hor = 0;
ver = 0;
facing = "up";
var tilemap = layer_tilemap_get_id("col_tiles");
movement_obstacles = [Obj_solid_prop];
if (tilemap != -1) {
    array_push(movement_obstacles, tilemap);
}
selected_panel = noone;

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

