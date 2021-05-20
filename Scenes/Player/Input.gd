extends Node2D

mastersync var s_move_dir: int = Enums.MOVE_DIR.NONE;

var local_move_dir: int = Enums.MOVE_DIR.NONE;
var local_look_side: int = Enums.LOOK_SIDE.NONE;
var mouse_dir: Vector2 = Vector2.ZERO;
onready var parent = get_parent() as Player;

var local_cache = {
	"move_dir": Enums.MOVE_DIR.NONE,
	"look_side": Enums.LOOK_SIDE.NONE,
	"mouse_dir": Vector2.ZERO,
}

func _process(delta):
	if !parent.is_local:
		return;
		
	process_inputs();
	check_cache();
	
	update();
	
func check_cache() -> void:
	var send_to_serv: bool = false;
	
	if local_cache.move_dir != local_move_dir:
		local_cache.move_dir = local_move_dir;
		send_to_serv = true;
	
	if local_cache.mouse_dir != mouse_dir:
		local_cache.mouse_dir = mouse_dir;
	
	if send_to_serv:
		rset_unreliable_id(1, "s_move_dir", local_move_dir);
		pass;
		
func process_inputs():
	local_move_dir = Enums.MOVE_DIR.NONE;
	local_look_side = Enums.LOOK_SIDE.NONE;
	
	mouse_dir = get_local_mouse_position().normalized();
	
	if Input.is_action_pressed("up"):
		local_move_dir = Enums.MOVE_DIR.UP;
	if Input.is_action_pressed("down"):
		local_move_dir = Enums.MOVE_DIR.DOWN;

func _draw():
	if !parent.is_local:
		return;
	draw_line(Vector2.ZERO, mouse_dir * 100, Color.blue);
	
