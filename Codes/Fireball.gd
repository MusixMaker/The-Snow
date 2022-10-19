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
