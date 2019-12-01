extends Sprite
class_name MapPart

var flash := false setget _set_flash

func _set_flash( v ):
	flash = v
	if flash:
		$flash_anim.play( "cycle" )
	else:
		$flash_anim.stop( true )
		modulate = Color( 1, 1, 1, 1 )