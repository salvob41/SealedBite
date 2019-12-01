extends FSM_State

var timer : float

func initialize():
	# dead animation
	obj.get_node( "anim" ).stop()
	obj.get_node( "rotate/hitbox/hitbox_collision" ).disabled = true
	obj.get_node( "rotate/damagebox/damage_collision" ).disabled = true
	obj.get_node( "rotate/detect_player/detect_box" ).disabled = true
	obj.get_node( "collision" ).disabled = true
	obj.get_node( "rotate/ron_enemy" ).hide()
	timer = 3
	#game.camera_shake( 0.10, 60, 4, obj.hit_dir.normalized() )
	if randf() < game.heart_drop_rate():
		var h = preload( "res://props/heart/heart.tscn" ).instance()
		h.position = obj.position
		h.vel = -obj.hit_dir * 10
		obj.get_parent().add_child( h )


func run( delta ):
	if timer > 0:
		timer -= delta
	else:
		obj.position = obj.initial_position
		if not game.am_i_visible(obj):
			fsm.state_nxt = fsm.states.run

func terminate():
	obj.get_node( "anim" ).play()
	obj.get_node( "rotate/hitbox/hitbox_collision" ).disabled = false
	obj.get_node( "rotate/damagebox/damage_collision" ).disabled = false
	obj.get_node( "rotate/detect_player/detect_box" ).disabled = false
	obj.get_node( "collision" ).disabled = false
	obj.get_node( "rotate/ron_enemy" ).show()
	obj.energy = 1