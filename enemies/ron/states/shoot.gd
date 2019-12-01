extends FSM_State

var timer : float

func initialize():
	timer = 0.9
	obj.anim_nxt = "shoot"
	

func run( delta ):
	timer -= delta
	if timer <= 0:
		if not ( obj.player_in_area and obj._player_line_of_sight() ):
			fsm.state_nxt = fsm.states.run
		else:
			timer = 0.9
			obj.anim_cur = ""




