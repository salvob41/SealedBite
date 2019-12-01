extends FSM_State

func initialize():
	obj.anim_nxt = "run"


func run( _delta ):
	if obj.check_wall():
		obj.dir_nxt = -obj.dir_cur
	
	obj.vel.x = obj.dir_cur * 15
	obj.vel = obj.move_and_slide_with_snap( obj.vel, \
			obj.get_node( "rotate" ).scale.y * Vector2.DOWN * 8, \
			obj.get_node( "rotate" ).scale.y * Vector2.UP )
	
