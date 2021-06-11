extends Panel

var current_loading_stage: Array;
var current_step = 0;
var current_title: String = "";

export var next_ui_path: NodePath;
export var failure_ui_path: NodePath;

onready var anim_player: AnimationPlayer = $AnimationPlayer;
onready var next_ui_node = get_node(next_ui_path);
onready var failure_ui = get_node(failure_ui_path);

func define_loading(title: String, loading_stages: Array):
	current_loading_stage = loading_stages.duplicate();
	current_title = title;

func update_ui():
	$Title.text = current_title;
	$LoadingStage.update_text(current_loading_stage[current_step]);

func start_loading():
	anim_player.play("DotAnim");
	update_ui();
	show();

func loading_done(failure: bool = false):
	anim_player.stop();
	current_loading_stage.clear();
	current_step = 0;
	current_title = "";
	hide();
	
	if failure:
		failure_ui.show();
	else:
		next_ui_node.show();

func step():
	current_step += 1;
	update_ui();
	if current_step >= current_loading_stage.size() - 1:
		yield(get_tree().create_timer(1), "timeout");
		loading_done();
		return;
		
