extends Control

export onready var ap = $AnimationPlayer
export var muted = false
export onready var music = $VBoxContainer/HSlider
export onready var mutey = $"VBoxContainer/Mute Colour/Sound"
export onready var current_noise

# Called when the node enters the scene tree for the first time.
func _ready():
	
	music.value = 100
	$"VBoxContainer/Mute Colour/Sound".grab_focus()

func _physics_process(delta):
	if Input.is_action_pressed("Pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
	
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
