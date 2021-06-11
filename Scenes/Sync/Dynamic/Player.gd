extends KinematicBody2D
class_name Player

var is_master = false;
var starting_pos: Vector2 = Vector2.ZERO;

func setup(_name: String, _is_master: bool, _starting_pos: Vector2):
	name = _name;
	is_master = _is_master;
	starting_pos = _starting_pos;
	
func _ready():
	global_position = starting_pos;
	
	if is_master:
		enable_camera();
	else:
		disable_camera();
	
func send_input(input):
	rpc_unreliable_id(1, "recive_input", input);
	
func enable_camera():
	$Camera.current = true;
	$Camera.show();

func disable_camera():
	$Camera.current = false;
	$Camera.hide();	

func serialize():
	return {
		"n": name,
	}
