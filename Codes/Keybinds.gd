extends CanvasLayer

onready var buttoncontainer = get_node("ColorRect/Panel/VBoxContainer")
onready var buttonscript = load("res://Codes/KiBaatain.gd")
onready var settings = "res://Scenes/Settings.tscn"
onready var pause = "res://Scenes/Pause.tscn"
onready var unassigned = load("res://Scenes/Unassigned Input.tscn")

var save_key
var keybinds 
var buttons = {}

func _ready():
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key
		
		var button_value = keybinds[key]
		button.text = OS.get_scancode_string(button_value)
		
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttoncontainer.add_child(hbox)
		
		buttons[key] = button
		

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		#print("running check on ",k," - ", key," -- ", k == key)
		if k != key and value != null and keybinds[k] == value:
			#print("checking if ", k,"=", key ,": ",k == key)
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"
			buttons[k].value = save_key
			print(save_key)


func _on_Back_pressed():
	if Global.paused == null:
		get_tree().change_scene(settings)
	elif Global.paused != null:
		queue_free()


func _on_Reset_pressed():
	pass
	#Global.keybinds = keybinds_default


func _on_Save_pressed():
	if save_key == null:
		print("Unable to save")
		add_child(unassigned.instance())
	else:
		Global.keybinds = keybinds.duplicate()
		Global.set_game_binds()
		Global.write_config()
		_on_Back_pressed()
