extends FSM_State

var has_gravity := true
var has_animation := true

func initialize():
	if not has_animation:
		obj.anim.stop()
	#obj.vel.x = 0
#	obj.get_node( "cutscene/anim_cutscene" ).play( "start" )

func run( delta ):
	if has_gravity:
		obj.vel.y = min( obj.TERM_VEL, obj.vel.y + obj.GRAVITY * delta )
		obj.move_and_slide( obj.vel, \
			Vector2.UP )
		obj.vel.x *= 0.97

func terminate():
	obj.anim_cur = ""
#	obj.get_node( "cutscene/anim_cutscene" ).play( "end" )