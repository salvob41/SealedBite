extends StaticBody2D

signal player_on_chrystal

export( int ) var type = 0

var hud_position := Vector2( 208, 8 )



func _ready():
	match type:
		0:
			$anim.play( "green" )
		1:
			$anim.play( "blue" )
		2:
			$anim.play( "red" )
		3:
			$anim.play( "black" )

func _on_detect_player_body_entered( _body ):
	emit_signal( "player_on_chrystal" )
	$pickup.play()
	$anim_up_down.stop()
	
	$tween.interpolate_property( $chrystal, "position", $chrystal.position, \
		$chrystal.position + Vector2( 0, -16 ), 1.0, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0 )
	
	$tween.start()
	
	var _ret = $tween.connect( "tween_completed" , self, "_on_tween_completed" )

func _on_tween_completed( _a, _b ):
	var chrystal_position_on_screen = $chrystal.get_global_transform_with_canvas().origin
	var required_motion = hud_position - chrystal_position_on_screen
	
#	print( chrystal_position_on_screen, " ", required_motion )


	$tween2.interpolate_property( $chrystal, "position", $chrystal.position, \
		$chrystal.position + required_motion, required_motion.length() / 100.0, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0 )

	$chrystal.z_index = 5
	$tween2.start()
	var _ret = $tween2.connect( "tween_completed" , self, "_on_tween2_completed" )

func _on_tween2_completed( _a, _b ):
	$anim.queue_free()
	$anim_up_down.queue_free()
	$chrystal.queue_free()
	$acquired.play()
	
	match type:
		0:
			gamestate.state.green_chrystal = true
		1:
			gamestate.state.white_chrystal = true
		2:
			gamestate.state.red_chrystal = true
	if type < 3 and game.main != null:
		game.main.set_hud_particles( type )

func clear_chrystal():
	$anim.queue_free()
	$anim_up_down.queue_free()
	$detect_player.queue_free()
	$chrystal.queue_free()