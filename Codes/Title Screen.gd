extends Control

#Variables
onready var game = "res://Scenes/World.tscn"
onready var settings = "res://Scenes/Settings.tscn"

#Rotation of title screen synced with music, with some trial and error, closes after too long is taken looking at title screen
func _ready():
	$Buttons/Start.grab_focus()
	yield(get_tree().create_timer(4), "timeout")
	set_rotation(PI/180)
	yield(get_tree().create_timer(4.4), "timeout")
	set_rotation(PI/90)
	yield(get_tree().create_timer(4.2), "timeout")
	set_rotation(PI/60)
	yield(get_tree().create_timer(1.5), "timeout")
	set_rotation(PI/45)
	yield(get_tree().create_timer(1.6), "timeout")
	set_rotation(PI/36)
	yield(get_tree().create_timer(5), "timeout")
	get_tree().quit()

#Start game
func _on_Start_pressed():
	get_tree().change_scene(game)

#Go to settings screen
func _on_Options_pressed():
	get_tree().change_scene(settings)

#Quit button
func _on_Exit_pressed():
	get_tree().quit()
