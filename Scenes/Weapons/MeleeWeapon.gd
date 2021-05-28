extends Node2D
export var attack_interval: float = 0.3;

signal complete;

func anim(to_pos: Vector2):
	$Tween.interpolate_property(self, 'position', position, to_pos, attack_interval, Tween.TRANS_LINEAR);
	$AnimationPlayer.play("Attack");


func _on_Tween_tween_all_completed():
	pass # Replace with function body.
