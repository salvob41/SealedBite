extends Sprite

func _ready():
	var r = randi() % 3
	$anim.play( "dust_" + str( r ) )
#	print( "DUST: ", $anim.current_animation )

