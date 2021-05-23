extends Node

# input sample
#var d = {
#	"s_move_dir": s_move_dir,
#	"s_look_dir": s_look_dir
#}

# TODO Implement position interpolation on client side

export var next_state: NodePath;
export var kinematic_body_path: NodePath;
export var animation_tree_path: NodePath;
export var head_path: NodePath;
export var body_path: NodePath;
export var stats_path: NodePath;
export var move_speed: float = 10.0;
onready var state_machine: StateMachine = get_parent();
onready var kinematic_body: KinematicBody2D = get_node(kinematic_body_path);
var animation_tree: AnimationTree;
onready var head: Sprite = get_node(head_path);
onready var body: Sprite = get_node(body_path);
onready var stats = get_node(stats_path);

var move_dir_cache: int = -1;

puppet var c_pos: Vector2 = Vector2.ZERO;

const MOVMENT_MAP = {
	Enums.MOVE_DIR.UP: Vector2.UP,
	Enums.MOVE_DIR.UP_LEFT: Vector2.UP + Vector2.LEFT,
	Enums.MOVE_DIR.UP_RIGHT: Vector2.UP + Vector2.RIGHT,
	Enums.MOVE_DIR.DOWN: Vector2.DOWN,
	Enums.MOVE_DIR.DOWN_LEFT: Vector2.DOWN + Vector2.LEFT,
	Enums.MOVE_DIR.DOWN_RIGHT: Vector2.DOWN + Vector2.RIGHT,
	Enums.MOVE_DIR.LEFT: Vector2.LEFT,
	Enums.MOVE_DIR.RIGHT: Vector2.RIGHT,
	Enums.MOVE_DIR.NONE: Vector2.ZERO,
}

master func s_begin():
	if animation_tree == null:
		return;
	animation_tree.set("parameters/Transition/current", 1);

master func s_end():
	pass;

master func s_tick(input: Dictionary, delta: float):
	if input.s_move_dir == Enums.MOVE_DIR.NONE:
		state_machine.s_transition(NodePath(next_state.get_name(1)));
	kinematic_body.move_and_collide((MOVMENT_MAP[input.s_move_dir] * move_speed) * delta);
	
	if move_dir_cache != input.s_move_dir:
		move_dir_cache = input.s_move_dir;
		if move_dir_cache <= 2:
			rpc("flip_look", false);
		elif move_dir_cache > 2 && move_dir_cache <= 5:
			rpc("flip_look", true);
	
	rset_unreliable("c_pos", kinematic_body.global_position);
		
puppet func c_begin():
	animation_tree.set("parameters/Transition/current", 1);
	pass;

puppet func c_end():
	pass;

puppet func c_tick():
	kinematic_body.global_position = c_pos;
	pass;

remotesync func flip_look(side: bool):
	body.flip_h = side;
	head.flip_h = side;

func _ready():
	if Networking.app_state <= 1:
		animation_tree = get_node(animation_tree_path);
