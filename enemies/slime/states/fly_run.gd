extends FSM_State

func initialize():
	obj.anim_nxt = "run"


func run( _delta ):
	if obj.check_wall():
		obj.dir_nxt = -obj.dir_cur
	
	obj.vel.x = obj.dir_cur * 30
	obj.vel = obj.move_and_slide( obj.vel )
	