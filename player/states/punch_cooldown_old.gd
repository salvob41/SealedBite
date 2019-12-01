extends FSM_State

enum ACTIONS { NONE, PUNCH, JUMP }
var nxt_action 
var timer : float

func initialize():
	obj.anim_nxt = "jump_side"
	timer = 0.25
	nxt_action = ACTIONS.NONE

func run( delta ):
	timer -= delta
	if timer <= 0:
		fsm.state_nxt = fsm.states.idle
	if Input.is_action_just_pressed( "btn_fire" ):# or Input.is_action_pressed( "btn_fire" ):
		#print( "COOLDOWN ACTION: FIRE" )
		fsm.states.punch.initialize()
		fsm.state_nxt = fsm.states.punch
		fsm.states.punch.has_hit_target = false
	elif Input.is_action_just_pressed( "btn_jump" ) or Input.is_action_pressed( "btn_jump" ):
		#print( "COOLDOWN ACTION: JUMP" )
		obj.start_jump()
		obj.vel.y *= 1.3
		fsm.state_nxt = fsm.states.jump
		
	

#func finish_punch( nxt_action ):
#	match nxt_action:
#		ACTIONS.NONE:
#			fsm.state_nxt = fsm.states.idle
#		ACTIONS.PUNCH:
#			fsm.states.punch.initialize()
#			fsm.state_nxt = fsm.states.punch
#		ACTIONS.JUMP:
#			print( "JUMPING" )
#			obj.start_jump()
#			fsm.state_nxt = fsm.states.jump



