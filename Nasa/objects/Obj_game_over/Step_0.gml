if (!restart_ready) {
    restart_ready = !keyboard_check(vk_enter);
} else if (keyboard_check_pressed(vk_enter)) {
    game_restart();
}
