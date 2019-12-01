extends FSM_State

const PAN_WAIT_TIME = 0.5
var pan_timer : float

func initialize() -> void:
	obj.anim_nxt = "idle"
	pan_timer = PAN_WAIT_TIME

func run( delta ):
	obj.vel = obj.move_and_slide_with_snap( Vector2.ZERO, \
			Vector2.DOWN * obj.SNAP_LEN, \
			Vector2.UP )
	
	
	if obj.is_on_floor():
		if Input.is_action_pressed( "btn_left" ) or \
			Input.is_action_pressed( "btn_right" ):
				fsm.state_nxt = fsm.states.run
		
		if Input.is_action_pressed( "btn_down" ) and \
			not Input.is_action_pressed( "btn_up" ):
				pan_timer -= delta
				if pan_timer <= 0:
					game.camera.pan_camera( Vector2( 0, 36 ) )
				if Input.is_action_just_pressed( "btn_jump" ):
					obj.position.y += 1
					fsm.state_nxt = fsm.states.fall
					return
		elif Input.is_action_pressed( "btn_up" ) and \
			not Input.is_action_pressed( "btn_down" ):
				pan_timer -= delta
				if pan_timer <= 0:
					game.camera.pan_camera( Vector2( 0, -36 ) )
		else:
			pan_timer = PAN_WAIT_TIME
			game.camera.pan_camera( Vector2.ZERO )
		
		
		if Input.is_action_just_pressed( "btn_jump" ):
			obj.start_jump()
			fsm.state_nxt = fsm.states.jump
		
	else:
		fsm.state_nxt = fsm.states.fall
	
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
#		fsm.states.punch.initialize()
#		fsm.state_nxt = fsm.states.punch
		return


func terminate() -> void:
	if game.camera == null: return
	game.camera.pan_camera( Vector2.ZERO )
	