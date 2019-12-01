extends Area2D
signal green_chrystal_recovered
signal white_chrystal_recovered
signal red_chrystal_recovered


# warning-ignore:unused_class_variable
export( int ) var number := 1
var is_activated := false

func _ready():
	if ( gamestate.is_event( "green chrystal recovered" ) and number == 1 ) or \
		( gamestate.is_event( "white chrystal recovered" ) and number == 2 ) or \
		( gamestate.is_event( "red chrystal recovered" ) and number == 3 ):
			is_activated = true
		
	if is_activated:
		$anim.play("on")
	else:
		$anim.play("default")

func _on_altar_1_body_entered(_body):
	if is_activated: return
	if number == 1 and gamestate.is_event( "green chrystal" ):
		is_activated = true
		$anim.play( "activate" )
		$anim.queue( "on" )
#		yield( get_tree().create_timer( 2.2 ), "timeout" )
		emit_signal( "green_chrystal_recovered" )
	elif number == 2 and gamestate.is_event( "white chrystal" ):
		is_activated = true
		$anim.play( "activate" )
		$anim.queue( "on" )
#		yield( get_tree().create_timer( 2.2 ), "timeout" )
		emit_signal( "white_chrystal_recovered" )
	elif number == 3 and gamestate.is_event( "red chrystal" ):
		is_activated = true
		$anim.play( "activate" )
		$anim.queue( "on" )
#		yield( get_tree().create_timer( 2.2 ), "timeout" )
		emit_signal( "red_chrystal_recovered" )







