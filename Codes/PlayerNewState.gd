extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -250
export (int) var gravity = 500
export (int) var slide_speed = 400

var vel = Vector2.ZERO

var state_machine

export (float) var friction = 10
export (float) var acceleration = 25

enum{
	IDLE,
	RUN,
	JUMP,
	STARTJUMP,
	FALL,
	ATTACK_1,
	ATTACK_2,
	HURT,
	DIE
}

#Basic Stats
onready var state = IDLE

onready var ap = $AnimationPlayer

func _ready():
	pass # Replace with function body.

func update_animation(anim):
	if vel.x < 0:
		$AnimatedSprite.flip_h = true
	if vel.x > 0:
		$AnimatedSprite.flip_h = false
	match(anim):
		FALL:
			ap.play("Fall")
		IDLE:
			ap.play("Idle")
		JUMP:
			ap.play("Jump")
		RUN:
			ap.play("Run")
		ATTACK_1:
			state_machine.travel("Attack 1")
		ATTACK_2:
			ap.play("Attack 2")
		HURT:
			ap.play("Hurt")
		DIE:
			ap.play("Death")

func handle_state(state):
	match(state):
		STARTJUMP:
			vel.y = jump_speed
	pass

func get_input():
	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir != 0:
		vel.x = move_toward(vel.x, dir*speed, acceleration)
	else:
		vel.x = move_toward(vel.x, 0, friction)
	if Input.is_action_pressed("attack"):
		state = ATTACK_1

func _process(delta):
	get_input()
	print(is_on_floor())
	if vel == Vector2.ZERO:
		state = IDLE
	if Input.get_action_strength("ui_up") and is_on_floor():
		state = STARTJUMP
	elif vel.x != 0:
		state = RUN
	
	if not is_on_floor():
		if vel.y < 0:
			pass
		if vel.y > 0:
			pass
	
	vel.y += gravity*delta
	vel = move_and_slide(vel, Vector2.UP)


func _on_HitArea_area_entered(area):
	if area.is_in_group("Enemies"):
		area.take_damage()
