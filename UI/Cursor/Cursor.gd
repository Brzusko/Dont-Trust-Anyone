extends TextureRect

onready var cursor_size: Vector2 = rect_size;

var is_visible: bool = false;

func _ready() -> void:
	Networking.connect("init_network", self, "on_network_init");
	Networking.connect("destroy_network", self, "on_network_destroy");

func _input(event):
	if event is InputEventMouseMotion && is_visible:
		if can_move():
			var relative_pos = event.relative;
			margin_left += relative_pos.x;
			margin_top += relative_pos.y;
		else:
			var cursor_pos = get_cursor_pos_from_center_not_normal();
			move_cursor_relative_to_center(cursor_pos * 0.99);
			
func can_move() -> bool:
	var cursor_relative_pos = get_cursor_pos_from_center_not_normal();
	return cursor_relative_pos.length() <= 150;

func move_cursor_relative_to_center(to_point: Vector2) -> void:
	var center = Vector2(get_viewport().size.x/2, get_viewport().size.y/2);
	margin_left = (center.x + to_point.x);
	margin_top = (center.y + to_point.y);

func get_cursor_pos_from_center() -> Vector2:
	var center = Vector2(get_viewport().size.x/2, get_viewport().size.y/2);
	var cursor_pos = Vector2(margin_left, margin_top);
	var pos = center - cursor_pos;
	return -pos.normalized();

func get_cursor_pos_from_center_not_normal() -> Vector2:
	var center = Vector2(get_viewport().size.x/2, get_viewport().size.y/2);
	var cursor_pos = Vector2(margin_left, margin_top);
	var pos = center - cursor_pos;
	return -pos;

func get_cursor_pos() -> Vector2:
	return Vector2(margin_left, margin_top);

func freeze(to_freeze: bool):
	is_visible = !to_freeze;

func turn_on() -> void:
	show();
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	move_cursor_relative_to_center(Vector2.ZERO);
	is_visible = true;

func turn_off():
	hide();
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	is_visible = false;

func on_network_init() -> void:
	if Networking.app_state == Enums.APP_TYPE.SERVER:
		return;
	turn_on();

func on_network_destroy() -> void:
	if Networking.app_state == Enums.APP_TYPE.SERVER:
		return;
	turn_off();

func set_pos(new_pos: Vector2) -> void:
	margin_left = new_pos.x;
	margin_top = new_pos.y;
