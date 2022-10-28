extends KinematicBody2D

#State machine, made redundant by animation tree
enum{
	ATTACK,
	DEATH,
	HIT,
	IDLE,
	MOVE
}

#Export Variables
export var is_dead = false
export (int) var hp: int = 5

#Varaibles made ready on game start, calls necessary parts from fire wizard for easy coding
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state
onready var collision = $Hitbox
onready var hitarea = $HitArea/HitArea
onready var dams = $Area2D/DamageArea
onready var cols = $Turnaround/CollisionShape2D

#Constants
const GRAVITY = 7.75
const SPEED = 40
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
	#print(hp)
	#Checks the wizard isn't dead or being damaged
	if is_dead == false and hit == false:
		#Moves constantly
		vel.x = SPEED * dir
		
		#Flips sprite based on direction
		if dir == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		#While the raycast prevent sit falling off stuff, still has gravity
		vel.y += GRAVITY
		
		#Kinda unnessecary for a constantly moving NPC, but there is indeed friction on slowing it down if on ground
		vel = move_and_slide(vel, FLOOR)

		#Flips if it hits a wall, all necessary hitboxes moce to other side
		if is_on_wall():
			dir = dir * -1
			$Turnaround/CollisionShape2D.position.x *= -1
			$RayCast2D.position.x *= -1
			$HitArea/HitArea.position.x *= -1
			$Area2D/DamageArea.position.x *= -1
			
		#Same as above, but for edge of the ground
		if $RayCast2D.is_colliding() == false:
			dir = dir * -1
			$Turnaround/CollisionShape2D.position.x *= -1
			$RayCast2D.position.x *= -1
			$HitArea/HitArea.position.x *= -1
			$Area2D/DamageArea.position.x *= -1
		
		#Links advance conditions of animation tree to a code variable
		$AnimationTree["parameters/conditions/IsDead"] = is_dead

#Takes damage in this function
func deal_damage():
	#Loses health
	hp -= dam
	#Dies if below 1 health
	if hp < 1:
		dead()
	#If not dead, be hurt instead
	else:
		state_machine.travel("Hurt")
		hit = true
		yield(get_tree().create_timer(0.4), "timeout")
		hit = false

#Plays attack animation if the player enetrs its 'sight'
func _on_HitArea_body_entered(body):
	if body.is_in_group("Player"):
		state_machine.travel("Attack")

#Plays move animation when player leaves its 'sight'
func _on_HitArea_body_exited(body):
	if body.is_in_group("Player"):
		state_machine.travel("Move")

#When player gets further towards the flame, will take damage
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()

#When playertries to enak up behind, turns and blasts face with flame
func _on_Turnaround_body_entered(body):
	if body.is_in_group("Player"):
		dir = dir * -1
		$Turnaround/CollisionShape2D.position.x *= -1
		$RayCast2D.position.x *= -1
		$HitArea/HitArea.position.x *= -1
		$Area2D/DamageArea.position.x *= -1

#When deaed
func dead():
	#Delets collision shapes
	hitarea.queue_free()
	dams.queue_free()
	cols.queue_free()
	is_dead = true
	#Stops moving and plays dead animation
	vel = Vector2(0,0)
	state_machine.travel("Death")
	collision.queue_free()
	#Despawns after 10 seconds
	yield(get_tree().create_timer(10), "timeout")
	queue_free()
