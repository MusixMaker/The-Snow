extends Area2D

#Vaariables
var firsttime = true
var direction
export(int) var Speed : int = -300

#Happens all the time
func _physics_process(delta):
	#Happens only the first time when fireball spawns, gets correct direction from fireworm and flips correct way
	if firsttime == true:
		direction = Global.fireworm_dir
		if direction == -1:
			$AnimatedSprite.flip_h = true
		firsttime = false
	#Continually after this until it hits something, moves at speed
	else:
		position.x -= direction * Speed * delta


#Old code
#func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
#	position = initial_position
#	direction = dir
#	fireball_speed = speed
	
#func _physics_process(delta:float) -> void:
#	position += direction * fireball_speed * delta

#When it hits a body
func _on_Fireball_body_entered(body):
	#If it was the fireworm, ignore it
	if body.is_in_group("Fireworm"):
		pass
	else:
		#Hurts both player and enemies, though fireworms are immune
		if body.is_in_group("Player"):
			body.take_damage()
		elif body.is_in_group("Enemies"):
			body.deal_damage()
		#Plays the animation to explode and disappears after the animation is finished
		$AnimatedSprite.play("Explosion")
		Speed = 0
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
