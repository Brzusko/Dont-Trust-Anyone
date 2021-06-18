extends Node2D

const DEBUG_RAY = 50;
const POINTER_MOVE_SPEED = 0.05;

enum ROTATION {
	UP,
	LEFT,
	RIGHT,
	DOWN,
	NONE
}

const rotation_dict = {
	ROTATION.UP: 0,
	ROTATION.LEFT: -90,
	ROTATION.RIGHT: 90,
	ROTATION.DOWN: -180,
}

onready var vector_map: Dictionary = {
	Vector2.ZERO: ROTATION.UP,
	Vector2.UP: ROTATION.UP,
	Vector2.DOWN: ROTATION.DOWN,
	Vector2.LEFT: ROTATION.LEFT,
	Vector2.RIGHT: ROTATION.RIGHT,
	(Vector2.UP + Vector2.LEFT).normalized(): ROTATION.LEFT,
	(Vector2.DOWN + Vector2.LEFT).normalized(): ROTATION.LEFT,
	(Vector2.UP + Vector2.RIGHT).normalized(): ROTATION.RIGHT,
	(Vector2.DOWN + Vector2.RIGHT).normalized(): ROTATION.RIGHT,
}

export var forward_vec: Vector2 = Vector2.UP;
var left_bound: Vector2 = Vector2.ZERO;
var righ_bound: Vector2 = Vector2.ZERO;
var pointer: Vector2 = Vector2.UP;
var pointer_foa_left: Vector2;
var pointer_foa_riht: Vector2;
var angle_to: float = 0.0;
var cached_last_input_id: int = -1;

func calc_boundaries():
	left_bound = forward_vec.rotated(deg2rad(80));
	righ_bound = forward_vec.rotated(deg2rad(-80));
	pass;
	
func rotate_pointer(pointer_pos: Vector2):
	var pointer_move_direction = clamp(pointer_pos.x, -1.0, 1.0);
	print(pointer_move_direction);
	pointer_move_direction = -1 if pointer_move_direction < 0 else 1;
	
	if rotation_degrees == rotation_dict[ROTATION.DOWN]:
		pointer_move_direction = -pointer_move_direction;
	
	var rotated_pointer = pointer.rotated(pointer_move_direction * POINTER_MOVE_SPEED);
	if can_rotate_pointer(rotated_pointer):
		pointer = rotated_pointer
	
	var pointer_foa_left_rotated = pointer.rotated(deg2rad(-45));
	var pointer_foa_right_rotated = pointer.rotated(deg2rad(45));
	
	if can_rotate_pointer(pointer_foa_left_rotated):
		pointer_foa_left = pointer_foa_left_rotated;
	
	if can_rotate_pointer(pointer_foa_right_rotated):
		pointer_foa_riht = pointer_foa_right_rotated;
	
func can_rotate_pointer(vec_to_test):
	return forward_vec.dot(vec_to_test) >= 0.16;

func rotate_foa(rotation_index: int):
	rotation_degrees = rotation_dict[rotation_index];

func process_foa(input: Dictionary):
	if cached_last_input_id == input.i:
		return;
	
	var rotation_id = vector_map[input.v];
	rotate_foa(rotation_id);
	rotate_pointer(input.m);
	calc_boundaries();
	cached_last_input_id = input.i;

func _process(_delta):
	update();

func _draw():
	draw_circle(Vector2.ZERO, 10.0, Color.white);
	draw_line(Vector2.ZERO, forward_vec * DEBUG_RAY, Color.blue);
	draw_line(Vector2.ZERO, left_bound * DEBUG_RAY, Color.red);
	draw_line(Vector2.ZERO, righ_bound * DEBUG_RAY, Color.red);
	draw_line(Vector2.ZERO, pointer * DEBUG_RAY, Color.white);
	draw_line(Vector2.ZERO, pointer_foa_left * DEBUG_RAY, Color.yellow);
	draw_line(Vector2.ZERO, pointer_foa_riht * DEBUG_RAY, Color.yellow);
