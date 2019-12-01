extends Sprite

var jump_type := 0

func _ready():
	$anim.play( "dust_" + str( jump_type ) )