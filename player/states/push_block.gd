extends FSM_State

func initialize() -> void:
	obj.anim_nxt = "push"

func run( _delta ) -> void:
	if not obj.is_push_block():
		fsm.state_nxt = fsm.states.run
		return
	
	if Input.is_action_just_pressed( "btn_jump" ):
		obj.start_jump()
		fsm.state_nxt = fsm.states.jump
		return
	
	var dir = Input.get_action_strength( "btn_right" ) - \
		Input.get_action_strength( "btn_left" )
	var is_moving = ( abs( dir ) > 0.1 )
	if is_moving:
		dir = sign( dir )
		obj.vel = obj.move_and_slide_with_snap( \
			Vector2( obj.MAX_VEL, 0 ) * dir, \
			Vector2.DOWN * 8, \
			Vector2.UP )
		obj.get_node( "rotate/check_pushblock" ).get_collider().move_and_slide( Vector2.RIGHT * dir * 15 )
		obj.dir_nxt = dir
	else:
		fsm.state_nxt = fsm.states.idle
		
	if not obj.is_on_floor():
		fsm.state_nxt = fsm.states.fall
	
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
		return