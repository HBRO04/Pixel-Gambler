extends Sprite2D

var runningSpeed = 0

func speed():
	runningSpeed = randf_range(0, 5.5)
	
func _ready() -> void:
	randomize()
	speed()
	running()
	
func running():
	position.x = position.x * runningSpeed
