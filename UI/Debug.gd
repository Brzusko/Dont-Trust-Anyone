extends PanelContainer

onready var ping_label: DebugLabel = $Margins/Labels/Ping;
onready var fps_label: DebugLabel = $Margins/Labels/Fps;

const TIMRER_INTERVAL = 5.0;

var timer = 0.0;

# events
func on_rtt(rtt: float):
	ping_label.update_text(str(rtt));

# virtual methods
func _ready():
	Networking.connect("rtt_update", self, "on_rtt");

func _physics_process(delta):
	timer += delta;
	if timer >= TIMRER_INTERVAL:
		timer = TIMRER_INTERVAL;
		fps_label.update_text(str(Engine.get_frames_per_second()));
