extends ColorRect

onready var address_test: RegEx = RegEx.new();

func _ready():
	#address_test.compile("\\([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3})\\:?([0-9]{1,5})?");
	# TODO - Rewrite regex above that works in gd_script
	var __ = Networking.connect("init_network", self, "on_init_network");
	var ___ = Networking.connect("destroy_network", self, "on_destroy_network");
	pass # Replace with function body.

func on_init_network() -> void:
	hide();

func on_destroy_network() -> void:
	show();
	
func _on_HostBTN_pressed() -> void:
	Networking.s_create_host();
	pass # Replace with function body.


func _on_ServerBTN_pressed() -> void:
	Networking.s_create_server();
	pass # Replace with function body.

func _on_ConnectBTN_pressed() -> void:
	var address = $Container/BottomContainer/HBoxContainer/ServerPath.text;
	if address.length() < 9:
		print("Address is wrong")
		return;
	Networking.c_create_client(address);

func _on_ServerPath_text_changed(new_text) -> void:
	pass;
