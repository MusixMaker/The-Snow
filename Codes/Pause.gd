extends CanvasLayer

onready var ap = $AnimationPlayer
var muted = false
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

#func set_is_paused(value):
#	is_paused = value
#	get_tree().paused = is_paused
#	visible = is_paused

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
	$AudioStreamPlayer.volume_db = log(lindB) * 20
	#volume_db = pow(10, (lindB/20))
	print($AudioStreamPlayer.volume_db)
	
	

func _on_Keys_pressed():
	get_tree().change_scene("res://Scenes/Keybinds.tscn")


func _on_Quit_pressed():
	print("Quitting...")
	get_tree().quit()


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene(game)
	queue_free()


func _on_Resume_pressed():
	get_tree().paused = false
	queue_free()


func _on_Sound_pressed():
	if muted == true:
		muted = false
		ap.play("Unmuted")
		music.value = before_mute
	elif muted == false:
		muted = true
		ap.play("Muted")
		before_mute = music.value
		music.value = 0
