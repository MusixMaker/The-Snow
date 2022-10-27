#One made for each button on the Keybinds.tscn, allows for setup of any number of keys given need
extends Button

#Variables
var key
var value
var menu
var waiting_input = false

#When key is pressed
func _input(event):
	if waiting_input:
		#If a recognised keyboard key, scans for it's code and changes the temporary file keybinds, not saved until save pressed, see Keybinds.gd save
		if event is InputEventKey:
			value = event.scancode
			text = OS.get_scancode_string(value)
			
			#Changes individual key with a given value on Keybinds.gd
			menu.change_bind(key, value)
			
			pressed = false
			waiting_input = false
		#If a mouse button is pressed, resets to previous key, unless null, then prints unassigned (can't save while it says this)
		if event is InputEventMouseButton:
			if value != null:
				text = OS.get_scancode_string(value)
			else:
				text = "Unassigned"
			#No longer waits for key inputs, will disregard any keys pressed until funciton restarted
			pressed = false
			waiting_input = false

#Lets pressed button change Keybind
func _toggled(button_pressed):
	if button_pressed:
		#Waits for a key to be pressed, displays this to player
		waiting_input = true
		set_text("Press Any Key")
