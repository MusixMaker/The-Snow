extends Area2D

#var direction: Vector2 = Vector2.ZERO
export(int) var Speed : int = 100

func _physics_process(delta):
	global_position += Speed * delta

#func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
#	position = initial_position
#	direction = dir
#	fireball_speed = speed
	
#func _physics_process(delta:float) -> void:
#	position += direction * fireball_speed * delta
