extends FSM_State

var hit_timer : float

func initialize() -> void:
	hit_timer = 0.2
	obj.anim_fx.play( "hit" )
	obj.cur_target = null
	obj.is_invulnerable = true
	obj.invulnerable_timer = 0.5
	$AudioStreamPlayer.play()

func run( delta ) -> void:
	hit_timer -= delta
	if hit_timer <= 0:
		fsm.state_nxt = fsm.states.idle
	obj.vel = obj.move_and_slide( obj.vel )
	if obj.is_on_floor():
		obj.vel.x *= 0.98

func terminate():
	obj.anim_fx.play( "default" )