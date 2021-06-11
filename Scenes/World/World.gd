extends Node2D
class_name BaseWorld

const RENDER_TIME = 100;

var cached_world_state = {};

var world_states = [];

signal world_load_result(result);
signal server_response(result);

export(PackedScene) var player_scene;

# first non sync, next sync static, next sync dynamic

# TODO - Map world_structure
# TODO - Create new entities
# TODO - Send world to verify
# TODO - Create new entities if necessary
# TODO - Send rpc with information is world created
# TODO - Start syncing data

func map_objects(world_data: Dictionary):
	$Players.create_players(world_data.p);
	
	var new_world_data = {
		"p": $Players.serialize_entities(),
	}
	
	rpc_id(1, "verify_world", new_world_data);
	
	while !yield(self, "server_response"):
		build_missing_entities(cached_world_state);
		new_world_data = {
			"p": $Players.serialize_entities()
		}
		
		yield(get_tree().create_timer(1), "timeout");
		rpc_id(1, "verify_world", new_world_data);

func build_missing_entities(world_data: Dictionary):
	$Players.build_missing_entities(world_data.p);

func _physics_process(delta):
	var render_time = Networking.get_time() - RENDER_TIME;
	
	if world_states.size() < 2:
		return;

	while world_states.size() > 2 && render_time > world_states[1].t:
		world_states.remove(0);
	
	var interpolation_scale = float(render_time - world_states[0].t) / (world_states[1].t - world_states[0].t);
	$Players.process_states(world_states[0].p, world_states[1].p, interpolation_scale);


remote func verify_result(is_fine: bool, world_data: Dictionary):
	cached_world_state = world_data;
	emit_signal("server_response", is_fine);

remote func recive_world_state(_world_state: Dictionary):
	if world_states.empty():
		world_states.append(_world_state);
		return;
		
	var latest_world = world_states[world_states.size() - 1];
	if _world_state.t > latest_world.t:
		world_states.append(_world_state);
