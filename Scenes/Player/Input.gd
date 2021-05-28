extends Node2D
class_name StateInput

master var s_move_dir: int = Enums.MOVE_DIR.NONE;
master var s_look_dir: int = Enums.LOOK_SIDE.NONE;
master var s_is_attacking: bool = false;
master var s_is_blocking: bool = false;

var local_move_dir: int = Enums.MOVE_DIR.NONE;
var local_look_side: int = Enums.LOOK_SIDE.NONE;
var local_look_side_vec2: Vector2 = Vector2.ZERO;
var local_aim_dir: Vector2 = Vector2.ZERO;
var local_is_blocking: bool = false;
var local_is_attacking: bool = false;

var intersect_point: Vector2 = Vector2.ZERO;

var aim_vertices: Array = [
	Vector2.LEFT,
	Vector2.RIGHT,
]

var fov: Array = [
	Vector2.LEFT,
	Vector2.RIGHT
];

var mouse_dir: Vector2 = Vector2.ZERO;

var local_cache = {
	"move_dir": Enums.MOVE_DIR.NONE,
	"look_side": Enums.LOOK_SIDE.NONE,
	"mouse_dir": Vector2.ZERO,
	"look_side_vec2": Vector2.ZERO,
	"is_attacking": false,
	"is_blocking": false,
};

var move_directions: Dictionary = {
	"00": Enums.MOVE_DIR.NONE,
	"10": Enums.MOVE_DIR.UP,
	"11": Enums.MOVE_DIR.UP_LEFT,
	"1-1": Enums.MOVE_DIR.UP_RIGHT,
	"01": Enums.MOVE_DIR.LEFT,
	"0-1": Enums.MOVE_DIR.RIGHT,
	"-10": Enums.MOVE_DIR.DOWN,	
	"-11": Enums.MOVE_DIR.DOWN_LEFT,
	"-1-1": Enums.MOVE_DIR.DOWN_RIGHT,
}

var look_directions: Dictionary = {
	"00": local_cache.look_side,
	"10": Enums.LOOK_SIDE.UP,
	"11": Enums.LOOK_SIDE.UP,
	"1-1": Enums.LOOK_SIDE.UP,
	"01": Enums.LOOK_SIDE.LEFT,
	"0-1": Enums.LOOK_SIDE.RIGHT,
	"-10": Enums.LOOK_SIDE.DOWN,	
	"-11": Enums.LOOK_SIDE.DOWN,
	"-1-1": Enums.LOOK_SIDE.DOWN,
}

var vector_map: Dictionary = {
	Enums.LOOK_SIDE.NONE: Vector2.ZERO,
	Enums.LOOK_SIDE.UP: Vector2.UP,
	Enums.LOOK_SIDE.DOWN: Vector2.DOWN,
	Enums.LOOK_SIDE.LEFT: Vector2.LEFT,
	Enums.LOOK_SIDE.RIGHT: Vector2.RIGHT,
}

onready var parent = get_parent() as Player;

export var hands_path: NodePath;
onready var hands = get_node(hands_path) as Hands;

func _process(delta):
	if !parent.is_local:
		return;
		
	process_inputs();
	check_cache();
	
	update();

func generate_data() -> void:
	local_move_dir = Enums.MOVE_DIR.UP;
	local_look_side = Enums.LOOK_SIDE.UP;
	local_look_side_vec2 = Vector2.UP;
	local_aim_dir = Vector2.UP;
	
	aim_vertices[0] = local_aim_dir.rotated(deg2rad(Globals.MEELE_ANGLE));
	aim_vertices[1] = local_aim_dir.rotated(deg2rad(-Globals.MEELE_ANGLE));
	
	GameUi.change_cursor_pos(vector_map[local_look_side] * 100);
	mouse_dir = GameUi.get_cursor_local_pos();
	
	fov[0] = local_cache.look_side_vec2.rotated(deg2rad(80));
	fov[1] = local_cache.look_side_vec2.rotated(deg2rad(-80));

	local_cache = {
		"move_dir": local_move_dir,
		"look_side": local_look_side,
		"mouse_dir": mouse_dir,
		"look_side_vec2": local_look_side_vec2,
		"is_attacking": false,
		"is_blocking": false,
	};
	
	hands.rotate_hands(local_aim_dir * 50);
	
	rset_unreliable_id(1, "s_move_dir", local_move_dir);
	rset_unreliable_id(1, "s_look_dir", local_look_side);
	
