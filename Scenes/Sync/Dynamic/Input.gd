extends Node

var input: Vector2;

func _ready():
	set_physics_process(get_parent().is_master);

func _physics_process(_delta):
	input = Vector2.ZERO;
	
	var v = Input.get_action_strength("up") + (-Input.get_action_strength("down"));
	var h = Input.get_action_strength("left") + (-Input.get_action_strength("right"));

	input = Vector2(-h,-v);
	get_parent().send_input(input);
	

