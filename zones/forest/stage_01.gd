extends Level

func _ready() -> void:
	
	gamestate.add_event( "starting game" )
	
	
	var _ret = $finish_position.connect( "body_entered", self, "_on_finish_position" )

func _on_finish_position( _body ) -> void:
	print( "finished" )
	gamestate.state.current_lvl = "res://zones/forest/stage_03.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()
	pass