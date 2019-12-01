extends FSM_State

var timer : float

func initialize():
	timer = 1.15
	obj.anim_nxt = "hit"
	obj.vel *= 0


func run( delta ):
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.run
	obj.vel *= 0.8

func terminate():
	obj.get_node( "damagebox/damage_collision" ).disabled = false