extends Node
class_name Clock

const TIMER_TICK = 1;
const CLOCK_RELOAD = 10;
const LETANECY_ITERATIONS = 9;

var timer: Timer;
var timer_iteration = 1;

var letanecy = [];
var rtt = 0;

var reminder = 0;
var delta_letanecy = 0;
var time = 0;

var first_load = true;

func sync_clock():
	timer = Timer.new();
	timer.autostart = false;
	timer.wait_time = TIMER_TICK;
	timer.connect("timeout", self, "timer_tick");
	add_child(timer);
	timer.start();

# remote methods
remote func recive_time(server_time, client_time):
	letanecy.append((OS.get_system_time_msecs() - client_time) / 2);
	
	if first_load:
		time = server_time + (OS.get_system_time_msecs() - client_time) / 2;
		rtt = (OS.get_system_time_msecs() - client_time) / 2;
		first_load = false;
		
		Networking.rtt_updated(rtt);
		
		rpc_id(1, "clock_synced", Globals.player_credentials);
		
	if letanecy.size() >= LETANECY_ITERATIONS:
		var letanecy_sum = 0;
		letanecy.sort();
		var mid_point = letanecy[4];
		for i in range(letanecy.size() -1, -1, -1):
			if letanecy[i] >= (2 * mid_point) and letanecy[i] >= 110:
				letanecy.remove(i);
			else:
				letanecy_sum += letanecy[i];
				
		delta_letanecy = (letanecy_sum / letanecy.size()) - rtt;
		rtt = letanecy_sum / letanecy.size();
		Networking.rtt_updated(rtt);
		
		letanecy.clear();

#	var test2 = server_time + (OS.get_system_time_msecs() - client_time) / 2;
#	print("t: " + str(time) +", ts: " + str(test2));
#	print(time - test2)
#	pass;

# events
func on_register():
	# time sync
	sync_clock();

func timer_tick():
	rpc_id(1, "get_letanecy", OS.get_system_time_msecs());

# virtual methods

func _physics_process(delta):
	if first_load:
		return;
	time += int(delta * 1000) + delta_letanecy;
	reminder += (delta * 1000) - int(delta * 1000);
	
	delta_letanecy -= delta_letanecy;
	
	if reminder >= 1.0:
		time += 1.0;
		reminder -= 1.0;
