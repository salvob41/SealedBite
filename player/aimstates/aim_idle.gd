extends FSM_State

var mask

func initialize():
	mask = obj.get_node( "player_punch_mask" )
	
func run( delta ):
	if mask.modulate.a > 0:
		mask.modulate.a = lerp( mask.modulate.a, 0, 10 * delta )
		if mask.modulate.a < 0.05:
			mask.modulate.a = 0
