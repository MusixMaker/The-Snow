extends KinematicBody2D

enum{
	ATTACK,
	DEATH,
	HIT,
	IDLE,
	MOVE
}

export var is_dead = false
export (int) var hp: int = 2

onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state

const GRAVITY = 7.75
const SPEED = 50
const FLOOR = Vector2(0,-1)

var vel = Vector2()
var dir = 1

func _ready():
	pass 

func dead():
	is_dead = true
	vel = Vector2(0,0)
	state_machine.travel("Death")
	print('RRRAAAARGH')
	

func _physics_process(delta):
	#print(hp)
	if is_dead == false:
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
			$RayCast2D.position.x *= -1
		if $RayCast2D.is_colliding() == false:
			dir = dir * -1
			$RayCast2D.position.x *= -1
		
		$AnimationTree["parameters/conditions/IsDead"] = is_dead

func take_damage(dam: int) -> void:
	print("you will try")
	hp -= dam
	if hp >= 0:
		state_machine.travel("Hurt")
	else:
		state_machine.travel("Dead")
