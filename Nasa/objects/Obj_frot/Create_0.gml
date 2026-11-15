// Frot lee las alertas del Sol cuando el jugador se acerca y presiona Enter
talk_distance = 40;
talk_key = vk_enter;
player_near = false;
was_talking = false; // Enter tambien cierra el dialogo: no volver a abrirlo en el mismo momento

rescue_target = noone;
rescue_arrived = false;
rescue_waypoints = [];
rescue_waypoint = 0;
rescue_stalled_steps = 0;
rescue_local_approach = false;
rescue_speed = 2.5;

function face_player_direction(_dx, _dy, _walking) {
    if (abs(_dx) >= abs(_dy) && _dx != 0) {
        if (_dx > 0) {
            sprite_index = _walking ? frot_right_move : frot_right_iddle;
        } else {
            sprite_index = _walking ? frot_left_move : frot_left_iddle;
        }
    } else if (_dy < 0) {
        sprite_index = _walking ? frot_up_move : frot_up_iddle;
    } else {
        sprite_index = _walking ? frot_down_move : frot_down_iddle;
    }
}

function rescue_position_open(_x, _y) {
    return _x >= 0 && _x < room_width && _y >= 0 && _y < room_height
        && !place_meeting(_x, _y, rescue_obstacles);
}

function rescue_can_talk_from(_x, _y) {
    var _foot_offset = (bbox_top + bbox_bottom) / 2 - y;
    var _target_foot_y = (rescue_target.bbox_top + rescue_target.bbox_bottom) / 2;
    return collision_line(_x, _y + _foot_offset, rescue_target.x, _target_foot_y, rescue_obstacles, false, true) == noone;
}

// Si la zona está aislada, usa un tramo libre cerca del jugador para la llegada.
function start_local_rescue_approach() {
    if (rescue_local_approach) {
        rescue_arrived = true;
        return;
    }
    rescue_local_approach = true;
    var _player = rescue_target;
    for (var _angle = 0; _angle < 360; _angle += 90) {
        var _goal_x = _player.x + lengthdir_x(24, _angle);
        var _goal_y = _player.y + lengthdir_y(24, _angle);
        if (!rescue_can_talk_from(_goal_x, _goal_y)) {
            continue;
        }
        var _clear = true;
        for (var _distance = 24; _distance <= 48; _distance += 2) {
            if (!rescue_position_open(_player.x + lengthdir_x(_distance, _angle),
                _player.y + lengthdir_y(_distance, _angle))) {
                _clear = false;
                break;
            }
        }
        if (_clear) {
            x = _player.x + lengthdir_x(48, _angle);
            y = _player.y + lengthdir_y(48, _angle);
            rescue_waypoints = [{ x: _goal_x, y: _goal_y }];
            rescue_waypoint = 0;
            rescue_stalled_steps = 0;
            return;
        }
    }
    rescue_arrived = true;
}

function start_rescue(_player, _obstacles) {
    rescue_target = _player;
    rescue_obstacles = _obstacles;
    player_near = false;

    if (point_distance(x, y, _player.x, _player.y) <= 26 && rescue_can_talk_from(x, y)) {
        rescue_arrived = true;
        return;
    }

    var _cell_size = 8;
    var _columns = ceil(room_width / _cell_size);
    var _rows = ceil(room_height / _cell_size);
    var _grid = mp_grid_create(0, 0, _columns, _rows, _cell_size, _cell_size);
    for (var _row = 0; _row < _rows; _row++) {
        for (var _column = 0; _column < _columns; _column++) {
            if (!rescue_position_open((_column + 0.5) * _cell_size, (_row + 0.5) * _cell_size)) {
                mp_grid_add_cell(_grid, _column, _row);
            }
        }
    }

    var _route = path_add();
    var _found = false;
    var _approach_angle = round(point_direction(_player.x, _player.y, x, y) / 45) * 45;
    var _angle_offsets = [0, -45, 45, -90, 90, -135, 135, 180];
    for (var _radius = 24; _radius >= 16 && !_found; _radius -= 8) {
        for (var _direction = 0; _direction < array_length(_angle_offsets) && !_found; _direction++) {
            var _angle = _approach_angle + _angle_offsets[_direction];
            var _goal_x = _player.x + lengthdir_x(_radius, _angle);
            var _goal_y = _player.y + lengthdir_y(_radius, _angle);
            if (rescue_position_open(_goal_x, _goal_y) && rescue_can_talk_from(_goal_x, _goal_y)) {
                _found = mp_grid_path(_grid, _route, x, y, _goal_x, _goal_y, false);
            }
        }
    }
    if (_found) {
        for (var _point = 0; _point < path_get_number(_route); _point++) {
            array_push(rescue_waypoints, { x: path_get_point_x(_route, _point), y: path_get_point_y(_route, _point) });
        }
    }
    path_delete(_route);
    mp_grid_destroy(_grid);

    if (array_length(rescue_waypoints) == 0) {
        start_local_rescue_approach();
    }
}

function walk_to_player() {
    var _goal = rescue_waypoints[rescue_waypoint];
    var _dx = _goal.x - x;
    var _dy = _goal.y - y;
    var _distance = point_distance(0, 0, _dx, _dy);
    var _old_x = x;
    var _old_y = y;

    if (_distance > 0) {
        var _fraction = min(1, rescue_speed / _distance);
        var _next_x = x + _dx * _fraction;
        var _next_y = y + _dy * _fraction;
        if (rescue_position_open(_next_x, y)) {
            x = _next_x;
        }
        if (rescue_position_open(x, _next_y)) {
            y = _next_y;
        }
    }

    if (point_distance(x, y, _goal.x, _goal.y) < 0.01) {
        rescue_waypoint += 1;
        rescue_arrived = rescue_waypoint >= array_length(rescue_waypoints);
        rescue_stalled_steps = 0;
    } else if (x == _old_x && y == _old_y) {
        rescue_stalled_steps += 1;
        if (rescue_stalled_steps >= 12) {
            start_local_rescue_approach();
            return;
        }
    } else {
        rescue_stalled_steps = 0;
    }

    if (x != _old_x || y != _old_y) {
        face_player_direction(x - _old_x, y - _old_y, true);
        depth = -bbox_bottom;
    }
}
