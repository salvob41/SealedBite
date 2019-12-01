extends Node2D
class_name Level

#var starting_gamestate : Dictionary
var can_pause = true

func _ready() -> void:
	#print( "FILNAME: ", filename )
#	print( "STARTING GAMESTATE: ", gamestate.state )
	call_deferred( "_get_starting_gamestate" )
	call_deferred( "_set_player" )
	call_deferred( "_set_camera" )
	set_music()

func _get_starting_gamestate():
	gamestate.state.visited_stages.append( filename )
	gamestate.state.current_lvl = filename
	gamestate.saved_state = gamestate.state.duplicate( true )


func _set_player() -> void:
	var player = find_node( "player" )
	if player == null:
		if game.debug: print( "Level: player not found" )
		return
	if gamestate.state.keys().find( "current_pos" ) != -1 and \
		not gamestate.state.current_pos.empty():
			var startpos = find_node( gamestate.state.current_pos )
			if startpos == null:
				if game.debug: print( "Level: start position not found, using preset" )
			else:
				if game.debug: print( "Level: start position at ", startpos.name )
				player.global_position = startpos.global_position
				player.dir_nxt = gamestate.state.current_dir
	else:
		var startpos = find_node( "starting_position" )
		#print( "START POS NODE: ", startpos )
		if startpos == null:
			if game.debug: print( "Level: start position not found, using preset" )
		else:
			if game.debug: print( "Level: start position at ", startpos.name )
			player.global_position = startpos.global_position
	player.connect( "player_dead", self, "_on_player_dead" )


func _set_camera() -> void:
	var camera = find_node( "camera" )
	if camera == null:
		if game.debug: print( "Level: camera not found" )
		return
	var pos_NW = find_node( "camera_limit_NW" )
	if pos_NW != null:
		camera.limit_left = pos_NW.position.x
		camera.limit_top = pos_NW.position.y
	var pos_SE = find_node( "camera_limit_SE" )
	if pos_SE != null:
		camera.limit_right = pos_SE.position.x
		camera.limit_bottom = pos_SE.position.y


func _on_player_dead() -> void:
	if game.main == null:
		var _ret = get_tree().reload_current_scene()
	else:
		var _ret = gamestate.load_gamestate()
		gamestate.state.current_pos = gamestate.state.active_checkpoint[0]
		gamestate.state.current_lvl = gamestate.state.active_checkpoint[1]
		print( "LOADED GAMESTATE: ", gamestate.state )
		game.main.load_gamestate()

func _input(event):
	if event.is_action_pressed( "btn_quit" ) or \
		event.is_action_pressed( "btn_start" ):
			if game.main != null and can_pause:
				game.main.call_deferred( "pause_game" )



func set_music():
	if game.main == null: return
	# THIS IS THE WORST POSSIBLE WAY TO DO THIS!!!!
	var musicno = -1
	if filename.find( "forest/" ) != -1:
		musicno = 1
	elif filename.find( "mountain/" ) != -1:
		musicno = 2
	elif filename.find( "cave/" ) != -1:
		musicno = 3
		if filename.find( "_10" ) != -1:
			musicno = 2
	game.set_music( musicno )
	pass



