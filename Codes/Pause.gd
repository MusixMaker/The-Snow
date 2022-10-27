extends CanvasLayer

#Variables
onready var ap = $AnimationPlayer
var muted = false
onready var keys = load("res://Scenes/Keybinds.tscn")
onready var music = $Background/VBoxContainer/HSlider
onready var mutey = $"Background/VBoxContainer/MuteColour/Sound"
onready var before_mute
onready var game = "res://Scenes/World.tscn"
onready var lindB
#var is_paused = false setget set_is_paused


#func _unhandled_input(event):
#	if event.is_action_pressed("Pause"):
#		self.is_paused = !is_paused
#		

#Called on scene startup
func _ready():
	#Sets volume to the global sound variable
	music.value = Global.current_noise
	
	#Sets the keyboard on the mute button, allows for keyboard movement on screen
	mutey.grab_focus()


#Happens all the time
func _process(delta):
	#Like settings sound, mutes if on lowest point of slider
	if music.value < 10:
		muted = true
		ap.play("Muted")
		mutey.pressed = false
		
	#Otherwised it is unmuted
	elif music.value >= 10:
		muted = false
		ap.play("Unmuted")
		mutey.pressed = true
		
	#Sets the global sound variable to the music slider value
	Global.current_noise = music.value
	
	#Converts the slider value to dB using some sweet math
	lindB = Global.current_noise/100
	$AudioStreamPlayer.volume_db = log(lindB) * 20
	#volume_db = pow(10, (lindB/20))
	#print($AudioStreamPlayer.volume_db)
	#print(get_tree().get_current_scene().get_scene_name())
	#print(Global.paused)
	#var scene = get_tree().get_current_scene().get_name() 
	#print(scene)

#Takes you to keybinds page, but makes sure that happens inside the pause menu, and doesn't override it
func _on_Keys_pressed():
	add_child(keys.instance())


#Quits game
func _on_Quit_pressed():
	print("Quitting...")
	get_tree().quit()

#Restarts scene
func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene(game)
	queue_free()

#Unpauses and resumes game
func _on_Resume_pressed():
	get_tree().paused = false
	queue_free()

#Mute function
func _on_Sound_pressed():
	#Identical to Settings.gd, see mute function there
	if muted == true:
		muted = false
		ap.play("Unmuted")
		music.value = before_mute
	elif muted == false:
		muted = true
		ap.play("Muted")
		before_mute = music.value
		music.value = 0
