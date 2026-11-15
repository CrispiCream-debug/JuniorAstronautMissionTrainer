audio_stop_all();  // la musica de la partida sigue sonando al cambiar de room
var _days = variable_global_exists("game_over_days") ? global.game_over_days : 0;
survival_text = "You survived " + string(_days) + (_days == 1 ? " day" : " days");
restart_ready = !keyboard_check(vk_enter);
