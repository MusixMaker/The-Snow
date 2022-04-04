extends Area2D

const SPEED = 100
var vel = Vector2()
var direction = 1

func _ready():
	pass

func set_fireball_direction(dir):
	direction = dir
	if dir == 1:
		$AnimatedSprite.flip_h = true


func _physics_process(delta):
	vel.x = SPEED * delta * direction
	translate(vel)
	$AnimatedSprite.play("Move")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	if "Player" in body.name:
		body.hurt
	if "Enemy" in body.name:
		body.dead
	$AnimatedSprite.play("Explosion")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
