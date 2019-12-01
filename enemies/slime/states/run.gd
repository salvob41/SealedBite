extends FSM_State



func initialize():
	obj.anim_nxt = "run"


func run( _delta ):
	if obj.check_wall():
		obj.dir_nxt = -obj.dir_cur
	
	obj.vel.x = obj.dir_cur * 20
	obj.vel.y = 0#min( obj.vel.y + 500 * delta, 160 )
	obj.vel = obj.move_and_slide_with_snap( obj.vel, \
			Vector2.DOWN * 8, \
			Vector2.UP )
