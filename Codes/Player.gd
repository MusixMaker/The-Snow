extends KinematicBody2D

export (int) var hp: int = 10
export (int) var speed = 200
export (int) var jump_speed = -265
export (int) var gravity = 500
export (int) var slide_speed = 400
export var is_attacking = false
export var is_attacking_2 = false
export var combo = false
export var attacks = false

var vel = Vector2.ZERO
var dir
var direction = 39
var bird = true

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

onready var sword_hitbox: Area2D = get_node("AnimatedSprite/Hitbox")
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state
onready var ap = $AnimationPlayer
onready var player = get_node("AnimationPlayer")
onready var dam = 1
onready var dead = false

func _ready():
	state_machine.start("Idle")
	pass # Replace with function body.


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
	if is_attacking == false and is_attacking_2 == false and combo == false:
		attacks = false
	else:
		attacks = true
	dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir != 0 and attacks == false:
		vel.x = move_toward(vel.x, dir*speed, acceleration)
	else:
		vel.x = move_toward(vel.x, 0, friction)
	if Input.is_action_just_pressed("attack") and is_on_floor() and dead == false and attacks == false:
		is_attacking = true
		state_machine.travel("Attack")
		#yield(get_tree().create_timer(0.1), "timeout")
		#is_attacking = false
	elif Input.is_action_just_pressed("attack_2") and is_on_floor() and dead == false and attacks == false:
		is_attacking_2 = true
		state_machine.travel("Attack 2")
		#yield(get_tree().create_timer(0.1), "timeout")
		#is_attacking_2 = false
	elif Input.is_action_just_pressed("attack_combo") and is_on_floor() and dead == false and attacks == false:
		combo = true
		state_machine.travel("Combo")
		#yield(get_tree().create_timer(0.1), "timeout")
		#combo = false
	if Input.get_action_strength("ui_up") and attacks == false:
		state_machine.travel("Jump")
		vel.y = jump_speed

	

func _process(delta):
	#print(state_machine.get_current_node())
	#print(is_attacking)
	if dead == false:
		get_input()
	if vel == Vector2.ZERO:
		state_machine.travel("Idle")
	elif vel.x != 0:
		state_machine.travel("Run")
	
	if not is_on_floor():
		if vel.y < 0:
			state_machine.travel("Jump")
		if vel.y > 0:
			state_machine.travel("Fall")
			
	#handle_state(state)
	if vel.x < 0:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite/Hitbox/HitArea.position.x = -direction
	if vel.x > 0:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite/Hitbox/HitArea.position.x = direction
	
	vel.y += gravity*delta
	#if is_attacking == true:
	#	vel.x = 0
	vel = move_and_slide(vel, Vector2.UP)
	
	$AnimationTree["parameters/conditions/IsAttacking"] = is_attacking
	$AnimationTree["parameters/conditions/IsAttacking2"] = is_attacking_2
	$AnimationTree["parameters/conditions/Combo"] = combo


func take_damage():
	print("ow")
	hp -= dam
	if hp >= 1:
		state_machine.travel("Hurt")
	elif hp <=0:
		print("dead")
		dead = true
		state_machine.travel("Dead")
		queue_free()


func _on_Hitbox_body_entered(body):
	#print(body.name)
	if body.is_in_group("Enemies"):
		body.deal_damage()
	if body.is_in_group("Worm"):
		body.deal_damage()
