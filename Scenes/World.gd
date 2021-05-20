extends YSort

export var player_scene: PackedScene;

master var s_players = {};

func _ready() -> void:
	Networking.connect("init_network", self, "on_connecetion_init");
	Networking.connect("client_connect", self, "on_c_con");
	Networking.connect("client_disconnect", self, "on_c_disconnect");
	Networking.connect("destroy_network", self, "on_network_destroy");
	pass;
	
func on_connection_init() -> void:
	set_network_master(1);

func on_network_destroy() -> void:
	for player in s_players:
		player.call_deferred("queue_free");
	
	if is_network_master():
		s_players.clear();

func on_c_con(peer_id: int) -> void:
	var id_str = str(peer_id);
	if s_players.has(id_str):
		return;
	s_spawn_player(id_str);
	pass;

func on_c_disconnect(peer_id: int) -> void:
	s_destroy_player(str(peer_id));

func on_connecetion_init() -> void:
	if Networking.app_state == Enums.APP_TYPE.HOST:
		s_spawn_player("1");
	pass;

#server

master func s_spawn_player(player_name: String):
	var player_obj = player_scene.instance();
	#call_deferred("add_child", player_obj);
	add_child(player_obj);
	player_obj.setup(player_name, Vector2(200, 200));
	s_players[player_name] = player_obj;
	var players = s_serialize_players();
	rpc("c_spawn_player", players);

master func s_serialize_players() -> Array:
	var players = [];
	
	for player in s_players.values():
		players.append(player.serialize());
	
	return players;

master func s_destroy_player(player_name: String) -> void:
	if !has_node(player_name):
		return;
	var player = s_players[player_name] as Player;
	player.call_deferred("queue_free");
	s_players[player_name] = null;
	s_players.erase(player_name);
	rpc("c_destroy_player", player_name);
	
#client
puppet func c_spawn_player(players: Array) -> void:
	for player in players:
		if !has_node(player.n):
			var new_player = player_scene.instance();
			add_child(new_player);
			new_player.setup(player.n, player.p);

puppet func c_destroy_player(player_name) -> void:
	if !has_node(player_name):
		return;
	var player = get_node(player_name);
	player.call_deferred("queue_free");
