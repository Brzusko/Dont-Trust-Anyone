extends Node

func vec2_str(vec2: Vector2) -> String:
	return str(vec2.x) + str(vec2.y);

func clamp_vec2_by_area(clampv2: Vector2, leftv2: Vector2, rightv2: Vector2) -> Vector2:
	var clamped_x = clamp(clampv2.x, leftv2.x, rightv2.x);
	var clamped_y = clamp(clampv2.y, leftv2.y, rightv2.y);
	return Vector2(clamped_x, clamped_y);

func get_node_up(node: NodePath) -> NodePath:
	return NodePath(node.get_name(1));
