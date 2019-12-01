extends FSM_State

var timer : float

func initialize():
	timer = 0.1
	obj.anim_nxt = "hit"
	obj.get_node( "rotate/detect_player/detect_box" ).disabled = true
	obj.get_node( "rotate/damagebox/damage_collision" ).disabled = true
	obj.vel = obj.hit_dir.normalized() * 100
	#print( "HIT VELOCITY: ", obj.vel )
	game.camera_shake( 0.10, 60, 4, obj.hit_dir.normalized() )
	

func run( delta ):
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.cooldown
	if not obj.check_wall():
		obj.vel = obj.move_and_slide_with_snap( obj.vel, \
				obj.get_node( "rotate" ).scale.y * Vector2.DOWN * 8, \
				obj.get_node( "rotate" ).scale.y * Vector2.UP )

func terminate():
#	obj.get_node( "rotate/detect_player/detect_box" ).disabled = false
	pass