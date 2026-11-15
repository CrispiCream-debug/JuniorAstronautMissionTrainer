// Objetos con dato curioso: al acercarse y presionar E se abre un dialogo con la foto real encima
// Son premios: empiezan bloqueados y desactivados (no se dibujan ni chocan).
// Obj_space_weather.unlock_award() los activa al lograr un hito.
// Para dejar uno desbloqueado desde el inicio pon unlocked = true en el creation code del room.
if (!variable_instance_exists(id, "unlocked")) {
    unlocked = false;
}

talk_distance = 32;  // distancia desde el borde del sprite (1 tile), para que sirva con objetos grandes o detras de muros
talk_key = ord("E");
player_near = false;
was_talking = false;  // E tambien cierra el dialogo: no volver a abrirlo en el mismo momento

info_title = "";
info_text = "";
info_image = -1;

switch (object_index) {
    case Obj_retroflector:
        info_title = "Light Echo - Laser Retroreflector";
        info_text = "There are mirrors on the Moon! Scientists fire laser beams at them from Earth to measure how far away our satellite is.";
        info_image = Img_retroreflector;
        break;
    case Obj_lunar_rover:
        info_title = "Lunar Explorer - Lunar Roving Vehicle (LRV)";
        info_text = "A car on the Moon! This vehicle carried astronauts and tools across the lunar surface. It could reach about 18 km/h!";
        info_image = Img_lunar_rover;
        break;
    case Obj_satelite_lro:
        info_title = "Lunar Mapmaker - LRO Satellite";
        info_text = "It's like a space photographer! Since 2009, LRO has been watching the Moon and taking pictures to create very detailed maps of its surface.";
        info_image = Img_satelite_lro;
        break;
    case Obj_dish:
        info_title = "Connected to Earth - Satellite Dish";
        info_text = "A giant antenna to talk with our planet! It helps send and receive messages between the astronauts and Earth.";
        info_image = Img_dish;
        break;
    case Obj_box:
        info_title = "Lunar Scientist - Sample Container";
        info_text = "The Moon has scientific treasures! Apollo astronauts brought lunar rocks and dust back to Earth so scientists could study them.";
        info_image = Img_box;
        break;
    case Obj_suit:
        info_title = "First Steps - Neil Armstrong's Spacesuit";
        info_text = "This suit helped Neil Armstrong become the first human to walk on the Moon! It gave him oxygen and protection from extreme temperatures.";
        info_image = Img_suit;
        break;
    case Obj_flag:
        info_title = "One Small Step for Mankind - Apollo 11 Flag";
        info_text = "It was the first American flag placed on the Moon by astronauts! Neil Armstrong and Buzz Aldrin set it up during their historic mission.";
        info_image = Img_flag;
        break;
}

// Desactivado = bloqueado. Al reactivarse ya queda desbloqueado.
if (!unlocked) {
    unlocked = true;
    instance_deactivate_object(id);
}
