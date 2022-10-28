extends CanvasLayer

#Loads all necessary scenes to variables for easy coding
onready var buttoncontainer = get_node("ColorRect/Panel/VBoxContainer")
onready var buttonscript = load("res://Codes/KiBaatain.gd")
onready var settings = "res://Scenes/Settings.tscn"
onready var pause = "res://Scenes/Pause.tscn"
onready var unassigned = load("res://Scenes/Unassigned Input.tscn")

#Variables
var save_key
var keybinds 
var buttons = {}

#Happens once on scene load
func _ready():
	#Creates temporary file of keybinds, allows for changing keybinds without it being set in stone until saved
	keybinds = Global.keybinds.duplicate()
	
	#For every key in the keybinds file it creates, sizes and shapes a new button and label for each, as well as each getting their very own code, all duplicates of KiBaatain.gd
	#That is all of the folowing lines of this function
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
		

#Ignore
func _process(delta):
	print(save_key)
	pass

#Sorry about the mess, happens when a key is 
func change_bind(key, value):
	#print(5)
	
	#For every key in the keybinds page it sets the value and displayed letter based off the pressed key under KiBaatain.gd
	keybinds[key] = value
	for k in keybinds.keys():
		save_key = keybinds[key]
		print(value)
		#print("running check on ",k," - ", key," -- ", k == key)
		
		#If there is no assigned value for a given key it sets its value to null and displays unassigned for player
		if k != key and value != null and keybinds[k] == value:
			#print("checking if ", k,"=", key ,": ",k == key)
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"
			#buttons[key].value = save_key
			
			#Stops saving if there are any null keys
			save_key = keybinds[k]
			
			#print(save_key)
			#print(key, value)

#Returns to previous screeen, either settings or pause, based on whether the global code has been paused
func _on_Back_pressed():
	if Global.paused == null:
		get_tree().change_scene(settings)
	elif Global.paused != null:
		queue_free()

#Unable to get this to work quite right
func _on_Reset_pressed():
	pass
	#Global.keybinds = keybinds_default

#When the save button is pressed, ideally saves 
func _on_Save_pressed():
	if save_key == null:
		print("Unable to save")
		add_child(unassigned.instance())
	else:
		Global.keybinds = keybinds.duplicate()
		#Sets keybinds in game
		Global.set_game_binds()
		#Finally writes to keybind file, saves between reloading of games
		Global.write_config()
		#Returns to previous scene
		_on_Back_pressed()
