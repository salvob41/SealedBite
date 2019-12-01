extends FSM_State


var  timer : float

func initialize() -> void:
#	obj.get_node( "jumpbox/jumpcollision" ).disabled = true
	obj.get_node( "hitbox/hitbox_collision" ).disabled = true
	obj.get_node( "damagebox/damage_collision" ).disabled = true
	obj.anim_nxt = "jump"
	timer = 1.1
	obj.emit_signal( "jump" )

func run( delta ) -> void:
	timer -= delta
	if timer <=0:
		fsm.state_nxt = fsm.states.run

func terminate() -> void:
#	obj.get_node( "jumpbox/jumpcollision" ).disabled = false
	obj.get_node( "hitbox/hitbox_collision" ).disabled = false
	obj.get_node( "damagebox/damage_collision" ).disabled = false


