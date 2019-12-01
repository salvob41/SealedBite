extends FSM_State

const ATTACK_VEL = 400
var emerg_timer = 0.5

func start_punch( target : WeakRef ):
	# set target
	obj.cur_target = target
	
	# set special collision
	obj.get_node( "collision" ).disabled = true
	obj.get_node( "punch_collision" ).disabled = false
	
	# activate damage collision
	obj.get_node( "rotate/jump_rotate/damagebox/damage_collision" ).disabled = false
#	obj.get_node( "damagebox/damage_collision" ).disabled = false
	
	# deactivate some collisions
	obj.get_node( "force_jump/force_jump_collision" ).disabled = true
	
	# start punch state
	fsm.state_nxt = fsm.states.punch


func initialize():
	var target_pos = obj.cur_target.get_ref().global_position + obj.cur_target.get_ref().target_offset
	var dir = target_pos - obj.get_node( "punch_collision" ).global_position
	var d = preload( "res://player/dust_particles/attack_dust.tscn" ).instance()
	d.position = obj.position
	d.rotation = _set_body_rotation( dir )
	obj.get_parent().add_child( d )
	emerg_timer = 0.5
	pass
	


func run( delta ):
	emerg_timer -= delta
	
	# if no target, leave
	if obj.cur_target == null or obj.cur_target.get_ref() == null:
		fsm.state_nxt = fsm.states.punch_cooldown
		return
	
	var target_pos = obj.cur_target.get_ref().global_position + obj.cur_target.get_ref().target_offset
	var dir = target_pos - obj.get_node( "punch_collision" ).global_position
	if dir.length() > 8 and emerg_timer > 0:
		obj.vel = obj.move_and_slide( dir.normalized() * ATTACK_VEL, Vector2.UP )
		var _ret = _set_body_rotation( dir )
	else:
		#print( "PUNCH" )
		# blast
		var b = preload( "res://player/blasts_and_particles/punch_blast.tscn" ).instance()
		b.global_position = obj.get_node( "rotate/jump_rotate/punch_position" ).global_position
		b.rotation = obj.get_node( "rotate/jump_rotate" ).rotation
		obj.get_parent().add_child( b )
		# screen shake
		game.camera_shake( 0.1, 600, 6, dir.normalized() )
		
		fsm.state_nxt = fsm.states.punch_cooldown
	
	if Input.is_action_just_pressed( "btn_jump" ):
		fsm.states.punch_cooldown.nxt_action = 1 # starts jump immediately



func terminate():
	obj.get_node( "collision" ).disabled = false
	obj.get_node( "punch_collision" ).disabled = true
	obj.get_node( "rotate/jump_rotate/damagebox/damage_collision" ).disabled = true
#	obj.get_node( "damagebox/damage_collision" ).disabled = true
	obj.get_node( "force_jump/force_jump_collision" ).disabled = false
	obj.get_node( "rotate/jump_rotate" ).rotation = 0
	obj.cur_target = null
	#print( "PUNCH TERMINATE ", obj.dir_cur )


func _set_body_rotation( dir0 : Vector2 ) -> float:
	var dir = dir0
	if abs( dir.y ) < 4: dir.y = 0
	if abs( dir.x ) < 4: dir.x = 0
	var ang = dir.angle()
	if dir.x >= 0:
		obj.dir_nxt = 1
		obj.get_node( "rotate/jump_rotate" ).rotation = ang
	else:
		obj.dir_nxt = -1
		obj.get_node( "rotate/jump_rotate" ).rotation = PI - ang
	return ang


#enum ACTIONS { NONE, PUNCH, JUMP }
#
#var cur_punch := 0
#var punch_timer : float
#var has_target : bool
#var reached_target : bool
#var nxt_action = ACTIONS.NONE
#var has_hit_target : bool = false
#
#const ATTACK_VEL = 400
#
#var target_pos : Vector2


