extends AudioStreamPlayer

onready var lindB

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	lindB = Global.current_noise/100
	volume_db = log(lindB) * 20
	#volume_db = pow(10, (lindB/20))
	print(volume_db)
