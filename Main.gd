extends Node2D

export(Array, String, FILE) var scenes = [];

const start_game_stages: Array = [
	"Time sync",
	"Fetching World Data",
	"Loading World",
	"Creating Entities",
	"Done"
]

func _ready():
	Networking.connect("connected_to_server", self, "on_connect");
	Networking.connect("registred", self, "on_register");
	Networking.connect("time_sync_done", self, "on_time_sync");
	Networking.connect("disconnected_from_server", self, "on_disconnect");
	set_process(false);

func join_to_game():
	$UI/LoadingScreen.define_loading("Loading World", start_game_stages);
	$UI/LoadingScreen.show();
	$UI/LoadingScreen.start_loading();

func on_connect():
	$UI/StartMenu.hide();
	join_to_game();
	Networking.send_credentials(Globals.player_credentials);

func on_disconnect():
	pass;
	
func on_register():
	Networking.sync_clock();

func on_time_sync():
	$UI/LoadingScreen.step();

func _process(delta):
	pass;
