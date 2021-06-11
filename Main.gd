extends Node2D

# TODO rewrite

export(String, FILE, "*.tscn") var world_scene: String;

const start_game_stages: Array = [
	"Time sync",
	"Fetching World Data",
	"Loading World",
	"Creating Entities",
	"Done"
];

var current_world_resources: Array = [];
var current_world_data: Dictionary;

func _ready():
	var _e = Networking.connect("connected_to_server", self, "on_connect");
	var __e = Networking.connect("registred", self, "on_register");
	var ___e = Networking.connect("time_sync_done", self, "on_time_sync");
	var ____e = Networking.connect("disconnected_from_server", self, "on_disconnect");
	var _____e = Networking.connect("fetched_world", self, "on_world_data");
	set_process(false);

# events
func join_to_game():
	$UI/LoadingScreen.define_loading("Loading World", start_game_stages);
	$UI/LoadingScreen.start_loading();

func on_connect():
	$UI/StartMenu.hide();
	join_to_game();
	Networking.send_credentials(Globals.player_credentials);

func on_disconnect():
	$UI/LoadingScreen.loading_done(true);
	get_child(get_child_count() - 1).call_deferred("free");
	add_child(Node2D.new());
	
func on_register():
	Networking.sync_clock();

func on_time_sync():
	$UI/LoadingScreen.step();

func on_world_data(world_data: Dictionary):
	$UI/LoadingScreen.step();
	
	var new_world = load(world_scene).instance();
	new_world.name = "World";
	
	$UI/LoadingScreen.step();
	
	
	get_child(get_child_count() - 1).call_deferred("free");
	add_child(new_world);
	
	yield(new_world.map_objects(world_data), "completed");
	
	$UI/LoadingScreen.step();
	
	Networking.send_load_done(Globals.player_credentials);
# utils

# virtual
	
	
	

