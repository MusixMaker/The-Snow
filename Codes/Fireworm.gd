extends KinematicBody2D

enum{
	ATTACK,
	DEATH,
	HIT,
	IDLE,
	MOVE
}

onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state

const GRAVITY = 7.75
const SPEED = 50
const FLOOR = Vector2(0,-1)

var vel = Vector2()
var dir = 1

func _ready():
	pass 

func _physics_process(delta):
	vel.x = SPEED * dir
	
	if dir == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	state_machine.travel("Move")
	vel.y += GRAVITY
	
	vel = move_and_slide(vel, FLOOR)

	if is_on_wall():
		dir = dir * -1
