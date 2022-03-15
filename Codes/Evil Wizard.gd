extends KinematicBody2D

onready var sprite = $AnimatedSprite

enum{
	IDLE,
	MOVE,
	ATTACK,
	HURT,
	DIE
}

func _ready():
	pass
		
func _physics_process(_delta):
	
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("Attack")
	elif Input.is_action_pressed("ui_left"):
		get_node("AnimatedSprite").set_flip_h(true)
		$AnimationPlayer.play("Move")
	elif Input.is_action_pressed("ui_right"):
		get_node("AnimatedSprite").set_flip_h(false)
		$AnimationPlayer.play("Move")
	else:
		$AnimationPlayer.play("Idle")
		
func take_damage():
	print("Ouch")
