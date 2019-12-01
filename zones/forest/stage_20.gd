extends Level


func _ready() -> void:
	can_pause = false
	
	game.main.get_node( "hud_layer/hud" ).call_deferred( "hide" )
	
	$player.set_cutscene( true )
	$player.anim_nxt = "idle"
	
	$altars/altar_1/anim.play( "on" )
	$altars/altar_1/chrystal.hide()
	$altars/altar_2/anim.play( "on" )
	$altars/altar_2/chrystal.hide()
	$altars/altar_3/anim.play( "on" )
	$altars/altar_3/chrystal.hide()
	
	var t = Timer.new()
	t.wait_time = 2
	t.one_shot = true
	t.connect( "timeout", self, "_on_start_timer" )
	add_child( t )
	t.start()


func _on_start_timer():
	$forest_parallax_background/anim.play("rise")
	var _msg = game.show_message( "It's over!", \
		$player, Vector2(0,-8), 3, true, false )
	yield( _msg, "message_finished" )

	_msg = game.show_message( "I should go back to normal...", \
		$player, Vector2(0,-8), 4, true, false )
	yield( _msg, "message_finished" )

	_msg = game.show_message( "... right?", \
		$player, Vector2(0,-8), 4, true, false )
	yield( _msg, "message_finished" )
	
	$player.hide()
	$player_wolf_transformation/AnimationPlayer.play("transform")
	yield( get_tree().create_timer( 5 ), "timeout" )
	
	$fadeout_layer/fadeanim.playback_speed = 0.2
	$fadeout_layer/fadeanim.play("fadeout")
	
	yield( get_tree().create_timer( 6 ), "timeout" )
	
	game.main.load_screen( game.main.MENU_SCN )


