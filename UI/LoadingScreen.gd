extends Panel

var current_loading_stage: Array;
var current_step = 0;
var current_title: String = "";

onready var anim_player: AnimationPlayer = $AnimationPlayer;

func _ready():
	define_loading("Join to room", [
		"Test1",
		"Test2",
		"Test3",
		"Test4"
	])
	start_loading();

func define_loading(title: String, loading_stages: Array):
	current_loading_stage = loading_stages;
	current_title = title;

func update_ui():
	$Title.text = current_title;
	$LoadingStage.update_text(current_loading_stage[current_step]);

func start_loading():
	anim_player.play("DotAnim");
	update_ui();

func loading_done():
	anim_player.stop();
	current_loading_stage.clear();
	current_step = 0;
	current_title = "";

func step():
	current_step += 1;
	if current_step >= current_loading_stage.size():
		loading_done();
		return;
	update_ui();
		
