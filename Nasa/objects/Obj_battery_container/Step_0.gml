if (siendo_cargada && instance_exists(Obj_player)) {
    x = Obj_player.x;
    y = Obj_player.y - 16;
    depth = Obj_player.depth - 1;
} else {
    depth = 0;
}