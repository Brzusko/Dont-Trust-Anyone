extends CanvasLayer

func change_cursor_pos(to_point: Vector2) -> void:
	$Cursor.move_cursor_relative_to_center(to_point);

func get_cursor_local_pos() -> Vector2:
	return $Cursor.get_cursor_pos_from_center();

func get_cursor_pos() -> Vector2:
	return $Cursor.get_cursor_pos();

func freeze_cursor(to_freeze: bool):
	$Cursor.freeze(to_freeze);

func set_cursor_pos(new_pos: Vector2) -> void:
	$Cursor.set_pos(new_pos);
