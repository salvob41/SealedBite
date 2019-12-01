extends FSM_State

func initialize() -> void:
	obj.anim_nxt = "run"

func run( _delta ) -> void:
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
		obj.dir_nxt = dir
	else:
		fsm.state_nxt = fsm.states.idle
	
	if is_moving and obj.is_on_wall() and \
		obj.is_push_block():
			fsm.state_nxt = fsm.states.push_block
		
	if not obj.is_on_floor():
		fsm.state_nxt = fsm.states.fall
	
	
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
#		fsm.states.punch.initialize()
#		fsm.state_nxt = fsm.states.punch
		return
