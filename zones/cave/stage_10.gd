extends Level

var boss_energy := 10

func _ready():
	game.main.get_node( "hud_layer/hud" ).call_deferred( "show" )
	$enemies/anim_master.play("wait")
	$enemies/anim_master.queue("pattern_1")
	pass

func _on_spirit_boss_boss_hit():
	boss_energy = int( max( boss_energy - 1, 0 ) )
	$CanvasLayer/boss_energy.polygon[1].x = boss_energy * 8
	$CanvasLayer/boss_energy.polygon[2].x = boss_energy * 8
	if boss_energy == 0:
		final_cutscene()
		
		
	return


func _on_anim_animation_finished( _anim_name ):
	return

func final_cutscene():
	$fadeout_layer/fadeanim.play("fadeout")
	$player.set_cutscene( true, false )
	$enemies/spirit_boss.dead()
	$enemies/anim_master.stop()
	$enemies/anim.stop()
	yield( get_tree().create_timer( 6 ), "timeout" )
	
	gamestate.state.current_lvl = "res://zones/forest/stage_20.tscn"
	gamestate.state.current_pos = "starting_position"
	gamestate.state.current_dir = 1
	game.main.load_gamestate()
	
	
#	$player.set_cutscene( true, false )
#	$player.anim_nxt = "idle"
#
#	var _msg = game.show_message( "It's over!", \
#		$player, Vector2.ZERO, 3, true, false )
#	yield( _msg, "message_finished" )
#
#	_msg = game.show_message( "I should go back to normal...", \
#		$player, Vector2.ZERO, 4, true, false )
#	yield( _msg, "message_finished" )
#
#	_msg = game.show_message( "... right?", \
#		$player, Vector2.ZERO, 4, true, false )
#	yield( _msg, "message_finished" )
	
	# TODO Fade out


