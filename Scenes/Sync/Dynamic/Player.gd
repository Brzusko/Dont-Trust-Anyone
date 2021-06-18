extends KinematicBody2D
class_name Player

const MOVE_SPEED = 100;

var is_master = false;
var starting_pos: Vector2 = Vector2.ZERO;
var server_pos: Vector2 = Vector2.ZERO;

var state: Dictionary = {
	"v": Vector2.ZERO,
	"l": 0.0,
	"p": Vector2.ZERO,
	"m": Vector2.ZERO,
	'i': -1,
}

func setup(_name: String, _is_master: bool, _starting_pos: Vector2):
	name = _name;
	is_master = _is_master;
	starting_pos = _starting_pos;
	$PlayerName.update_name(name);

func update_local_state(new_state: Dictionary):
	if !new_state.has_all(state.keys()):
		return;
	state.v = new_state.v;
	state.l = new_state.l;
	state.p = new_state.p if new_state != null else Vector2.ZERO;
	state.m = new_state.m;
	state.i = new_state.i;

func interpolate_states(state_a: Dictionary, state_b: Dictionary, intepolate_factor: float, delta: float):
	var new_pos = lerp(state_a.p, state_b.p, intepolate_factor);
	var new_velocity = lerp(state_a.s.v, state_b.s.v, intepolate_factor).normalized();
	var new_look_side = lerp(state_a.s.l, state_b.s.l, intepolate_factor);
	global_position = new_pos;
	state.v = new_velocity;
	state.l = new_look_side;
	
func _ready():
	global_position = starting_pos;
	
	if is_master:
		enable_camera();
		set_process_input(true);
	else:
		disable_camera();
		set_process_input(false);

func move_player(velocity: Vector2, delta :float):
	move_and_collide(velocity * (delta * MOVE_SPEED));

func send_input(input):
	rpc_unreliable_id(1, "recive_input", input);

func _physics_process(delta):
	$PlayerVisuals.animation_process(state);
	$FOA.process_foa(state);
	move_player(state.v, delta);
	pass;
	
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


		
