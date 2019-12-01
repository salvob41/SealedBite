tool
extends PathFollow2D

# warning-ignore:unused_signal
signal finished_moving

# warning-ignore:unused_class_variable
export( bool ) var is_last_segment := false
export( bool ) var is_head := false setget _set_head

onready var fsm : FSM

func _ready():
	if Engine.editor_hint:
		set_physics_process( false )
	else:
		fsm = FSM.new( self, $states, $states/idle, false )

func _exit_tree():
	if fsm:
		fsm.free()

func _set_head( v ):
	is_head = v
	if not find_node( "head_body" ) or not find_node( "segment" ):
		return
	if is_head:
		$head_body.show()
		$segment.hide()
	else:
		$head_body.hide()
		$segment.show()


func _physics_process(delta):
	fsm.run_machine( delta )

func _prv_segment_finished_moving():
	fsm.state_nxt = fsm.states.move