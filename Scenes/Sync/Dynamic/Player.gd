extends KinematicBody2D
class_name Player

const MOVE_SPEED = 100;

var is_master = false;
var starting_pos: Vector2 = Vector2.ZERO;
var server_pos: Vector2 = Vector2.ZERO;

var delta_test = 0.0;
var dalta_max = 10;

func setup(_name: String, _is_master: bool, _starting_pos: Vector2):
	name = _name;
	is_master = _is_master;
	starting_pos = _starting_pos;
	
func _ready():
	global_position = starting_pos;
	
	if is_master:
		enable_camera();
		set_physics_process(true);
		set_process_input(true);
	else:
		disable_camera();
		set_physics_process(false);
		set_process_input(false);
	
func send_input(input, delta):
	move_and_collide(input.v * (delta * MOVE_SPEED));
	rpc_unreliable_id(1, "recive_input", input);
	
func enable_camera():
	$Camera.current = true;
	$Camera.show();

func disable_camera():
	$Camera.current = false;
	$Camera.hide();	

func _physics_process(delta):
	pass;

func serialize():
	return {
		"n": name,
	}

func _draw():
	if !is_master:
		return;
	draw_circle(to_local(server_pos), 5.0, Color.red);

		
