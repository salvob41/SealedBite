extends FSM_State

func initialize() -> void:
	obj.anim_nxt = "spin"
	obj.vel.y = obj.JUMP_VEL
	fsm.states.jump.jump_dust()
	$double_jump_sfx.play()


func run( delta ):
	fsm.states.jump.base_jump( delta )

#
#	obj.vel.y = min( obj.TERM_VEL, obj.vel.y + obj.GRAVITY * delta )
#
#	var dir = Input.get_action_strength( "btn_right" ) - \
#		Input.get_action_strength( "btn_left" )
#
#	var is_moving = ( abs( dir ) > 0.1 )
#	if is_moving:
#		dir = sign( dir )
#		obj.vel.x = lerp( obj.vel.x, \
#			obj.cur_params.max_vel * dir, \
#			obj.cur_params.air_accel * delta )
#		obj.dir_nxt = dir
#	else:
#		obj.vel.x = lerp( obj.vel.x, 0, \
#			obj.cur_params.air_accel * delta )
#
#	obj.move_and_slide( obj.vel, \
#			Vector2.UP )
#
#	if obj.is_on_floor():
#		fsm.state_nxt = fsm.states.idle
#	elif obj.is_on_ceiling():
#		obj.vel.y = 0.0
#		fsm.state_nxt = fsm.states.fall
#	elif obj.is_on_wall() and Input.is_action_pressed( "btn_climb" ) and \
#		fsm.states.wall_grab.can_grab():
#		fsm.state_nxt = fsm.states.wall_grab
#	else:
#		if obj.vel.y > 0:
#			fsm.state_nxt = fsm.states.fall
#
#	if Input.is_action_just_pressed( "btn_fire" ):
#		fsm.state_nxt = fsm.states.punch
#		return