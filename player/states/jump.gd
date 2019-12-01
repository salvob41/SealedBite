extends FSM_State

var keypress_timer : float
#var climb_timer : float

func initialize() -> void:
	if abs( obj.vel.x ) > 0.1:
		obj.anim_nxt = "jump_side"
	else:
		obj.anim_nxt = "jump_up"
	if fsm.state_lst != fsm.states.wall_jump:
		obj.anim_fx.play( "jump" )
		jump_dust()
	keypress_timer = 0.2
	#if fsm.state_lst != fsm.states.wall_jump:
		
#	climb_timer = obj.CLIMB_TIMER_MARGIN

func run( delta ):
	if base_jump( delta ):
		return
	if Input.is_action_just_pressed( "btn_jump" ) and \
		gamestate.state.can_double_jump:
			fsm.state_nxt = fsm.states.double_jump
			return
	

func base_jump( delta ) -> bool:
	obj.vel.y = min( obj.TERM_VEL, obj.vel.y + obj.GRAVITY * delta )
	if keypress_timer >= 0:
		keypress_timer -= delta
		if keypress_timer < 0 or Input.is_action_just_released( "btn_jump" ):
			keypress_timer = -1.0
			#print( "REDUCING SPEED" )
			obj.vel.y *= 0.5
	
	var dir = Input.get_action_strength( "btn_right" ) - \
		Input.get_action_strength( "btn_left" )
	
	var is_moving = ( abs( dir ) > 0.1 )
	#print( is_moving )
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
	
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
#		fsm.states.punch.initialize()
#		fsm.state_nxt = fsm.states.punch
		return true
	
	if Input.is_action_just_pressed( "btn_jump" ) and \
		is_moving and obj.is_on_wall() and obj.can_wall_jump():
			# wall jump
			fsm.state_nxt = fsm.states.wall_jump
			return true
	
	if obj.is_on_floor():
		obj.anim_fx.play( "land" )
		fsm.state_nxt = fsm.states.idle
	elif obj.is_on_ceiling():
		obj.vel.y = 0.0
		fsm.state_nxt = fsm.states.fall
#	elif obj.is_on_wall() and Input.is_action_pressed( "btn_climb" ) and \
#		fsm.states.wall_grab.can_grab():
#		fsm.state_nxt = fsm.states.wall_grab
	else:
		if obj.vel.y > 0:
			fsm.state_nxt = fsm.states.fall
	return false


func jump_dust():
	#print( "adding particles" )
	var d = preload( "res://player/dust_particles/jump_dust.tscn" ).instance()
	d.scale.x = obj.dir_cur
	d.position = obj.position + Vector2( 0, 3 )
	if abs( obj.vel.x ) > 10:
		d.jump_type = 1 
	obj.get_parent().add_child( d )










