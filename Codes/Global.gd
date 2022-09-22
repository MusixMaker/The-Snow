extends Node

export onready var current_noise = 100 

onready var settingsmenu = load("res://Scenes/Pause.tscn")
onready var missing = "res://Scenes/File Not Found.tscn"
var filepath = "res://keybinds.ini"
var default = "res://keybinds_default.ini"
var configfile
var paused
var player_dead = false
onready var player = "res://Codes/Player.gd"

var keybinds = {}

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		paused = true
		add_child(settingsmenu.instance())
		get_tree().paused = true

func _process(delta):
	#var scene = get_tree().get_current_scene().get_name() 
	#print(scene)
	print("Global - ", player_dead)
	#print(paused)
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
	#print(player.hp)

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
	configfile.save(filepath)
