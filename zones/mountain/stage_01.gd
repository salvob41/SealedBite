extends Level

func _ready() -> void:
	if gamestate.is_event( "white chrystal" ):
		$avalanche.show()
		$avalanche/AnimationPlayer.play( "cycle" )
		$avalanche/avalanche/audio.play()
	else:
		$avalanche.hide()
		var _ret = $finish_position.connect( "body_entered", self, \
			"_on_entering_finish_area" )
	
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	
#	_ret = $finish_position2.connect( "body_entered", self, \
#		"_on_entering_finish_area2" )


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_14.tscn"
	gamestate.state.current_pos = "finish_position3"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()
	
	if gamestate.is_event( "white chrystal" ):
		# SAVE GAME WITHOUT CHECKPOINT
		gamestate.state.active_checkpoint[0] = gamestate.state.current_pos
		gamestate.state.active_checkpoint[1] = gamestate.state.current_lvl
		var cur_energy = gamestate.state.energy
		gamestate.state.energy = gamestate.state.max_energy
		var _ret = gamestate.save_gamestate()
		gamestate.state.energy = cur_energy

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/mountain/stage_02.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()

#func _on_entering_finish_area2( _body ) -> void:
#	gamestate.state.current_lvl = "res://zones/forest/stage_06.tscn"
#	gamestate.state.current_pos = "starting_position"
#	gamestate.state.current_dir = 1
#	game.main.load_gamestate()