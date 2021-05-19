extends ColorRect

export(NodePath) var server_address;
onready var address_test: RegEx = RegEx.new();

func _ready():
	#address_test.compile("([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\:?([0-9]{1,5})?");
	pass # Replace with function body.


func _on_HostBTN_pressed():
	Networking.create_host();
	pass # Replace with function body.


func _on_ServerBTN_pressed():
	Networking.create_server();
	pass # Replace with function body.


func _on_ConnectBTN_pressed():
	Networking.create_client();
	pass # Replace with function body.
