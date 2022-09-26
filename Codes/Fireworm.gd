extends KinematicBody2D

enum{
	ATTACK,
	DEATH,
	HIT,
	IDLE,
	MOVE
}

export var is_dead = false
export (int) var hp: int = 5

onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state
onready var collision = $Top
onready var Fireball = preload("res://Scenes/Fireball.tscn")

const GRAVITY = 7.75
const SPEED = 75
const FLOOR = Vector2(0,-1)

var vel = Vector2()
var dir = 1
var dam = 1
var hit = false

func _ready():
	pass 

func dead():
	is_dead = true
	vel = Vector2(0,0)
	state_machine.travel("Death")
	$Top.queue_free()
	$Bottom.queue_free()

func _physics_process(delta):
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
		if $RayCast2D.is_colliding() == false:
			dir = dir * -1
			$RayCast2D.position.x *= -1
			$Top.position.x *= -1
			$Bottom.position.x *= -1
		
		$AnimationTree["parameters/conditions/IsDead"] = is_dead
		
		
func deal_damage():
	hp -= dam
	if hp < 1:
		dead()
	else:
		state_machine.travel("Hurt")
		hit = true
		yield(get_tree().create_timer(0.3), "timeout")
		hit = false


func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		print("I see you!")
		Fireball.launch()
#		var bullet = Fireball.instance()
#		get_node("res://Scenes/World.tscn").add_child(bullet)
#		bullet.global_position = $Position2D.global_position
