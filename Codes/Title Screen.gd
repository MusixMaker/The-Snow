extends Control

onready var game = "res://Scenes/World.tscn"
onready var settings = "res://Scenes/Settings.tscn"

func _ready():
	$Buttons/Start.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene(game)


func _on_Options_pressed():
	get_tree().change_scene(settings)


func _on_Exit_pressed():
	get_tree().quit()
