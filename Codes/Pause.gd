extends Control

export onready var ap = $AnimationPlayer
export var muted = false
export onready var music = $VBoxContainer/HSlider
export onready var mutey = $"Background/VBoxContainer/MuteColour/Sound"
export onready var current_noise
var is_paused = false setget set_is_paused


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.is_paused = !is_paused
		

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _physics_process(delta):
	if music.value < 10:
		muted = true
		ap.play("Muted")
		mutey.pressed = false
		
	elif music.value >= 10:
		muted = false
		ap.play("Unmuted")
		mutey.pressed = true

func _on_CheckButton_pressed():
	if muted == true:
		muted = false
		ap.play("Unmuted")
		music.value = current_noise
	elif muted == false:
		muted = true
		ap.play("Muted")
		current_noise = music.value
		music.value = 0


func _on_Keys_pressed():
	pass 


func _on_Quit_pressed():
	get_tree().quit()


func _on_Restart_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")
