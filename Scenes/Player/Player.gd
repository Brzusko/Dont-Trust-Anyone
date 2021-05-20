extends KinematicBody2D
class_name Player

export var camera_scene: PackedScene;
export var main_player_txt: Texture;
export var player_speed: float = 20.0;

master var s_player_move_dir: Vector2 = Vector2.ZERO;
remote var c_pos: Vector2 = Vector2.ZERO;

var local_move_dir: Vector2 = Vector2.ZERO;
var is_local: bool = false;

func setup(player_name, init_pos) -> void:
	set_network_master(1);
	name = player_name;
	global_position = init_pos;
	var id = str(get_tree().get_network_unique_id());
	
	if id == player_name && (Networking.app_state == Enums.APP_TYPE.CLIENT || Networking.app_state == Enums.APP_TYPE.HOST):
		var camera = camera_scene.instance();
		add_child(camera);
		$Look.texture = main_player_txt;
		is_local = true;

func _process(delta):
	if !is_local:
		return;
	
#	if Networking.app_state == Enums.APP_TYPE.HOST:
#		s_player_move_dir = local_move_dir;
#	else:
#		rset_unreliable_id(1, "s_player_move_dir", local_move_dir);

		
func _physics_process(delta):
#	if !is_network_master():
#		global_position = c_pos;
#		return;
#	process_movement(delta);
	pass;

master func process_movement(delta):
	var movement_vector = s_player_move_dir * player_speed  * delta;
	move_and_collide(movement_vector);
	rset_unreliable("c_pos", global_position);

master func serialize() -> Dictionary:
	return {
		"n": name,
		"p": global_position,
	};
