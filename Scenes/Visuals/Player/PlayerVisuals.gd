extends Node2D

onready var at: AnimationTree = $AnimationTree;

func _ready():
	at.active = true;

func play_idle():
	at.set("parameters/Motion/current", 0);

func play_running():
	at.set("parameters/Motion/current", 1);

func animation_process(input: Dictionary):
	match input.v:
		Vector2.ZERO:
			play_idle();
		_:
			play_running();
	var clamped_look_scale = -1.0 if input.l < 0 else 1.0;
	flip_character(clamped_look_scale);

func flip_character(look_scale: float):
	scale.x = look_scale;
