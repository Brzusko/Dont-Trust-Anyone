extends Node

const DEFAULT_NAME = "Zdzisiek";
const DEFAULT_ADDRESS = "127.0.0.1";
const DEFAULT_PORT = 9090;
const VERSION = "0.0.0";
const CREDENTIALS_FIELDS = [
	"pn"
]

var movement_actions = ["up", "right", "down", "left", "right"];

var player_credentials: Dictionary = {};

func set_credentials(cred: Dictionary):
	player_credentials = cred;

func are_credentials_valid():
	return player_credentials.has_all(CREDENTIALS_FIELDS);
