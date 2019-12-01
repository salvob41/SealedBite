extends FSM_State

var drop_timer : float
var wall_dir : float
var fall_timer : float

var particle_timer : float

func initialize():
	drop_timer = 0.5
	fall_timer = 0.1
	#obj.anim_nxt = "wall_grab"
	obj.get_node( "anim" ).play( "wall_grab" )
	obj.get_node( "anim" ).queue( "wall_grab_cycle" )
	wall_dir = sign( Input.get_action_strength( "btn_right" ) - \
		Input.get_action_strength( "btn_left" ) )
	obj.vel *= 0
	particle_timer = 0.05
	$AudioStreamPlayer.play()



func run( delta ) -> void:
	#print( "G: ", obj.get_node( "anim" ).current_animation )
	if Input.is_action_just_pressed( "btn_jump" ):
		fsm.state_nxt = fsm.states.wall_jump
		return
	
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
		return
	
	if not obj.can_wall_jump():
		fsm.state_nxt = fsm.states.fall
		return
	
	var dir = Input.get_action_strength( "btn_right" ) - \
		Input.get_action_strength( "btn_left" )
	
	if ( dir * wall_dir ) < 0.1:
		fall_timer -= delta
		if fall_timer <= 0:
			fsm.state_nxt = fsm.states.fall
	else:
		fall_timer = 0.1
	
	if drop_timer > 0:
		drop_timer -= delta
	else:
		obj.vel.y = 10
		
		particle_timer -= delta
		if particle_timer <= 0:
			particle_timer = 0.2
			var p = preload( "res://player/dust_particles/wall_slide_dust.tscn" ).instance()
			p.position = obj.position + Vector2( 4 * obj.dir_cur, 0 )
			p.scale.x = obj.dir_cur
			obj.get_parent().add_child( p )
		
	#print( "GRAB DIR: ", obj.dir_cur * Vector2.RIGHT * 80 )
	obj.vel = obj.move_and_slide_with_snap( obj.vel, obj.dir_cur * Vector2.RIGHT * 8, Vector2.UP )
	if obj.is_on_floor():
		fsm.state_nxt = fsm.states.fall

func terminate():
	obj.anim_cur = ""



