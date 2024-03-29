extends KinematicBody2D

#Now old code, unconnected, been Usurped by Player.gd

#Export variables
export (int) var speed = 200
export (int) var gravity = 500
export (int) var JUMP_SPEED = -250
export (int) var friction = 10
export (int) var acceleration = 25

#Constants
const FLOOR_NORMAL = Vector2(0,-1)
const SLOPE_SLIDE_STOP = 25.0

#Variables made rady on load
var vel = Vector2.ZERO
onready var sprite = $AnimatedSprite
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback");


func _physics_process(delta):
	#Flips sprite based on direction of movement
	if vel.x < 0:
		sprite.flip_h = true
	if vel.x > 0:
		sprite.flip_h = false
		
	var current_state = playback.get_current_node()
	
	#makes sure player isn't dead
	if current_state != "Dead":
		vel = delta * gravity
		vel = move_and_slide(vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
		var on_floor = is_on_floor()
		
		var is_attacking = false
		var is_attacking_2 = false
		
		var target_speed = 0
		
		#When not attacking, allows movement
		if !"Attack"in current_state:
			var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			if dir != 0:
				vel.x = move_toward(vel.x, dir*speed, acceleration)
			else:
				vel.x = move_toward(vel.x, 0, friction)
				
		if Input.is_action_just_pressed("attack"):
			is_attacking = true
		if Input.is_action_just_pressed("jump") && on_floor:
			vel.y += JUMP_SPEED
			
		#Converts the advance conditions of animation tree to code variables
		anim_tree["parameters/conditions/IsAttacking"] = is_attacking
		anim_tree["parameters/conditions/IsAttacking2"] = is_attacking_2
		
		
