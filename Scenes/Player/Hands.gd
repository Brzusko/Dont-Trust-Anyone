extends Position2D
class_name Hands

onready var parent = get_parent() as Player;

var hand_state = true;
var can_attack = true;

onready var hands: Dictionary = {
	false: $Left,
	true: $Right
}

func _ready():
	$MeeleWeapon.position = hands[hand_state].position;

func _process(delta):
	if !parent.is_local:
		return;
	update();
	
	if Input.is_action_pressed("attack"):
		c_attack();

func _draw():
	draw_circle($Left.position, 3, Color.black);
	draw_circle($Right.position, 3, Color.white);

func rotate_hands(to_point: Vector2):
	var calc_rot = Vector2.ZERO.angle_to_point(to_point);
	rotation = calc_rot;

func s_attack():
	pass;

func c_attack():
	if !can_attack:
		return;
	hand_state = !hand_state;
	var new_wep_pos = hands[hand_state].position;
	print(new_wep_pos);
	can_attack = false;
	$MeeleWeapon.anim(new_wep_pos);
	print("can attack");
	can_attack = true;
