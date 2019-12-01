extends Level

func _ready():
	if gamestate.is_event( "player entered green chrystal stage" ):
		if gamestate.is_event( "green chrystal" ):
			$chrystal.clear_chrystal()
		if gamestate.is_event( "green chrystal wolf shadow" ):
			$cutscenes/spirit_path/PathFollow2D/path_anim.play( "shadow" )
			$cutscenes/spirit_path/PathFollow2D/path_anim.seek( 2, true )
		else:
			$cutscenes/spirit_path/PathFollow2D/path_anim.play( "start" )
			$cutscenes/spirit_path/PathFollow2D/path_anim.seek( 3, true )
	
	if game.main != null:
		$chrystal.hud_position = game.main.hud_chrystalpos[0]

	
	var t = Timer.new()
	t.wait_time = 0.25
	t.one_shot = true
	t.connect( "timeout", self, "_connect_areas" )
	add_child( t )
	t.start()

func _connect_areas() -> void:
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	_ret = $finish_position.connect( "body_entered", self, \
		"_on_entering_finish_area" )
	
	_ret = $cutscenes/start_cutscene_area.connect( "body_entered", self, "_on_player_entered", [], Object.CONNECT_ONESHOT )
	_ret = $chrystal.connect( "player_on_chrystal", self, "_on_player_on_chrystal", [], Object.CONNECT_ONESHOT )
	_ret = $wolf_shadow_area.connect( "body_entered", self, "_on_player_wolf_shadow", [], Object.CONNECT_ONESHOT )
		
	


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_12.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_16.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()



func _on_player_entered( _body ):
	if not gamestate.add_event( "player entered green chrystal stage" ):
		return
	$player.set_cutscene()
	$player.vel.x = 0
	$player.anim_nxt = "idle"
	$cutscenes/spirit_path/PathFollow2D/path_anim.play( "start" )
	yield( get_tree().create_timer( 3.5 ), "timeout" )
	
	var msg = game.show_message( "Finally, You arrived!", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "There is the chrystal. Please take it!", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	$player.set_cutscene( false )
	
	
	

func _on_player_on_chrystal():
	if not gamestate.add_event( "green chrystal" ):
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
	
	#yield( get_tree().create_timer( 1.2 ), "timeout" )
	$player.set_cutscene( false )
	


func _on_player_wolf_shadow( _body ):
	if not gamestate.add_event( "green chrystal wolf shadow" ):
		return
	gamestate.state.can_wall_jump = true
	$player.set_cutscene()
	$player.vel.x = 0
	$player.anim_nxt = "kneel"
	yield( get_tree().create_timer( 1.0 ), "timeout" )
	$player/test_wolf_shadow/wolf_shadow_anim.play("start")
	
	$cutscenes/spirit_path/PathFollow2D/path_anim.play( "shadow" )
	$player/test_wolf_shadow/shadow_sfx.play()
	yield( get_tree().create_timer( 2.5 ), "timeout" )
	
	var msg = game.show_message( "It's the wolf within you!", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "You are slowly turning... Your hands...", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "You can now cling on to walls", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	msg = game.show_message( "You must hurry", \
			$cutscenes/spirit_path/PathFollow2D/forest_spirit, Vector2.ZERO, \
			3, false, false )
	yield( msg, "message_finished" )
	
	
	$player/test_wolf_shadow/wolf_shadow_anim.play_backwards("start")
	yield( get_tree().create_timer( 1.5 ), "timeout" )
	$player.set_cutscene(false)
	
	
	
	# SAVE GAME WITHOUT CHECKPOINT
	gamestate.state.active_checkpoint[0] = "starting_position"
	gamestate.state.active_checkpoint[1] = filename
	gamestate.state.current_pos = gamestate.state.active_checkpoint[0]
	gamestate.state.current_lvl = gamestate.state.active_checkpoint[1]
	var cur_energy = gamestate.state.energy
	gamestate.state.energy = gamestate.state.max_energy
	var _ret = gamestate.save_gamestate()
	gamestate.state.energy = cur_energy
