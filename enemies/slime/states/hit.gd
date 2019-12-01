extends FSM_State

var timer : float

func initialize():
	timer = 0.05
	obj.anim_nxt = "hit"
	obj.vel = obj.hit_dir.normalized() * 150
	if obj.vel.x > 0:
		obj.dir_nxt = 1
	elif obj.vel.x < 0:
		obj.dir_nxt = -1
	#game.camera_shake( 0.10, 60, 4, obj.hit_dir.normalized() )
	obj.get_node( "damagebox/damage_collision" ).disabled = true
	obj.get_node( "hitbox/hitbox_collision" ).disabled = true


func run( delta ):
	#obj.get_node( "hitbox/hitbox_collision" ).disabled = false
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.cooldown
	obj.vel.y = min( obj.vel.y + 500 * delta, 160 )
	obj.vel.x *= 0.95
	if not obj.check_wall():
		obj.vel = obj.move_and_slide_with_snap( obj.vel, \
				obj.get_node( "rotate" ).scale.y * Vector2.DOWN * 8, \
				obj.get_node( "rotate" ).scale.y * Vector2.UP )

func terminate():
	obj.get_node( "hitbox/hitbox_collision" ).disabled = false
	obj.is_hit = false