extends Node2D

var is_finished := false

func _ready():
	#print( "STARTING WOLF CARRYING CUTSCENE" )
	if game.main != null:
		game.main.set_music( 0 )
	var _ret = $skip_btn.connect( "skip", self, "_on_skip" )
	_ret = $control_animation.connect( "animation_finished", self, "_on_animation_finished" )



func _on_skip():
	finish()

func _on_animation_finished( _anim ):
	finish()

func finish():
	if is_finished: return
	is_finished = true
	#print( "FINISHED CUTSCENE" )
	$main_fade.play("fadeout")
	yield( $main_fade, "animation_finished" )
	if game.main != null:
		gamestate.state.current_lvl = "res://zones/forest/stage_13.tscn"
		gamestate.state.current_pos = "cutscene_position"
		gamestate.state.current_dir = 1
		game.main.load_gamestate()
		
		
