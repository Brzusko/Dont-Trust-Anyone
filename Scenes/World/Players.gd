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
			continue;
		if !feature_players.has(player.n):
			continue;
			
		var player_obj = get_node(player.n) as Player;
		
		if player_obj.is_master:
			var player_input = player_obj.get_node("Input") as PlayerInput;
			var unprocessed_size = player_input.unprocessed_inputs.size() - 1;
			var unprocessed_inputs = player_input.unprocessed_inputs.values();

			for input in unprocessed_inputs:
				if input.i <= feature_players[player.n].li:
					player_input.unprocessed_inputs.erase(input.i);

			var roll_back = player_input.unprocessed_inputs.values();

			if roll_back.empty():
				return;

			var roll_back_pos: Vector2 = player_obj.global_position;

			var roll_back_vec: Vector2 = Vector2.ZERO;
			for i in range(roll_back.size() -1, -1, -1):
				roll_back_vec += (roll_back[i].v * (delta * 100));
				pass;

			roll_back_vec = -roll_back_vec;
			var rolled_back = roll_back_pos + roll_back_vec;
			var is_prediction_corret = feature_players[player.n].p == rolled_back;

			if is_prediction_corret:
				return;

			player_obj.global_position = feature_players[player.n].p;

			for vec in roll_back:
				player_obj.move_and_collide(vec.v * (delta * player_obj.MOVE_SPEED));
		else:
			pass;
			
		var new_pos = lerp(player.p, feature_players[player.n].p, interpolation);
		player_obj.global_position = new_pos;
#			if !player_input.unprocessed_inputs.empty():
#				print("Last input: " + str(player_input.unprocessed_inputs[unprocessed_size]) + " , server: " + str(feature_players[player.n].li));
#			pass;

		

func build_missing_entities(entities: Array):
	for entitie in entities:
		if player_objects.has(entitie.n):
			continue;
		create_player(entitie);
		
func serialize_entities():
	return player_objects.values().duplicate(true);
