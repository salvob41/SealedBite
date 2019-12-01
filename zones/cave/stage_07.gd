extends Level

func _ready():
	var t = Timer.new()
	t.wait_time = 0.5
	t.one_shot = true
	t.connect( "timeout", self, "_connect_areas" )
	add_child( t )
	t.start()

func _connect_areas() -> void:
	var _ret = $starting_position.connect( "body_entered", self, \
		"_on_entering_starting_area" )
	_ret = $finish_position.connect( "body_entered", self, \
		"_on_entering_finish_area" )

func _on_entering_starting_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/cave/stage_05.tscn"
	gamestate.state.current_pos = "finish_position2"
	gamestate.state.current_dir = -1
	game.main.load_gamestate()

func _on_entering_finish_area( _body ) -> void:
	gamestate.state.current_lvl = "res://zones/forest/stage_14.tscn"
	gamestate.state.current_pos = "finish_position4"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()
	
	if gamestate.is_event( "red chrystal" ):
		# SAVE GAME WITHOUT CHECKPOINT
		gamestate.state.active_checkpoint[0] = gamestate.state.current_pos
		gamestate.state.active_checkpoint[1] = gamestate.state.current_lvl
		var cur_energy = gamestate.state.energy
		gamestate.state.energy = gamestate.state.max_energy
		var _ret = gamestate.save_gamestate()
		gamestate.state.energy = cur_energy

