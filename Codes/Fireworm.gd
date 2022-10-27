extends KinematicBody2D

#State machine, made redundant by animation tree
enum{
	ATTACK,
	DEATH,
	HIT,
	IDLE,
	MOVE
}

#Export variables
export var is_dead = false
export (int) var hp: int = 5

#Variables amde ready at start of game, gets relevant parts of fireworm and scenes for easy coding
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state
onready var collision = $Top
onready var Fireball = preload("res://Scenes/Fireball.tscn")
onready var detect = $"Detection/Detection shape"

#Constants
const GRAVITY = 7.75
const SPEED = 75
const FLOOR = Vector2(0,-1)

#Variables
var vel = Vector2()
var dir = 1
var dam = 1
var hit = false

#Ignore
func _ready():
	pass 

#Happens all the time
func _physics_process(delta):
	Global.fireworm_dir = dir
	if is_dead == false and hit == false:
		vel.x = SPEED * dir
		
		if dir == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		vel.y += GRAVITY
		
		vel = move_and_slide(vel, FLOOR)

		if is_on_wall():
			dir = dir * -1
			$RayCast2D.position.x *= -1
			$Top.position.x *= -1
			$Bottom.position.x *= -1
			$"Detection/Detection shape".position.x *= -1
		if $RayCast2D.is_colliding() == false:
			dir = dir * -1
			$RayCast2D.position.x *= -1
			$Top.position.x *= -1
			$Bottom.position.x *= -1
			$"Detection/Detection shape".position.x *= -1
		
		$AnimationTree["parameters/conditions/IsDead"] = is_dead
		
#Occurs when Fireworm damaged
func deal_damage():
	hp -= dam
	if hp < 1:
		dead()
	else:
		state_machine.travel("Hurt")
		hit = true
		yield(get_tree().create_timer(0.3), "timeout")
		hit = false

#When a body comes into the view of the fireworms hitbox this occurs
func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		print("I see you!")
		#Fireball.launch()
		var bullet = Fireball.instance()
		#get_tree().get_node("res://Scenes/World.tscn").add_child(bullet)
		get_parent().add_child(bullet)
		bullet.global_position = self.global_position
		
func dead():
	is_dead = true
	vel = Vector2(0,0)
	state_machine.travel("Death")
	$Top.queue_free()
	$Bottom.queue_free()
	detect.queue_free()
	yield(get_tree().create_timer(10), "timeout")
	queue_free()
