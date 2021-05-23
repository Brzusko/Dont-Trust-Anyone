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
			if margin_left <= 0:
				margin_left = 1;
			if (margin_left + rect_size.x) >= get_viewport().size.x:
				margin_left += get_viewport().size.x - (margin_left + rect_size.x)
			if margin_top <= 0:
				margin_top = 1;
			if (margin_top + rect_size.y) >= get_viewport().size.y:
				margin_top += get_viewport().size.y - (margin_top + rect_size.y);

func can_move() -> bool:
	var x_bound = margin_left >= 0 && (margin_left + rect_size.x) <= get_viewport().size.x;
	var y_bound = margin_top >= 0 && (margin_top + rect_size.y) <= get_viewport().size.y;
	return x_bound && y_bound;

func move_cursor_relative_to_center(to_point: Vector2) -> void:
	var center = Vector2(get_viewport().size.x/2, get_viewport().size.y/2);
	margin_left = center.x - (rect_size.y/2);
	margin_top = center.y - (rect_size.y/2);

func get_cursor_pos_from_center() -> Vector2:
	var center = Vector2(get_viewport().size.x/2, get_viewport().size.y/2);
	var cursor_pos = Vector2(margin_left, margin_top);
	var pos = center - cursor_pos;
	return pos.normalized();

func turn_on():
	show();
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	move_cursor_relative_to_center(Vector2.ZERO);
	is_visible = true;

func turn_off():
	hide();
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	is_visible = false;

func on_network_init() -> void:
	turn_on();

func on_network_destroy() -> void:
	turn_off();
