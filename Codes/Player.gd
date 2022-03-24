extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -250
export (int) var gravity = 500
export (int) var slide_speed = 400

var vel = Vector2.ZERO
export var is_attacking = false
var dir

onready var state_machine = $AnimationTree.get("parameters/playback")

export (float) var friction = 10
export (float) var acceleration = 25

#enum{
#	IDLE,
#	RUN,
#	JUMP,
#	STARTJUMP,
#	FALL,
#	ATTACK_1,
#	ATTACK_2,
#	HURT,
#	DIE
#}

onready var state
onready var ap = $AnimationPlayer
onready var player = get_node("AnimationPlayer")

func _ready():
	state_machine.start("Idle")
	pass # Replace with function body.

func update_animation(anim):
	if vel.x < 0:
		$AnimatedSprite.flip_h = true
	if vel.x > 0:
		$AnimatedSprite.flip_h = false
	#match(anim):
		#FALL:
		#	ap.play("Fall")
		#IDLE:
		#	ap.play("Idle")
		#JUMP:
		#	ap.play("Jump")
		#RUN:
		#	ap.play("Run")
		#ATTACK_1:
		#	ap.play("Attack 1")
		#ATTACK_2:
		#	ap.play("Attack 2")
		#HURT:
		#	ap.play("Hurt")
		#DIE:
		#	ap.play("Death")

#func handle_state(state):
#	match(state):
#		STARTJUMP:
#			vel.y = jump_speed
#	pass

func get_input():
	dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir != 0 and is_attacking == false:
		vel.x = move_toward(vel.x, dir*speed, acceleration)
	else:
		vel.x = move_toward(vel.x, 0, friction)
	if Input.is_action_just_pressed("attack") and is_on_floor():
		is_attacking = true
		state_machine.travel("Attack 1")
		print(is_attacking)

func _process(delta):
	get_input()
	#print(is_on_floor())
	if vel == Vector2.ZERO:
		state_machine.travel("Idle")
	if Input.get_action_strength("ui_up") and is_on_floor():
		state_machine.travel("Jump")
		vel.y = jump_speed
	elif vel.x != 0:
		state_machine.travel("Run")
	
	if not is_on_floor():
		if vel.y < 0:
			state_machine.travel("Jump")
		if vel.y > 0:
			state_machine.travel("Fall")
			
	#handle_state(state)
	update_animation(state)
	
	print(is_attacking)
	vel.y += gravity*delta
	if is_attacking == true:
		vel.x = 0
	vel = move_and_slide(vel, Vector2.UP)
	
	$AnimationTree["parameters/conditions/IsAttacking"] = is_attacking


func _on_HitArea_area_entered(area):
	if area.is_in_group("Enemies"):
		area.take_damage()
