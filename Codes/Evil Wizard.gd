extends KinematicBody2D

var state_machine
var run_speed = 80
var vel = Vector2.ZERO


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func update_animation(anim):
	if vel.x < 0:
		$AnimatedSprite.flip_h = true
	if vel.x > 0:
		$AnimatedSprite.flip_h = false

func get_input():
	var current = state_machine.get_current_node()
	vel = Vector2.ZERO
	if Input.is_action_just_pressed("attack"):
		state_machine.travel("Attack")
		return
	if Input.is_action_pressed("ui_right"):
		vel.x += 1
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1
	vel = vel.normalized() * run_speed
	if vel.length() == 0:
		state_machine.travel("Idle")
	if vel.length() < 0:
		state_machine.travel("Run")

func _physics_process(delta):
	get_input()
	vel = move_and_slide(vel)
