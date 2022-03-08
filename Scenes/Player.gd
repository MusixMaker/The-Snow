extends KinematicBody2D

enum{
	IDLE,
	RUN,
	JUMP,
	FALL,
	ATTACK_1,
	ATTACK_2,
	HURT,
	DIE
}

#Basic Stats
var state = IDLE
var melee_damage = 50

#Physics Stuff
var movement_speed : float = 5
var jumpforce : float = 10
var gravity : float = 30

onready var ap = $AnimationPlayer

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	if Input.is_action_pressed("ui_left"):
		get_node("AnimatedSprite").set_flip_h(true)
		state = RUN
	elif Input.is_action_pressed("ui_right"):
		get_node("AnimatedSprite").set_flip_h(false)
		state = RUN
		
	match state:
		IDLE:
			ap.play("Idle")
		RUN:
			ap.play("Run")
