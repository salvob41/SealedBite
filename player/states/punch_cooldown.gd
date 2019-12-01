extends FSM_State


var nxt_action := -1
var timer : float
#
func initialize():
	obj.anim_nxt = "jump_side"
	timer = 0.1


func run( delta ):
	if obj.aimfsm.state_cur != obj.aimfsm.states.aim:
		Engine.time_scale = 0.5
		if nxt_action == 1:
			obj.vel *= 0
			obj.start_jump()
			obj.vel.y *= 1.3
			fsm.state_nxt = fsm.states.jump
			return
	
	obj.vel = obj.move_and_slide( Vector2.UP * 60 )
	
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.idle
	
	if Input.is_action_just_pressed( "btn_fire" ):# or Input.is_action_pressed( "btn_fire" ):
		obj.aimfsm.states.aim.start_aim()
		return
	elif Input.is_action_just_pressed( "btn_jump" ) or Input.is_action_pressed( "btn_jump" ):
		#print( "COOLDOWN ACTION: JUMP" )
		obj.vel *= 0
		obj.start_jump()
		obj.vel.y *= 1.3
		fsm.state_nxt = fsm.states.jump
		return

func terminate():
	if obj.aimfsm.state_cur != obj.aimfsm.states.aim:
		Engine.time_scale = 1.0
	nxt_action = -1





