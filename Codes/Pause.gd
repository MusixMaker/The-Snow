extends Control


export var muted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/ColorRect/Sound.grab_focus()

func _physics_process(delta):
	if muted == true:
		$AnimationPlayer.play("Muted")
	else:
		$AnimationPlayer.play("Unmuted")
	if $VBoxContainer/HSlider.value() <= 10:
		muted = true
		$AnimationPlayer.play("Muted")

func _on_CheckButton_pressed():
	if muted == true:
		muted = false
	elif muted == false:
		muted = true


func _on_Keys_pressed():
	pass 


func _on_Back_pressed():
	pass
