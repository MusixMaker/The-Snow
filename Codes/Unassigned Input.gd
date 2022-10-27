extends CanvasLayer

func _ready():
	pass # Replace with function body.

#Only here to tell player that inputs are currently unassigned, deletes once button pressed
func _on_Button_pressed():
	queue_free()
