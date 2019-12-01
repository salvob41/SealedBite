extends Level

func _ready():
	if gamestate.is_event( "player entered red chrystal stage" ):
		if gamestate.is_event( "red chrystal" ):
			$chrystal.clear_chrystal()
		$cutscenes/spirit_path/PathFollow2D/path_anim.play( "start" )
		$cutscenes/spirit_path/PathFollow2D/path_anim.seek( 3, true )
	
	var t = Timer.new()
	t.wait_time = 0.5
	t.one_shot = true
	t.connect( "timeout", self, "_connect_areas" )
	add_child( t )
	t.start()
	
	if game.main != null:
		$chrystal.hud_position = game.main.hud_chrystalpos[2]

func _connect_areas() -> void:
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	
	_ret = $cutscenes/start_cutscene_area.connect( "body_entered", self, "_on_player_entered", [], Object.CONNECT_ONESHOT )
	_ret = $chrystal.connect( "player_on_chrystal", self, "_on_player_on_chrystal", [], Object.CONNECT_ONESHOT )
	_ret = $wolf_shadow_area.connect( "body_entered", self, "_on_player_wolf_shadow" )


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/cave/stage_05.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()

func _on_player_entered( _body ):
	if not gamestate.add_event( "player entered red chrystal stage" ):
		return
	$player.set_cutscene()
	$player.vel.x = 0
	$player.anim_nxt = "idle"
	$cutscenes/spirit_path/PathFollow2D/path_anim.play( "start" )
	yield( get_tree().create_timer( 3.5 ), "timeout" )
	
	var msg = game.show_message( "You found the red chrystal!", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
#	msg = game.show_message( "This is the white chrystal.", \
#			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
#			3, false, false )
#	yield( msg, "message_finished" )
	
	$player.set_cutscene( false )
	

func _on_player_on_chrystal():
	if not gamestate.add_event( "red chrystal" ):
		return
	
	$player.set_cutscene()
	$player.vel.x = 0
	$player.anim_nxt = "chrystal"
	
	var msg = game.show_message( "Well done!", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			2, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "Please Take it to the altars.", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			4, false, false )
	yield( msg, "message_finished" )
	
	$player.set_cutscene( false )




func _on_player_wolf_shadow( _body ):
	if not gamestate.is_event( "red chrystal" ):
		return
	if not gamestate.add_event( "red chrystal wolf shadow" ):
		return
	$player.set_cutscene()
	$player.vel.x = 0
	$player.anim_nxt = "kneel"
	yield( get_tree().create_timer( 1.0 ), "timeout" )
	$player/test_wolf_shadow/wolf_shadow_anim.play("start")
	$player/test_wolf_shadow/shadow_sfx.play()
	
#	$cutscenes/spirit_path/PathFollow2D/path_anim.play( "shadow" )
#	yield( get_tree().create_timer( 2.5 ), "timeout" )
	
	var msg = game.show_message( "It's the wolf within you!", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "You are slowly turning... Your body...", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "You are now much stronger", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	
	$player/test_wolf_shadow/wolf_shadow_anim.play_backwards("start")
	yield( get_tree().create_timer( 1.5 ), "timeout" )
	$player.set_cutscene(false)
	
	gamestate.state.can_push = true
	
	# SAVE GAME WITHOUT CHECKPOINT
	gamestate.state.active_checkpoint[0] = "starting_position"
	gamestate.state.active_checkpoint[1] = filename
	gamestate.state.current_pos = gamestate.state.active_checkpoint[0]
	gamestate.state.current_lvl = gamestate.state.active_checkpoint[1]
	var cur_energy = gamestate.state.energy
	gamestate.state.energy = gamestate.state.max_energy
	var _ret = gamestate.save_gamestate()
	gamestate.state.energy = cur_energy
	
