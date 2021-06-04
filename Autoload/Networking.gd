extends Node
signal connected_to_server
signal disconnected_from_server
signal registred
signal time_sync_done

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
	network = null;
	get_tree().network_peer = null;
	is_connection_pending = false;

func disconnect_from_server():
	clear_network();
	pass;

func send_credentials(cred: Dictionary):
	rpc_id(1, "register_player", cred);
# events

func rtt_updated(rtt: int):
	emit_signal("rtt_update", rtt);

func on_connect():
	emit_signal("connected_to_server");
	send_credentials({
		"pn": Globals.DEFAULT_NAME
	})

func on_fail():
	clear_network();

func on_diconnect():
	clear_network();
	emit_signal("connected_to_server");

# remote methods
remote func on_player_register():
	emit_signal("registred");

# virtual methods
func _ready():
	connect_to_server(Globals.DEFAULT_ADDRESS, Globals.DEFAULT_PORT);
