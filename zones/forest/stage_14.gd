extends Level

func _ready() -> void:
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	_ret = $finish_position.connect( "body_entered", self, \
		"_on_entering_finish_area" )
	if not gamestate.is_event( "white chrystal" ):
		_ret = $finish_position3.connect( "body_entered", self, \
		"_on_entering_finish_area3" )
	_ret = $finish_position4.connect( "body_entered", self, \
		"_on_entering_finish_area4" )


func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_13.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_08.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()

#func _on_entering_finish_area2( _body ) -> void:
#	gamestate.state.current_lvl = "res://zones/forest/stage_16.tscn"
#	gamestate.state.current_pos = "finish_position"
#	gamestate.state.current_dir = -1
#	game.main.load_gamestate()

func _on_entering_finish_area3( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/mountain/stage_01.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()

func _on_entering_finish_area4( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/cave/stage_07.tscn"
	gamestate.state.current_pos = "finish_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()