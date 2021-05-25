extends KinematicBody2D
class_name Player

export var camera_scene: PackedScene;

var is_local: bool = false;

func setup(player_name, init_pos) -> void:
	set_network_master(1);
	name = player_name;
	global_position = init_pos;
	var id = str(get_tree().get_network_unique_id());
	
	if id == player_name && (Networking.app_state == Enums.APP_TYPE.CLIENT || Networking.app_state == Enums.APP_TYPE.HOST):
		var camera = camera_scene.instance();
		add_child(camera);
		is_local = true;
		$AnimationTree.active = true;
		$Input.generate_data();

master func serialize() -> Dictionary:
	return {
		"n": name,
		"p": global_position,
	};
