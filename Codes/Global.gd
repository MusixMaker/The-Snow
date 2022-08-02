extends Node

export onready var current_noise = 100 

onready var settingsmenu = load("res://Scenes/Pause.tscn")
onready var missing = "res://Scenes/File Not Found.tscn"
var filepath = "res://keybinds.ini"
var configfile

var keybinds = {}

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		var paused = true
		add_child(settingsmenu.instance())
		get_tree().paused = true

func _process(delta):
	#print("Global - ", current_noise)
	pass
func _ready():
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			print(key, " : ", OS.get_scancode_string(key_value))
			
			keybinds[key] = key_value
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().change_scene(missing)
		
	set_game_binds()

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
			
		var new_key = InputEventKey.new()
		new_key.set_scancode(value)
		InputMap.action_add_event(key, new_key)
