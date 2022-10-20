extends Area2D

var firsttime = true
var direction
export(int) var Speed : int = -300

func _physics_process(delta):
	if firsttime == true:
		direction = Global.fireworm_dir
		if direction == -1:
			$AnimatedSprite.flip_h = true
		firsttime = false
	else:
		position.x -= direction * Speed * delta



#func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
#	position = initial_position
#	direction = dir
#	fireball_speed = speed
	
#func _physics_process(delta:float) -> void:
#	position += direction * fireball_speed * delta


func _on_Fireball_body_entered(body):
	if body.is_in_group("Fireworm"):
		pass
	else:
		if body.is_in_group("Player"):
			body.take_damage()
		elif body.is_in_group("Enemies"):
			body.deal_damage()
		$AnimatedSprite.play("Explosion")
		Speed = 0
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
