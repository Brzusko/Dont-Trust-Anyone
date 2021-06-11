extends Panel

onready var name_field = $Form/Name/LineEdit;
onready var address_field = $Form/Address/LineEdit;
onready var port_field = $Form/Port/LineEdit;

func can_connect():
	return (name_field.text.length() 
	+ port_field.text.length() 
	+ address_field.text.length()) >= 3;

func _on_ConnectBTN_pressed():
	if !can_connect():
		return;
	Globals.set_credentials({
		"pn": name_field.text,
	})
	Networking.connect_to_server(address_field.text, int(port_field.text));