func check_cache() -> void:
	var send_to_serv: bool = false;
	
	if local_cache.move_dir != local_move_dir:
		local_cache.move_dir = local_move_dir;
		send_to_serv = true;
	
	if local_cache.look_side != local_look_side && local_look_side != Enums.LOOK_SIDE.NONE:
		local_cache.look_side = local_look_side;
		GameUi.change_cursor_pos(vector_map[local_look_side] * 100);
		local_aim_dir = vector_map[local_look_side];
		hands.rotate_hands(local_aim_dir * 50);
		aim_vertices[0] = local_aim_dir.rotated(deg2rad(Globals.MEELE_ANGLE));
		aim_vertices[1] = local_aim_dir.rotated(deg2rad(-Globals.MEELE_ANGLE));
		send_to_serv = true;
	
	if local_cache.look_side_vec2 != local_look_side_vec2 && local_look_side != Enums.LOOK_SIDE.NONE:
		local_cache.look_side_vec2 = local_look_side_vec2;
	
	if local_cache.is_attacking != local_is_attacking:
		local_cache.is_attacking = local_is_attacking;
		send_to_serv = true;
	
	if local_cache.is_blocking != local_is_blocking:
		local_cache.is_blocking = local_is_blocking;
		send_to_serv = true;
	
	fov[0] = local_cache.look_side_vec2.rotated(deg2rad(80));
	fov[1] = local_cache.look_side_vec2.rotated(deg2rad(-80));
	
	if send_to_serv:
		rset_unreliable_id(1, "s_move_dir", local_move_dir);
		rset_unreliable_id(1, "s_look_dir", local_look_side);
		rset_id(1, "s_is_attacking", local_is_attacking);
		rset_id(1, "s_is_blocking", local_is_attacking);
	

	
func process_inputs() -> void:
	local_move_dir = Enums.MOVE_DIR.NONE;
	
	var up_down_strength = Input.get_action_strength("up") + ( - Input.get_action_strength("down"));
	var left_right_strength = Input.get_action_strength("left") + ( - Input.get_action_strength("right"));
	var unit_vector = Vector2(up_down_strength, left_right_strength);
	
	local_move_dir = move_directions[Utils.vec2_str(unit_vector)];
	
	local_look_side = look_directions[Utils.vec2_str(unit_vector)];
	local_look_side_vec2 = vector_map[local_look_side];
	
	local_is_attacking = Input.is_action_pressed("attack");
	local_is_blocking = Input.is_action_pressed("block");

func _input(event):
	if event is InputEventMouseMotion && parent.is_local:
		mouse_dir = GameUi.get_cursor_local_pos();
		
		if local_cache.look_side_vec2.dot(mouse_dir) >= Globals.AREA_DOT:
			local_aim_dir = mouse_dir;
			intersect_point = GameUi.get_cursor_pos();
			hands.rotate_hands(local_aim_dir * 50);
		else:
			GameUi.set_cursor_pos(intersect_point);
		
		if local_cache.look_side_vec2.dot(local_aim_dir.rotated(deg2rad(Globals.MEELE_ANGLE))) >= Globals.AREA_DOT:
			aim_vertices[0] = local_aim_dir.rotated(deg2rad(Globals.MEELE_ANGLE));
		
		if local_cache.look_side_vec2.dot(local_aim_dir.rotated(deg2rad(-Globals.MEELE_ANGLE))) >= Globals.AREA_DOT:
			aim_vertices[1] = local_aim_dir.rotated(deg2rad(-Globals.MEELE_ANGLE));

func get_networked_input() -> Dictionary:
	return {
		"s_move_dir": s_move_dir,
		"s_look_dir": s_look_dir
	}

func _draw() -> void:
	if !parent.is_local:
		return;
	draw_line(Vector2.UP * 10, local_aim_dir * 100, Color.white);
	draw_line(Vector2.UP * 10, local_cache.look_side_vec2 * 100, Color.blue);
	draw_line(Vector2.UP * 10, fov[0].normalized() * 100, Color.red);
	draw_line(Vector2.UP * 10, fov[1].normalized() * 100, Color.red);
	for vec in aim_vertices:
		draw_line(Vector2.UP * 10, vec * 100, Color.green);
	pass;
