extends Node

# shared
var app_state: int = Enums.APP_TYPE.NONE;
var network: NetworkedMultiplayerENet = null;

signal init_network;
signal destroy_network;
signal client_connect(peer_id);
signal client_disconnect(peer_id);

# host
func s_create_host() -> void:
	network = NetworkedMultiplayerENet.new();
	var _err = network.create_server(Globals.PORT, Globals.MAX_PLAYERS);
	
	if _err != OK:
		return;
	
	get_tree().network_peer = network;
	app_state = Enums.APP_TYPE.HOST;
	s_connect_events();
	print("Created Host");
	emit_signal("init_network");
	
# server
func s_create_server() -> void:
	network = NetworkedMultiplayerENet.new();
	var _err = network.create_server(Globals.PORT, Globals.MAX_PLAYERS);
	
	if _err != OK:
		return;
	get_tree().network_peer = network;
	app_state = Enums.APP_TYPE.SERVER;
	s_connect_events();
	print("Created Server");
	emit_signal("init_network");
	pass;

func s_destroy_sever() -> void:
	s_disconnect_events();
	network = null;
	app_state = Enums.APP_TYPE.NONE;
	emit_signal("destroy_network");
	pass;

func s_connect_events() -> void:
	var __ = network.connect("peer_connected", self, "s_on_c_con"); # s_ stands for server prefix, c_ for client
	var ___ = network.connect("peer_disconnected", self, "s_on_c_disconnect");

func s_disconnect_events() -> void:
	network.disconnect("peer_connected", self, "s_on_c_con"); # s_ stands for server prefix, c_ for client
	network.disconnect("peer_disconnected", self, "s_on_c_disconnect");
	pass;

func s_on_c_con(peer_id: int) -> void:
	print("Client connected: " + str(peer_id));
	emit_signal("client_connect", peer_id);
	pass;

func s_on_c_disconnect(peer_id: int) -> void:
	print("Client disconnect: " + str(peer_id));
	emit_signal("client_disconnect", peer_id);
	pass;
	
# client
func c_create_client(address: String) -> void:
	var split = address.split(':');
	if split.size() < 2:
		print("Provided wrong address");
		return;
	
	var ip = split[0];
	var port = int(split[1]);
	
	network = NetworkedMultiplayerENet.new();
	var _err = network.create_client(ip, port);
	if _err != OK:
		print("Could not create client");
		return;
	
	get_tree().network_peer = network;
	c_connect_client_events();
	# here next implementation

func c_connect_client_events() -> void:
	var __ = network.connect("connection_succeeded", self, "c_on_con"); # c_ stands for client prefix
	var ___ = network.connect("connection_failed", self, "c_on_con_failed");
	var ____ = network.connect("server_disconnected", self, "c_on_srv_disconnect");

func c_disconnect_client_events() -> void:
	network.disconnect("connection_succeeded", self, "c_on_con");
	network.disconnect("connection_failed", self, "c_on_con_failed");
	network.disconnect("server_disconnected", self, "c_on_srv_disconnect");
	
func c_destroy_client() -> void:
	c_disconnect_client_events();
	network = null;
	app_state = Enums.APP_TYPE.NONE; 
	emit_signal("destroy_network");

func c_on_con() -> void:
	app_state = Enums.APP_TYPE.CLIENT;
	emit_signal("init_network");
	print("Connection succed");

func c_on_con_failed() -> void:
	print("Connection failed");
	c_destroy_client();

func c_on_srv_disconnect() -> void:
	print("Disconnected from server");
	c_destroy_client();

func _ready() -> void:
	pass;
