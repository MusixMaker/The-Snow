extends Control

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

func _process(delta):
	if music.value < 10:
		muted = true
		ap.play("Muted")
		mutey.pressed = false
		
	elif music.value >= 10:
		muted = false
		ap.play("Unmuted")
		mutey.pressed = true
		
	Global.current_noise = music.value
	
	lindB = Global.current_noise/100
	current_dB = log(lindB) * 20

func _on_CheckButton_pressed():
	if muted == true:
		muted = false
		ap.play("Unmuted")
		music.value = before_mute
	elif muted == false:
		muted = true
		ap.play("Muted")
		before_mute = music.value
		music.value = 0


func _on_Keys_pressed():
	get_tree().change_scene("res://Scenes/Keybinds.tscn")


func _on_Back_pressed():
	get_tree().change_scene(home)
	
func _on_Quit_Pressed():
	get_tree().quit()
