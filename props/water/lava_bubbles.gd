extends Sprite

func _ready():
	var r = randi() %2
	if r == 0:
		$bubble.play( "cycle_0" )
	else:
		$bubble.play( "cycle_1" )