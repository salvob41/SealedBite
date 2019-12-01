extends FSM_State


var death_timer : float

func initialize():
	Engine.time_scale = 1.0
	death_timer = 1.5
	
	var d = preload( "res://player/player_death.tscn" ).instance()
	d.position = obj.position + Vector2( 0, -5 )
	obj.get_parent().add_child( d )
	obj.get_node( "anim" ).stop()
	obj.hide()
	

func run( delta ):
	if death_timer > 0:
		death_timer -= delta
		if death_timer <= 0:
			if game.main != null:
				game.main.level_restart_sfx()
			obj.emit_signal( "player_dead" )