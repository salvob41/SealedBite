extends FSM_State

var timer : float

func initialize():
	timer = 1.15
	obj.anim_nxt = "hit"


func run( delta ):
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.run

func terminate():
	obj.get_node( "rotate/detect_player/detect_box" ).disabled = false
	obj.get_node( "rotate/damagebox/damage_collision" ).disabled = false