extends Node2D
class_name PlayerInput

onready var latest_input = input_template.duplicate();
onready var input_cache = input_template.duplicate();

var mouse_cache: Vector2;

var unprocessed_inputs: Dictionary = {};
var i = -1;
var l = -1;
var send_mouse_input: bool = false;

var input_template: Dictionary = {
	"v": Vector2.ZERO,
	"l": l,
	"i": i,
	"p": null,
	"m": Vector2.ZERO,
}

func _ready():
	set_physics_process(get_parent().is_master);

func _physics_process(delta):
	calculate_inputs();
	
	if latest_input.v == Vector2.ZERO: 
		if send_mouse_input:
			append_buffer();
			unprocessed_inputs[i] = latest_input;
			get_parent().send_input(latest_input);
			send_mouse_input = false;
		get_parent().update_local_state(latest_input);
		return;
		
	append_buffer();
	
	get_parent().update_local_state(latest_input);
	get_parent().send_input(latest_input);
	

func is_movement_action(event: InputEvent):
	return event.is_action("up") || event.is_action("down") || event.is_action("left") || event.is_action("right");

func calculate_inputs():	
	latest_input = input_template.duplicate();
	latest_input.l = l;
	var v = Input.get_action_strength("up") + (-Input.get_action_strength("down"));
	var h = Input.get_action_strength("left") + (-Input.get_action_strength("right"));
	latest_input.v = Vector2(-h,-v).normalized();
	latest_input.l = h;
	latest_input.m = mouse_cache;
	l = h;	
	mouse_cache = Vector2.ZERO;

func append_buffer():
	i += 1;
	latest_input.i = i;
	unprocessed_inputs[i] = latest_input;
	
func _input(event):
	if!(event is InputEventMouseMotion):
		return;
	mouse_cache = event.relative;
	send_mouse_input = true;
