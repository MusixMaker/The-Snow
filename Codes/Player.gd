extends KinematicBody2D

export (int) var hp: int = 5
export (int) var speed = 200
export (int) var jump_count = 0
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

onready var on_ground = false
onready var pause = "res://Scenes/Pause.tscn"
onready var music = "res://Codes/Music.gd"
onready var sword_hitbox: Area2D = get_node("AnimatedSprite/Hitbox")
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state
onready var ap = $AnimationPlayer
onready var player = get_node("AnimationPlayer")
onready var dam = 1
onready var collision = $Hitbox
export onready var dead = false

#var instance = music.instance()

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
	#print(hp)
	#print(jump_count)
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
	if Input.is_action_just_pressed("ui_up") and attacks == false:
		if jump_count <= 1:
			state_machine.travel("Jump")
			vel.y = jump_speed
			jump_count += 1
			
		#elif not is_on_floor() and jump_count <=2:
		#	state_machine.travel("Jump")
		#	vel.y = jump_speed
		#	jump_count += 1
			
			
	if is_on_floor():
		on_ground = true
		jump_count = 0
		
	if Input.is_action_pressed("Pause"):
		get_tree().change_scene(pause)
	
#Happens all the time, used primarily for debugging
func _process(delta):
	print(hp)
	#print(music.noise_level)
		
	#print(state_machine.get_current_node())
	#print(is_attacking)
	#if hp < 1:
	#	if dead == false:
	#		vel.x = 0
	#		dead = true
	#		print(dead)
	#		state_machine.travel("Death")
	#	else:
	#		pass

#get key pressed for above function

	#makes sure the player is alive and able
	if dead == false: 
		get_input()
		if vel == Vector2.ZERO and hp > 0 :
			state_machine.travel("Idle") #When not moving, play idle anmation
		elif vel.x != 0 and hp > 0:
			state_machine.travel("Run") #When moving play run animation
	
		if not is_on_floor():
			 #If going up, play jump animation
			if vel.y < 0:
				state_machine.travel("Jump")
				
			#If going down, play fall animation
			if vel.y > 0:
				state_machine.travel("Fall") 
			
	#handle_state(state)
		if vel.x < 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite/Hitbox/HitArea.position.x = -direction 
		if vel.x > 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite/Hitbox/HitArea.position.x = direction
		#Both above flip sprited to face the correct direciton of movement
	
		#Gravity and terminal velocity
		vel.y += gravity*delta
		if vel.y >= 500:
			vel.y = 500
	#if is_attacking == true:
	#	vel.x = 0
		vel = move_and_slide(vel, Vector2.UP)
	#Attempt at making player fall to ground on death, kinda doesn't work
	else:
		vel.y += gravity*delta
	
	$AnimationTree["parameters/conditions/IsAttacking"] = is_attacking
	$AnimationTree["parameters/conditions/IsAttacking2"] = is_attacking_2
	$AnimationTree["parameters/conditions/Combo"] = combo
	#$AnimationTree["parameters/conditions/dead"] = dead

#When the player gets hit
func take_damage():
	#print("ow")
	
	#takes damage
	hp -= dam
	#If not dead, plays hurt animation
	if hp >= 1:
		state_machine.travel("Hurt")
	#This is the part where he kills you
	else:
		#Deletes collision shape
		collision.queue_free()
		#Sets dead true all round
		dead = true
		Global.player_dead = true
		print(dead)
		#Travels to dead state
		state_machine.travel("Death")
#		music.died()
		#After the 4 second audio, despawns and restarts level
		yield(get_tree().create_timer(4), "timeout")
		Global.player_dead = false
		get_tree().change_scene("res://Scenes/World.tscn")

#func deal_damage():
#	print("stop hitting yourself")

#Deals damage if something enters the live attack box and is an enemy
func _on_Hitbox_body_entered(body):
	#print(body.name)
	if body.is_in_group("Enemies"):
		print("damage dealt")
		body.deal_damage()
	#if body.is_in_group("Worm"):
	#	body.deal_damage()
