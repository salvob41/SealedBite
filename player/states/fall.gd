extends FSM_State

var coyote_timer : float
var jump_timer : float
var jump_again : bool

func initialize() -> void:
	obj.anim_nxt = "fall"
	coyote_timer = obj.COYOTE_TIME
	jump_again = false

func run( delta ):
	# timers
	coyote_timer -= delta
	jump_timer -= delta
	
	
	# Fall motion
	obj.vel.y = min( obj.TERM_VEL, obj.vel.y + obj.GRAVITY * delta )
	
	var dir = Input.get_action_strength( "btn_right" ) - \
		Input.get_action_strength( "btn_left" )
	
	var is_moving = ( abs( dir ) > 0.1 )
	if is_moving:
		dir = sign( dir )
		obj.vel.x = lerp( obj.vel.x, \
			obj.MAX_VEL * dir, \
			obj.AIR_ACCEL * delta )
		obj.dir_nxt = dir
	else:
		obj.vel.x = lerp( obj.vel.x, 0, \
			obj.AIR_ACCEL * delta )
	
	obj.move_and_slide( obj.vel, \
			Vector2.UP )
	
	
	# actions
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
#		fsm.states.punch.initialize()
#		fsm.state_nxt = fsm.states.punch
		return
	
	if is_moving and obj.is_on_wall() and obj.dir_cur == dir and obj.can_wall_jump() and not obj.is_on_floor():
		fsm.state_nxt = fsm.states.wall_grab
		return
	
	if Input.is_action_just_pressed( "btn_jump" ):
		# jump immediately after landing
		jump_timer = obj.JUMP_AGAIN_MARGIN
		jump_again = true
		if coyote_timer > 0 and \
			fsm.state_lst != fsm.states.jump and \
			fsm.state_lst != fsm.states.double_jump:
				# coyote jump
				obj.start_jump()
				fsm.state_nxt = fsm.states.jump
				return
		elif is_moving and obj.is_on_wall() and obj.can_wall_jump():
				# wall jump
				fsm.state_nxt = fsm.states.wall_jump
				return
		elif fsm.state_lst != fsm.states.jump and \
			fsm.state_lst != fsm.states.double_jump:
				# fall and then double jump
				if gamestate.state.can_double_jump:
					fsm.state_nxt = fsm.states.double_jump
					return
		elif fsm.state_lst == fsm.states.jump:
				# simple double jump
				if gamestate.state.can_double_jump:
					fsm.state_nxt = fsm.states.double_jump
					return
		
	
	# landing
	if obj.is_on_floor():
#		fsm.states.punch.has_hit_target = false
		if jump_again and jump_timer >= 0:
			# jump again
			obj.start_jump()
			fsm.state_nxt = fsm.states.jump
		else:
			# land
			if abs( obj.vel.x ) > 1:
				obj.anim_fx.play( "land_side" )
				fsm.state_nxt = fsm.states.run
			else:
				obj.anim_fx.play( "land" )
				fsm.state_nxt = fsm.states.idle
	
	