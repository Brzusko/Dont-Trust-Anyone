extends Node
signal connected_to_server;
signal disconnected_from_server;
signal registred;
signal time_sync_done;
signal fetched_world(world_data);

signal rtt_update(rtt)

var network: NetworkedMultiplayerENet;
var is_connection_pending: bool = false;

onready var scenes = {
	Enums.PLAYER_SCENES.WORLD: preload("res://Scenes/World/World.tscn"),
}

func connect_to_server(address: String, port: int):
	if is_connection_pending:
		return;
		
	is_connection_pending = true;
	network = NetworkedMultiplayerENet.new();
	var _err = network.create_client(address, port);
	
	if _err != OK:
		print("Could create network peer") # add here notification
		is_connection_pending = true;
		return;
	
	var _e = network.connect("connection_succeeded", self, "on_connect");
	var __e = network.connect("connection_failed", self, "on_fail");
	var ___e = network.connect("server_disconnected", self, "on_disconnect");
	
	get_tree().network_peer = network;

func clear_network():
	if network == null:
		return;
		
	network.disconnect("connection_succeeded", self, "on_connect");
	network.disconnect("connection_failed", self, "on_fail");
	network.disconnect("server_disconnected", self, "on_disconnect");
	
	yield(get_tree().create_timer(2.0), "timeout");
	
	get_tree().network_peer = null;
	network = null;

	is_connection_pending = false;

func disconnect_from_server():
	clear_network();
	pass;

func send_credentials(cred: Dictionary):
	rpc_id(1, "register_player", cred);

func send_load_done(cred: Dictionary):
	rpc_id(1, "player_done_loading", cred);

func sync_clock():
	$Clock.sync_clock();
	
func get_time():
	return $Clock.time;
# events

func rtt_updated(rtt: int):
	emit_signal("rtt_update", rtt);

func on_connect():
	emit_signal("connected_to_server");

func on_fail():
	emit_signal("disconnected_from_server");
	clear_network();

func on_disconnect():
	emit_signal("disconnected_from_server");
	clear_network();

# remote methods
remote func on_player_register():
	emit_signal("registred");

remote func on_time_sync():
	emit_signal("time_sync_done");

remote func on_world_fetch(world_data: Dictionary):
	emit_signal("fetched_world", world_data);

