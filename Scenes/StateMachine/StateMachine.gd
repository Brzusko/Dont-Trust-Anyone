extends Node
class_name StateMachine

export var input_path: NodePath;
export var starting_state: NodePath;
onready var input: StateInput = get_node(input_path);

var current_state;

master func s_transition(state: NodePath):
	if current_state != null:
		current_state.s_end();
	current_state = get_node(state);
	current_state.s_begin();
	rpc("c_transition", state);

master func s_tick(delta):
	if current_state == null:
		return;
	current_state.s_tick(input.get_networked_input(), delta);

puppet func c_transition(state: NodePath):
	if current_state != null:
		current_state.c_end();
	current_state = get_node(state);
	current_state.c_begin();

puppet func c_tick(delta):
	if current_state == null:
		return;
	current_state.c_tick();

func _physics_process(delta):
	if is_network_master():
		s_tick(delta);
	else:
		c_tick(delta);

func _ready():
	if is_network_master():
		s_transition(starting_state);
