extends Level

func _ready() -> void:
	if gamestate.is_event( "open cave" ):
		$black_chrystal_area/anim.play( "fade" )
		$black_chrystal_area/anim.seek( 1, true )
	
	
	
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	_ret = $finish_position.connect( "body_entered", self, \
		"_on_entering_finish_area" )
	_ret = $finish_position2.connect( "body_entered", self, \
		"_on_entering_finish_area2" )
	
	
	
	
	_ret = $wolf_dialog_area.connect( "body_entered", self, \
		"_on_wolf_dialog_area", [], CONNECT_ONESHOT + CONNECT_DEFERRED )
	_ret = $wolf_contact_area.connect( "body_entered", self, \
		"_on_wolf_contact_area", [], CONNECT_ONESHOT + CONNECT_DEFERRED )
	_ret = $black_chrystal_area.connect( "body_entered", self, \
		"_on_black_chrystal", [], CONNECT_ONESHOT + CONNECT_DEFERRED )

	
	


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_05.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_13.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()


# TODO: CONNECT TO LAIR!!!
func _on_entering_finish_area2( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/cave/stage_09.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()




func _on_wolf_dialog_area( _body ) -> void:
	if gamestate.add_event( "first dialog with wolf" ):
		$player.anim_nxt = "idle"
		$player.vel.x = 0
		$player.set_cutscene()
		var msg = game.show_message( "Hello little pup...", \
			$wolf_dialog_area, Vector2.ZERO, 5, true, false )
		yield( msg, "message_finished" )
		
		msg = game.show_message( "I've been waiting for you.", \
			$wolf_dialog_area, Vector2.ZERO, 5, true, false )
		yield( msg, "message_finished" )
		$player.set_cutscene( false )
	
	elif not gamestate.is_event( "bitten" ):
		$player.anim_nxt = "idle"
		$player.vel.x = 0
		$player.set_cutscene()
		var msg = game.show_message( "I'm still waiting little pup...", \
			$wolf_dialog_area, Vector2.ZERO, 5, true, false )
		yield( msg, "message_finished" )
		
		msg = game.show_message( "Come closer.", \
			$wolf_dialog_area, Vector2.ZERO, 5, true, false )
		yield( msg, "message_finished" )
		$player.set_cutscene( false )
	
	pass



func _on_wolf_contact_area( _body ) -> void:
	if gamestate.add_event( "bitten" ):
		$wolf_contact_area/wolf/animate_wolf.play( "attack" )

func _set_knocked_out():
	$player.set_cutscene()
	$player.anim_nxt = "jump_side"
	Engine.time_scale = 0.3
	$player.vel.x = -100
	$player.anim_nxt = "knocked_out"

func _finish_knocked_out():
	Engine.time_scale = 1

func _move_to_next():
	if game.main != null:
		game.main.load_screen( "res://screens/cutscenes/wolf_carying_cutscene.tscn" )




func _on_black_chrystal( _body ):
	if not gamestate.is_event( "black chrystal" ):
		return
	if not gamestate.add_event( "open cave" ):
		return
	
	$player.set_cutscene()
	$player.anim_nxt = "kneel"
	$player.vel.x = 0
	
	game.camera_shake( 6, 30, 2 )
	$background_props/cave_entrance/anim.play( "open" )
	
	yield( get_tree().create_timer( 6 ), "timeout" )
	
	$black_chrystal_area/anim.play("fade")
	var msg = game.show_message( "This must be it...", \
			$player, Vector2.ZERO, 5, true, false )
	yield( msg, "message_finished" )
	
	$player.set_cutscene( false )
	pass

