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
	game.camera_shake( 0.10, 60, 4, obj.hit_dir.normalized() )
	obj.get_node( "damagebox/damage_collision" ).disabled = true
	obj.get_node( "hitbox/hitbox_collision" ).disabled = true


func run( delta ):
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.cooldown
	obj.vel *= 0.9
	obj.vel = obj.move_and_slide( obj.vel )

func terminate():
	obj.get_node( "hitbox/hitbox_collision" ).disabled = false
	pass