#func initialize():
#	obj.anim_nxt = "punch_" + str( cur_punch )
#	cur_punch = 1 - cur_punch
#	punch_timer = 0.2
#	nxt_action = ACTIONS.NONE
#
#	# check enemies
#	obj.get_node( "rotate/jump_rotate/damagebox/damage_collision" ).disabled = false
#	has_target = false
#	reached_target = true
#	var enemies = obj._enemy_in_sight()
#	#print( "enemies: ", enemies )
#	if not enemies.empty():
#		#print( "Current target: ", enemies[0].name )
#		obj.cur_target = weakref( enemies[0] )
#		has_target = true
#		reached_target = false
#		target_pos = obj.cur_target.get_ref().global_position
#		var dist = target_pos - obj.global_position
#		if abs( dist.y ) < 4: dist.y = 0
#		if abs( dist.x ) < 4: dist.x = 0
#		if dist.x >= 0:
#			obj.dir_nxt = 1
#			obj.get_node( "rotate/jump_rotate" ).rotation = dist.angle()
#		else:
#			obj.dir_nxt = -1
#			obj.get_node( "rotate/jump_rotate" ).rotation = PI - dist.angle()
#		if dist.length() > 16:
#			obj.get_node( "rotate/jump_rotate/punch_highlight" ).show()
#			obj.get_node( "rotate/jump_rotate/punch_highlight/highlight_anim" ).play( "cycle" )
#			var d = preload( "res://player/dust_particles/attack_dust.tscn" ).instance()
#			d.position = obj.position
#			d.rotation = dist.angle()
#			obj.get_parent().add_child( d )
#	pass
#
#func run( delta ) -> void:
##	print( "tick" )
#	if Input.is_action_just_pressed( "btn_fire" ):
#		nxt_action = ACTIONS.PUNCH
#	# move towards target
#	if has_target and \
#		not reached_target and \
#		obj.cur_target != null and \
#		obj.cur_target.get_ref() != null:
#			if Input.is_action_just_pressed( "btn_jump" ):
#				nxt_action = ACTIONS.JUMP
#			target_pos = obj.cur_target.get_ref().global_position
#			var dir = target_pos - obj.global_position
#			if dir.length() > 12:
#				obj.vel = obj.move_and_slide( dir.normalized() * ATTACK_VEL, Vector2.UP )
#			else:
#				#print( "PUNCH" )
#				has_hit_target = true
#				obj.vel *= 0
#				reached_target = true
#				obj.get_node( "rotate/jump_rotate/damagebox/damage_collision" ).disabled = true
#				# blast
#				var b = preload( "res://player/blasts_and_particles/punch_blast.tscn" ).instance()
#				b.global_position = obj.get_node( "rotate/jump_rotate/punch_position" ).global_position
#				b.rotation = obj.get_node( "rotate/jump_rotate" ).rotation
#				obj.get_parent().add_child( b )
#	elif not has_target:
#		#print( "PUNCH WITHOUT TARGET" )
#		if not has_hit_target:
#			obj.vel.y = min( obj.TERM_VEL, obj.vel.y + obj.GRAVITY * delta )
#			var dirx = Input.get_action_strength( "btn_right" ) - \
#				Input.get_action_strength( "btn_left" )
#			obj.vel.x = obj.cur_params.max_vel * sign( dirx )
#			if dirx > 0:
#				obj.dir_nxt = 1
#			elif dirx < 0:
#				obj.dir_nxt = -1
#			obj.move_and_slide( obj.vel, Vector2.UP )
#	punch_timer -= delta
#	if punch_timer <= 0:
#		if has_target and reached_target:
#			finish_punch( nxt_action )
#		else:
#			if has_hit_target:
#				finish_punch( nxt_action )
#			else:
#				fsm.state_nxt = fsm.states.jump
#
#	if punch_timer < -0.5:
#		fsm.state_nxt = fsm.states.jump
#
#
#func finish_punch( nxt_action ):
#	match nxt_action:
#		ACTIONS.NONE:
#			fsm.state_nxt = fsm.states.punch_cooldown
#		ACTIONS.PUNCH:
#			has_hit_target = false
#			terminate()
#			initialize()
#		ACTIONS.JUMP:
#			#print( "punch state: moving directly to jump" )
#			has_hit_target = false
#			obj.start_jump()
#			obj.vel.y *= 1.3
#			fsm.state_nxt = fsm.states.jump
#
#func terminate() -> void:
#	obj.cur_target = null
#	obj.get_node( "rotate/jump_rotate" ).rotation = 0
#	obj.get_node( "rotate/jump_rotate/damagebox/damage_collision" ).disabled = true
#	obj.get_node( "rotate/jump_rotate/punch_highlight" ).hide()
#	obj.get_node( "rotate/jump_rotate/punch_highlight/highlight_anim" ).stop()
		
	
	
	