#	var _ret = $starting_position.connect( "body_entered", self, \
#		"_on_entering_starting_area" )
#	_ret = $finish_position.connect( "body_entered", self, \
#		"_on_entering_finish_area" )
#	_ret = $finish_position2.connect( "body_entered", self, \
#		"_on_entering_finish_area2" )
#
#	if gamestate.is_event( "bitten" ) and gamestate.add_event( "wake at altars" ):
#		call_deferred( "_wake_at_altars" )
#
#	if gamestate.is_event( "bitten" ):
#		_ret = $attack_tutorial.connect( "body_entered", self, \
#			"_on_attack_tutorial" )
#
#	if not gamestate.is_event( "black chrystal" ):
#		if gamestate.is_event( "green chrystal" ):
#			_ret = $altars/altar_1.connect( "body_entered", self, \
#				"_on_green_altar" )
#		if gamestate.is_event( "white chrystal" ):
#			_ret = $altars/altar_2.connect( "body_entered", self, \
#				"_on_white_altar" )
#		if gamestate.is_event( "red chrystal" ):
#			_ret = $altars/altar_3.connect( "body_entered", self, \
#				"_on_red_altar" )
#	else:
#		make_chrystals_invisible()
#		$cutscenes/introduction_path/path_follow/path_anim.play( "final" )
#		$cutscenes/introduction_path/path_follow/path_anim.seek( 2, true )
#		$cutscenes/chrystal_anim.play( "black" )
#		$cutscenes/chrystal_anim.seek( 5.2, true )
#
#
#func _on_entering_starting_area( _body ) -> void:
#	gamestate.state.current_lvl = "res://zones/forest/stage_07.tscn"
#	gamestate.state.current_pos = "finish_position"
#	gamestate.state.current_dir = -1
#	game.main.load_gamestate()
#
#func _on_entering_finish_area( _body ) -> void:
#	gamestate.state.current_lvl = "res://zones/forest/stage_14.tscn"
#	gamestate.state.current_pos = "starting_position"
#	gamestate.state.current_dir = 1
#	game.main.load_gamestate()
#
#func _on_entering_finish_area2( _body ) -> void:
#	gamestate.state.current_lvl = "res://zones/cave/stage_08.tscn"
#	gamestate.state.current_pos = "starting_position"
#	gamestate.state.current_dir = 1
#	game.main.load_gamestate()
#
#func _wake_at_altars():
#	gamestate.state.can_attack = true
#	$player.set_cutscene()
#	$player.anim_nxt = "sleeping"
#	$cutscenes/introduction_path/path_follow/path_anim.play("start")
#	yield( get_tree().create_timer( 4 ), "timeout" )
#
#	$player.anim_nxt = "wake_up"
#	yield( get_tree().create_timer( 2 ), "timeout" )
#	var msg = game.show_message( "You are awake... Thank goodness!", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	#yield( msg, "message_finished" )
#	yield( get_tree().create_timer( 5 ), "timeout" )
#
#	$cutscenes/introduction_path/path_follow/path_anim.play("check")
#	yield( get_tree().create_timer( 4 ), "timeout" )
#
#	msg = game.show_message( "The werewolf... He bit you!", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "Who are you?", \
#			$player, Vector2.ZERO, \
#			3, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "I'm the forest spirit", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "I protect this forest from evil", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "and now you are in terrible danger", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "Why?", \
#			$player, Vector2.ZERO, \
#			3, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "The werewolf bite.", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "Soon you will turn...", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "... Into a terrible creature", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "Your only hope...", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "... Is to destroy the wolf", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "How?", \
#			$player, Vector2.ZERO, \
#			3, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "Find the 3 chrystals...", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	msg = game.show_message( "... and bring them here", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
##	msg = game.show_message( "The green chrystal, deep in this forest", \
##			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
##			5, false, false )
##	yield( msg, "message_finished" )
##
##	msg = game.show_message( "The white chrystal, at the mountain top", \
##			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
##			5, false, false )
##	yield( msg, "message_finished" )
##
##	msg = game.show_message( "and the red chrystal, within the lava caves", \
##			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
##			5, false, false )
##	yield( msg, "message_finished" )
#
#	gamestate.state.visited_stages.append( "res://zones/forest/stage_15.tscn" )
#	gamestate.state.visited_stages.append( "res://zones/mountain/stage_05.tscn" )
#	gamestate.state.visited_stages.append( "res://zones/forest/stage_06.tscn" )
#
#	msg = game.show_message( "I've marked the chrystal locations on your map", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#	# TODO: Show map
#
#	msg = game.show_message( "Now go! Before it's too late!", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#	yield( msg, "message_finished" )
#
#
#	$player.set_cutscene( false )
#	if game.main != null:
#		game.main.set_music( 1 )
#
#
#func _on_attack_tutorial( _body ) -> void:
#	if gamestate.add_event( "attack tutorial" ):
#		$player.anim_nxt = "idle"
#		$player.vel.x = 0
#		$player.set_cutscene()
#		var msg = game.show_message( "At the sight of an enemy...", \
#			$player, Vector2.ZERO, 5, true, false )
#		yield( msg, "message_finished" )
#
#		msg = game.show_message( "... you feel the urge to attack.", \
#			$player, Vector2.ZERO, 5, true, false )
#		yield( msg, "message_finished" )
#
#		msg = game.show_message( "Hold fire to focus your rage.", \
#			$player, Vector2.ZERO, 5, true, false )
#		yield( msg, "message_finished" )
#
#		$player.set_cutscene( false )
#
#
#
#
#func _on_green_altar( _body ) -> void:
#	if not gamestate.add_event( "green chrystal recovered" ):
#		return
#	$player.anim_nxt = "idle"
#	$player.vel.x = 0
#	$player.set_cutscene()
#	yield( get_tree().create_timer( 1 ), "timeout" )
#
#	var msg = game.show_message( "Thank you!", \
#		$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#		5, false, false )
#	yield( msg, "message_finished" )
#	$player.set_cutscene( false )
#
#
#
#func _on_white_altar( _body ) -> void:
#	if not gamestate.add_event( "white chrystal recovered" ):
#		return
#	$player.anim_nxt = "idle"
#	$player.vel.x = 0
#	$player.set_cutscene()
#	yield( get_tree().create_timer( 1 ), "timeout" )
#
#	var msg = game.show_message( "The white chrystal", \
#		$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#		5, false, false )
#	yield( msg, "message_finished" )
#	if gamestate.is_event( "red chrystal recovered" ):
#		msg = game.show_message( "Only one more left", \
#			$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#			5, false, false )
#		yield( msg, "message_finished" )
#	$player.set_cutscene( false )
#
#func _on_red_altar( _body ) -> void:
#	if not gamestate.add_event( "red chrystal recovered" ):
#		return
#	$player.anim_nxt = "idle"
#	$player.vel.x = 0
#	$player.set_cutscene()
#
#	$cutscenes/introduction_path/path_follow/path_anim.play( "last_chrystal" )
#
#	var msg = game.show_message( "The final chrystal", \
#		$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#		2.5, false, false )
#	yield( get_tree().create_timer( 2.5 ), "timeout" )
#	make_chrystals_invisible()
#	gamestate.add_event( "black chrystal" )
#	$cutscenes/chrystal_anim.play("black")
#	yield( get_tree().create_timer( 1.5 ), "timeout" )
#	$cutscenes/introduction_path/path_follow/path_anim.play("final")
#	msg = game.show_message( "Now we are ready...", \
#		$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#		2.5, false, false )
#	yield( get_tree().create_timer( 1.5 ), "timeout" )
#	msg = game.show_message( "Find the wolf's lair!...", \
#		$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#		2.5, false, false )
#	yield( msg, "message_finished" )
#	msg = game.show_message( "... and destroy your foe!", \
#		$cutscenes/introduction_path/path_follow/forest_spirit, Vector2.ZERO, \
#		2.5, false, false )
#	yield( msg, "message_finished" )
#	$player.set_cutscene( false )
#
#
#func make_chrystals_invisible():
#	$altars/altar_1/chrystal.hide()
#	$altars/altar_2/chrystal.hide()
#	$altars/altar_3/chrystal.hide()

