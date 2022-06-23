extends Control


func _ready():
	$Buttons/Start.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Settings.tscn")


func _on_Exit_pressed():
	get_tree().quit()
