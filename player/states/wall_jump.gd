extends FSM_State

var state = 0
var timer : float

func initialize() -> void:
	obj.anim_nxt = "wall_jump"
	state = 0
	timer = 0.2
	#print( "DIR CUR: ", obj.dir_cur )
	var dir = Input.get_action_strength( "btn_right" ) - \
			Input.get_action_strength( "btn_left" )
	dir = sign( dir )
	if dir == obj.dir_cur:
		#print( "TOWARDS WALL" )
		obj.vel.x = 0
		obj.start_jump()
		obj.vel.y *= 1.15
		obj.anim_nxt = "jump_up"
		wall_jump_up_dust()
	else:
		#print( "AWAY FROM WALL" )
		obj.vel.x = -obj.dir_cur * obj.MAX_VEL * 0.8
		obj.start_jump()
		obj.vel.y *= 1.15
		obj.anim_nxt = "jump_side"
		obj.dir_nxt = -obj.dir_cur
		wall_jump_away_dust()

func run( delta ) -> void:
	obj.vel.y = min( obj.TERM_VEL, obj.vel.y + obj.GRAVITY * delta )
	obj.move_and_slide( obj.vel, Vector2.UP )
	timer -= delta
	if timer < 0:
		fsm.state_nxt = fsm.states.jump
		var dir = Input.get_action_strength( "btn_right" ) - \
			Input.get_action_strength( "btn_left" )
		if abs( dir ) > 0.1:
			dir = sign( dir )
			obj.vel.x = dir * obj.MAX_VEL
				
	if Input.is_action_just_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
		return
	
func wall_jump_away_dust():
	#print( "adding particles" )
	var d = preload( "res://player/dust_particles/jump_dust.tscn" ).instance()
	#d.scale.x = obj.dir_cur
	if obj.vel.x < 0:
		d.rotation = -PI / 2
		d.position = obj.position + Vector2( 5, -6 )
	elif obj.vel.x > 0:
		d.scale.x = -1
		d.rotation = PI / 2
		d.position = obj.position + Vector2( -5, -6 )
	d.jump_type = 1 
	obj.get_parent().add_child( d )


func wall_jump_up_dust():
	var d = preload( "res://player/dust_particles/jump_dust.tscn" ).instance()
	d.position = obj.position + Vector2( obj.dir_cur * 1, -6 )
	d.jump_type = 0 
	obj.get_parent().add_child( d )









