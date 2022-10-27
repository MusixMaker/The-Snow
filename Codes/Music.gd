extends AudioStreamPlayer

#Variables linking scenes
onready var title = "res://Scenes/Title Screen.tscn"
onready var game = "res://Scenes/World.tscn"
onready var player = "res://Codes/Player.gd"

#Variables
onready var ap = $AnimationPlayer
onready var noise_level = Global.current_noise
onready var lindB

#Ignore
func _ready():
	pass


#Happens all the time
func _process(delta):
	#print(player.dead)
	
	#If the player isn't dead, converts the global sound variable from a 1/100 percentage to dB, allowing for setting of volume
	if Global.player_dead == false:
		lindB = noise_level/100
		volume_db = log(lindB) * 20
	else:
		#-80 can be classified as -infinity, absolute zero, no sound
		volume_db = -80
		
	#volume_db = pow(10, (lindB/20))
	#print(volume_db)
	
	#if player.dead == true:
	#	ap.play("Died")
	#	yield(get_tree().create_timer(5), "timeout")


	#Plays title scene music
	if get_tree().get_current_scene().get_name() == "Title Screen":
		ap.play("Title")
		
	#Plays game music
	elif get_tree().get_current_scene().get_name() == "World":
		ap.play("Game")
	else:
		pass
		

#I'm not sure myself
func died():
	print("aarghghghghghghg")
