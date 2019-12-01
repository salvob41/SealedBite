extends Level


func _ready():
	can_pause = false
	game.main.get_node( "hud_layer/hud" ).call_deferred( "hide" )
	
	var t = Timer.new()
	t.wait_time = 0.1
	t.one_shot = true
	t.connect( "timeout", self, "_connect_areas" )
	add_child( t )
	t.start()
	
	if game.main != null:
		game.main.get_node( "hud_layer/hud/game_map" ).hide()
	
	

func _connect_areas() -> void:
	$player.set_cutscene()
	$player.anim_nxt = "fall"
	#$player.dir_nxt = -1
	var _ret = $arrival.connect( "body_entered", self, \
		"_on_arrival", [], CONNECT_ONESHOT + CONNECT_DEFERRED )
	pass
	
	


func _on_arrival( _body ):
#	$player.set_cutscene( false )
	$player.anim_nxt = "idle"
	yield( get_tree().create_timer( 2 ), "timeout" )
	
	var _msg = game.show_message( "You finally arrived...", \
		$enemies/wolf, Vector2.UP * 16, 6, true, false )
	yield( get_tree().create_timer( 1 ), "timeout" )
	$arrival/camera_shift_anim.play( "shift" )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "... Came to do the spirit's bidding?", \
		$enemies/wolf, Vector2.UP * 16, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "You're a monster! Condemned me to become like you!", \
		$player, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
		
	_msg = game.show_message( "I did no such thing!!!", \
		$enemies/wolf, Vector2.UP * 16, 4, true, false )
		
	$enemies/spirit_path/follow/spirit_path.play("arrive")
	yield( get_tree().create_timer( 0.5 ), "timeout" )
	
	yield( _msg, "message_finished" )
	yield( get_tree().create_timer( 1 ), "timeout" )
	
	_msg = game.show_message( "Enough chatting! Kill the wolf!!!", \
		$enemies/spirit_path/follow/forest_spirit, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "Did he not tell you?", \
		$enemies/wolf, Vector2.UP * 16, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "He's the one who made me bite you...", \
		$enemies/wolf, Vector2.UP * 16, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "... I guess he wants a new pet", \
		$enemies/wolf, Vector2.UP * 16, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "I've had enough of you!", \
		$enemies/spirit_path/follow/forest_spirit, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	var b = preload("res://enemies/spirit_laser/spirit_laser.tscn").instance()
	b.position = $enemies/spirit_path/follow/forest_spirit.global_position - $enemies.global_position
	b.dir_nxt = 1
	b.vel = Vector2( 30, 30 )
	$enemies.add_child( b )
	
	
	yield( get_tree().create_timer( 1.4 ), "timeout" )
	$enemies/wolf.queue_free()
	$enemies/wolf_death_particles.emitting = true
		
	yield( get_tree().create_timer( 3 ), "timeout" )
	
	_msg = game.show_message( "Is it true?", \
		$player, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	$enemies/spirit_path/follow/forest_spirit.set_dark = true
	_msg = game.show_message( "Now that I have the black chrystal...", \
		$enemies/spirit_path/follow/forest_spirit, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "... I am the ultimate force of the forest.", \
		$enemies/spirit_path/follow/forest_spirit, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	_msg = game.show_message( "I will destroy you!", \
		$player, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	
	$enemies/spirit_path/follow/spirit_path.play( "fight" )
	yield( get_tree().create_timer( 2 ), "timeout" )
	
	_msg = game.show_message( "You will try...", \
		$enemies/spirit_path/follow/forest_spirit, Vector2.ZERO, 4, true, false )
	yield( _msg, "message_finished" )
	
	
	$enemies/big_boss_transformation/anim_transform.play("transform")
	$enemies/spirit_path/follow/forest_spirit.get_node( "spirit_particles/pixel" ).hide()
	$enemies/spirit_path/follow/forest_spirit.get_node( "spirit_particles" ).emitting = false
	$enemies/spirit_path/follow/forest_spirit.get_node( "dark_particles" ).emitting = false
	yield( get_tree().create_timer( 3 ), "timeout" )
	
	
	
	gamestate.state.current_lvl = "res://zones/cave/stage_10.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	
	# SAVE GAME WITHOUT CHECKPOINT
	gamestate.state.active_checkpoint[0] = gamestate.state.current_pos
	gamestate.state.active_checkpoint[1] = gamestate.state.current_lvl
	gamestate.state.energy = gamestate.state.max_energy
	var _ret = gamestate.save_gamestate()
	
	game.main.load_gamestate()
	