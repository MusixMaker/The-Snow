extends Node

var filepath = "res://keybinds.ini"
var configfile

func _ready():
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			print(key, " : ", OS.get_scancode_string(key_value))
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().change_scene("res://Scenes/File Not Found.tscn")
