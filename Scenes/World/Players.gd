extends YSort
signal players_created;

var player_objects = {};

export(PackedScene) var player_scene;

func create_player(player: Dictionary):
	var player_obj = player_scene.instance() as Player;
	player_obj.setup(player.n, Globals.player_credentials.pn == player.n, player.p);
	player_objects[player_obj.name] = player_obj.serialize();
	add_child(player_obj);

func create_players(players: Dictionary):
	for player in players.values():
		create_player(player);
	return emit_signal("players_created");

func process_states(current_players: Dictionary, feature_players: Dictionary, interpolation: float, delta: float):
	for player in current_players.values():
		
		if !player_objects.has(player.n):
			if feature_players.has(player.n):
				create_player(player);
			continue;
		if !feature_players.has(player.n):
			continue;
		
		
		var player_obj = get_node(player.n) as Player;
		
		if player_obj.is_master:
			var player_inputs = player_obj.get_node("Input") as PlayerInput;
			var inputs = player_inputs.unprocessed_inputs.values();
			
			player_obj.global_position = feature_players[player.n].p;
			
			var i = 0;
			
			while i < inputs.size():
				if inputs[i].i <= feature_players[player.n].li:
					player_inputs.unprocessed_inputs.erase(inputs[i].i);
				else:
					player_obj.move_player(inputs[i].v, delta);
			
				i +=1;
			continue;
#
		
		var new_pos = lerp(player.p, feature_players[player.n].p, interpolation);
		player_obj.global_position = new_pos;

		

func build_missing_entities(entities: Array):
	for entitie in entities:
		if player_objects.has(entitie.n):
			continue;
		create_player(entitie);
		
func serialize_entities():
	return player_objects.values().duplicate(true);
