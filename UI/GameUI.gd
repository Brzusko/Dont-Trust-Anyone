extends CanvasLayer

func change_cursor_pos(to_point: Vector2) -> void:
	$Cursor.move_cursor_relative_to_center(to_point);

func get_cursor_local_pos() -> Vector2:
	return $Cursor.get_cursor_pos_from_center();
