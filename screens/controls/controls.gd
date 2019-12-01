extends Node2D



func _input( event ):
	if event.is_action_pressed( "btn_fire" ) or \
		event.is_action_pressed( "btn_jump" ) or \
		event.is_action_pressed( "btn_quit" ) or \
		event.is_action_pressed( "btn_start" ):
			game.main.load_screen( "res://screens/start_menu/start_menu.tscn" )
