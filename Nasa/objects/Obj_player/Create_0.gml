//Variables de posicion
tilemap= layer_tilemap_get_id("Col_tiles");
facing = "up";
direccion = 0;
deep = -1
hor = undefined;
ver = undefined;

//Variables de caracteristicas generales
move_speed = 2;
dead = false;


function is_move(){
    if (hor == 0 && ver == 0){
        return false;
    }else{
        return true;
    }
}

function body_sprites(){
    if (hor != 0 || ver != 0) {
    
       switch (facing) {
           case "down":      sprite_index = tabo_down_move;      break;
           case "up":        sprite_index = tabo_up_move;        break;
           case "left":      sprite_index = tabo_left_move;      break;
           case "right":     sprite_index = tabo_right_move;     break;
        }
    }
    else {
        switch (facing) {
           case "down":      sprite_index = tabo_down_iddle;      break;
           case "up":        sprite_index = tabo_up_iddle;        break;
           case "left":      sprite_index = tabo_left_iddle;      break;
           case "right":     sprite_index = tabo_right_iddle;     break;
        }
    }
}

function depth_w_facing(){
    switch (facing) {
       case "up": 
       case "right": 
       case "left": 
           deep = 0;  
           break;
   
       case "down": 
           deep = -1;  
           break;    
   }
}
