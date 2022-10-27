extends Area2D
class_name Hitbox

export (int) var damage: int = 1

onready var collision_shape: CollisionShape2D = get_child(0)

func _init() -> void:
	print("hi")
	connect("body_entered", self, "_on_body_enetered")

func _ready() -> void:
	print("hekllo")
	assert(collision_shape != null)
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	print("sup")
	body.take_damage(damage)


#Honestly think this code is unused, don't believe it's linked to anything, I never see these print funcitons come up 
