extends Label
class_name DebugLabel

onready var base_text: String = text;

func update_text(text_to_add: String):
	text = base_text + " " + text_to_add; 
