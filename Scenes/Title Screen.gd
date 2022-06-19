extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
