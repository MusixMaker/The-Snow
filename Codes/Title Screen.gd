extends Control

onready var game = "res://Scenes/World.tscn"
onready var settings = "res://Scenes/Settings.tscn"

func _ready():
	$Buttons/Start.grab_focus()
	yield(get_tree().create_timer(4), "timeout")
	set_rotation(PI/180)
	yield(get_tree().create_timer(4.4), "timeout")
	set_rotation(PI/90)
	yield(get_tree().create_timer(4.3), "timeout")
	set_rotation(PI/60)
	yield(get_tree().create_timer(1.5), "timeout")
	set_rotation(PI/45)
	yield(get_tree().create_timer(1.5), "timeout")
	set_rotation(PI/36)

func _on_Start_pressed():
	get_tree().change_scene(game)


func _on_Options_pressed():
	get_tree().change_scene(settings)


func _on_Exit_pressed():
	get_tree().quit()
