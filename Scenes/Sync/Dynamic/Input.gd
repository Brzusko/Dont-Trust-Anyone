extends Node
class_name PlayerInput

onready var latest_input = input_template.duplicate();
var unprocessed_inputs: Dictionary = {};

var can_process_input = false;

var i = -1;

var input_template: Dictionary = {
	"v": Vector2.ZERO,
	"l": 0.0,
	"i": i,
}

var send_last_input = false;

func _ready():
	set_physics_process(get_parent().is_master);

func process_cache():
	pass;

func _physics_process(_delta):
	if !can_process_input:
		return;
		
	latest_input = input_template.duplicate();
	latest_input.v = Vector2.ZERO;
	var v = Input.get_action_strength("up") + (-Input.get_action_strength("down"));
	var h = Input.get_action_strength("left") + (-Input.get_action_strength("right"));
	latest_input.v = Vector2(-h,-v);
	latest_input.l = -h;

	i += 1 ;
	latest_input.i = i;

	unprocessed_inputs[i] = latest_input;
	get_parent().send_input(latest_input, _delta);


func is_movement_up(event: InputEvent):
	return event.is_action_pressed("up") || event.is_action_pressed("down") || event.is_action_pressed("left") || event.is_action_pressed("right");

func is_movement_down(event: InputEvent):
	return event.is_action_released("up") || event.is_action_released("down") || event.is_action_released("left") || event.is_action_released("right");

func _input(event):
	if !get_parent().is_master:
		return;
	
	if is_movement_up(event):
		can_process_input = true;
	if is_movement_down(event):
		can_process_input = false;

	




