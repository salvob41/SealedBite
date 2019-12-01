extends SimpleMenu

func _ready():
	if game.main != null:
		game.main.set_music( 0 )
	
	var _ret = connect( "selected_item", self, "_on_selected_item" )
	
	#var loaded_gamestate = gamestate.load_gamestate()
	if ( not gamestate.first_start ):
		#print( "Chaging selectable" )
		$continue.selectable = true
		update_menu()
	elif gamestate.check_gamestate_file():
		_ret = gamestate.load_gamestate()
		gamestate.state.current_pos = gamestate.state.active_checkpoint[0]
		gamestate.state.current_lvl = gamestate.state.active_checkpoint[1]
		$continue.selectable = true
		update_menu()
	

func _input(event):
	if event.is_action_pressed( "btn_quit" ):
		quit_game()


func _on_selected_item( item_no ):
	if game.main == null: return
	match item_no:
		0:
			# start a new game 
			if ( not gamestate.first_start ):
				self.set_process_input( false )
				var c  = preload( "res://screens/start_menu/check_menu.tscn" ).instance()
				c.connect( "selected_item", self, "_on_check_menu" )
				$checklayer.add_child( c )
			else:
				start_new_game()
		1:
			# continue game
			game.main.load_gamestate()
#			game.set_music( 1 )
		2:
			game.main.load_screen( "res://screens/controls/controls.tscn" )
		3:
			# quit
			quit_game()
	pass


func quit_game():
	get_tree().quit()


func _on_check_menu( item ):
#	$checklayer.get_child(0).queue_free()
	set_process_input( true )
	match item:
		0:
			pass
		1:
			start_new_game()



func start_new_game():
	gamestate.initiate()
	gamestate.state.current_lvl = "res://zones/forest/stage_01.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	gamestate.state.active_checkpoint = [ \
		gamestate.state.current_pos, \
		gamestate.state.current_lvl ]
	gamestate.first_start = false
	
	# save the new game, overlapping the old one
	var _ret = gamestate.save_gamestate()
	
	game.main.load_gamestate()

