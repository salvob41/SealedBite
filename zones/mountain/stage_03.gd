extends Level

func _ready() -> void:
	if gamestate.is_event( "white chrystal" ):
		$avalanche.show()
		$avalanche/AnimationPlayer.play( "cycle" )
		$avalanche/avalanche/audio.play()
	else:
		var _ret = $finish_position.connect( "body_entered", self, \
			"_on_entering_finish_area" )
		$avalanche.hide()
	
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	
#	_ret = $finish_position2.connect( "body_entered", self, \
#		"_on_entering_finish_area2" )


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/mountain/stage_02.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/mountain/stage_04.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()

#func _on_entering_finish_area2( _body ) -> void:
#	gamestate.state.current_lvl = "res://zones/forest/stage_06.tscn"
#	gamestate.state.current_pos = "starting_position"
#	gamestate.state.current_dir = 1
#	game.main.load_gamestate()