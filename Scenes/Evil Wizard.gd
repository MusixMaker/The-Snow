extends KinematicBody2D

onready var sprite = $AnimatedSprite

func _ready():
	pass
		
func _physics_process(_delta):
	
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("Attack")
	elif Input.is_action_pressed("ui_left"):
		$AnimationPlayer.play("Move")
	elif Input.is_action_pressed("ui_right"):
		$AnimationPlayer.play("Move")
	else:
		$AnimationPlayer.play("Idle")
		
