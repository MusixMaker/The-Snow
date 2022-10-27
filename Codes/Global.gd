extends Node

#Sets original slider and noise level to the max of 100
export onready var current_noise = 100 

#Mixed (sorry) variables and setting up variables of need paths
onready var settingsmenu = load("res://Scenes/Pause.tscn")
onready var missing = "res://Scenes/File Not Found.tscn"
var filepath = "res://keybinds.ini"
var default = "res://keybinds_default.ini"
var configfile
var paused
var player_dead = false
onready var fireworm_dir
onready var player = "res://Codes/Player.gd"

#Gets keybinds from file and lists them
var keybinds = {}

#If at any time escape is pressed, it pauses this code and also opens the pause menu
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		paused = true
		add_child(settingsmenu.instance())
		get_tree().paused = true

#Happens constantly, throwaway anytime I needed a print of any given variable for checking purposes, that happened here
func _process(delta):
	#var scene = get_tree().get_current_scene().get_name() 
	#print(scene)
	#print("Global - ", player_dead)
	#print(paused)
	#print(fireworm_dir)
	pass

#Happens once at startup of game
func _ready():
	#Sets up a new config file with the keybinds, and prints them out in debugger at game start
	configfile = ConfigFile.new()
	#Checks it all loads correctly
	if configfile.load(filepath) == OK:
		#For every numberline on the config file, the corresponding in game keys are found, and printed out
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			print(key, " : ", OS.get_scancode_string(key_value))
			
			keybinds[key] = key_value
	
	#In the unlikely event it cannot find the config file, you'll know about it ;), also gaame will not play, Yes I've tested it, try it yourself, but make sure to save a copy of the file first :) 
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().change_scene(missing)
	#Sets keybinds
	set_game_binds()
	#print(player.hp)

#Sets the project keys to the keybinds on file
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

#Everytime the keybinds are written to the config file this occurs and saves
func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
	configfile.save(filepath)
