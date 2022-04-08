extends Area2D
class_name Hitbox

export (int) var damage: int = 1

onready var collision_shape: CollisionShape2d = get_child(0)

func _init() -> void:
	connect("body_entered", self, "_on_body_enetered")

func _ready() -> void:
	assert(collision_shape != null)
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	body.take_damage(damage)
