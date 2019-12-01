extends Area2D

var is_active := false
#onready var event_name = ""#owner.filename + get_path()


func _ready():
	set_process_input( false )
	if gamestate.state.active_checkpoint[0] == name and \
		gamestate.state.active_checkpoint[1] == owner.filename:
			activate_checkpoint()
	$arrow/anim_fade.play( "fade_in" )

func activate_checkpoint():
	if is_active:
		$anim.play_backwards( "start" )
		$anim.queue( "start" )
		$anim.queue( "cycle" )
	else:
		$anim.play( "start" )
		$anim.queue( "cycle" )
		is_active = true
	
#	gamestate.state.current_pos = name
	
	
var can_save = false
func _on_checkpoint_body_entered(_body):
	if not can_save: return
	activate_checkpoint()
	if game.main != null:
		game.main.show_bottom_msg( "Game Saved" )
	gamestate.state.active_checkpoint[0] = name
	gamestate.state.active_checkpoint[1] = owner.filename
	gamestate.state.current_pos = gamestate.state.active_checkpoint[0]
	gamestate.state.current_lvl = gamestate.state.active_checkpoint[1]
	var cur_energy = gamestate.state.energy
	gamestate.state.energy = gamestate.state.max_energy
	var _ret = gamestate.save_gamestate()
	gamestate.state.energy = cur_energy
	
	$checkpoint.play()
#	$arrow/anim_fade.play( "fade_in" )
#	set_process_input( true )
	can_save = false
	$delay_timer.start()


func _on_checkpoint_body_exited(_body):
	pass
#	$arrow/anim_fade.play( "fade_out" )
#	set_process_input( false )


func _on_Timer_timeout():
	can_save = true

#func _input(event):
#	if event.is_action_pressed( "btn_up" ):
#		activate_checkpoint()
#		gamestate.state.active_checkpoint[0] = name
#		gamestate.state.active_checkpoint[1] = owner.filename
#		gamestate.state.current_pos = gamestate.state.active_checkpoint[0]
#		gamestate.state.current_lvl = gamestate.state.active_checkpoint[1]
#		var cur_energy = gamestate.state.energy
#		gamestate.state.energy = gamestate.state.max_energy
#		var _ret = gamestate.save_gamestate()
#		gamestate.state.energy = cur_energy





func _on_load_timer_timeout():
	can_save = true
	pass # Replace with function body.
