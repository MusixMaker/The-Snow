extends Control

#Variables
onready var ap = $AnimationPlayer
var muted = false
onready var music = $VBoxContainer/HSlider
onready var mutey = $"VBoxContainer/Mute Colour/Sound"
#onready var backgroundmusic = "res://Scenes/Background Music.tscn"
#onready var animplay = backgroundmusic.ap
onready var current_dB
onready var before_mute
onready var home = "res://Scenes/Title Screen.tscn"
var lindB

# Called when the node enters the scene tree for the first time.
func _ready():
	music.value = Global.current_noise
	mutey.grab_focus()

#Always happening code
func _process(delta):
	#If music slider is on lowest point, it is muted
	if music.value < 10:
		muted = true
		ap.play("Muted")
		mutey.pressed = false
		
	#If music slider is not on lowest point, it is not muted
	elif music.value >= 10:
		muted = false
		ap.play("Unmuted")
		mutey.pressed = true
		
	#Set game volume to slider value
	Global.current_noise = music.value
	
	#Convert slider value to dB value using some maths
	lindB = Global.current_noise/100
	current_dB = log(lindB) * 20

#Mute button function
func _on_CheckButton_pressed():
	
	#If the mute button is pressed while muted, it unmutes and returns to below mentioned variable of current volume
	if muted == true:
		muted = false
		ap.play("Unmuted")
		music.value = before_mute
	
	#If the mute button is pressed while unmuted, makes new variable of current volume and mutes it
	elif muted == false:
		muted = true
		ap.play("Muted")
		before_mute = music.value
		music.value = 0

#Goes to keybinds menu screen
func _on_Keys_pressed():
	get_tree().change_scene("res://Scenes/Keybinds.tscn")

#Returns to main menu
func _on_Back_pressed():
	get_tree().change_scene(home)
	
#Quits game
func _on_Quit_Pressed():
	get_tree().quit()
