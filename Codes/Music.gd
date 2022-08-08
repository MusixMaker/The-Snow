extends AudioStreamPlayer

onready var title = "res://Scenes/Title Screen.tscn"
onready var game = "res://Scenes/World.tscn"

onready var ap = $AnimationPlayer
onready var noise_level = Global.current_noise
onready var lindB

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	lindB = noise_level/100
	volume_db = log(lindB) * 20
	#volume_db = pow(10, (lindB/20))
	#print(volume_db)
	
	if get_tree().get_current_scene().get_name() == "Title Screen":
		ap.play("Title")
	elif get_tree().get_current_scene().get_name() == "World":
		ap.play("Game")
	else:
		pass
