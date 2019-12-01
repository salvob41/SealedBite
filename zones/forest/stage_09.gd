extends Level

func _ready() -> void:
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	_ret = $finish_position.connect( "body_entered", self, \
		"_on_entering_finish_area" )


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_05.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_07.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()