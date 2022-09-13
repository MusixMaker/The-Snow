extends AudioStreamPlayer

onready var title = "res://Scenes/Title Screen.tscn"
onready var game = "res://Scenes/World.tscn"
onready var player = "res://Codes/Player.gd"

onready var ap = $AnimationPlayer
onready var noise_level = Global.current_noise
onready var lindB

func _ready():
	pass
	
func _process(delta):
	#print(player.dead)
	lindB = noise_level/100
	volume_db = log(lindB) * 20
	#volume_db = pow(10, (lindB/20))
	#print(volume_db)
	
	#if player.dead == true:
	#	ap.play("Died")
	#	yield(get_tree().create_timer(5), "timeout")


	if get_tree().get_current_scene().get_name() == "Title Screen":
		ap.play("Title")
	elif get_tree().get_current_scene().get_name() == "World":
		ap.play("Game")
	else:
		pass
		

func died():
	print("aarghghghghghghg")
