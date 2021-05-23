extends Node

# input sample
#var d = {
#	"s_move_dir": s_move_dir,
#	"s_look_dir": s_look_dir
#}

export var next_state_path: NodePath;
export var animation_tree_path: NodePath;
onready var state_machine: StateMachine = get_parent();
onready var next_state: NodePath = Utils.get_node_up(next_state_path);
var animation_tree: AnimationTree;

master func s_begin():
	if animation_tree == null:
		return;
	animation_tree.set("parameters/Transition/current", 0);
	
master func s_end():
	pass;

master func s_tick(input: Dictionary, delta: float):
	if input.s_move_dir != Enums.MOVE_DIR.NONE:
		state_machine.s_transition(next_state);
		
puppet func c_begin():
	animation_tree.set("parameters/Transition/current", 0);
	pass;

puppet func c_end():
	pass;

puppet func c_tick():
	pass;

func _ready():
	if Networking.app_state <= 1:
		animation_tree = get_node(animation_tree_path);
