extends Node
class_name FSM

var debug = false
var states = {}
var state_cur = null
var state_nxt = null
var state_lst = null
var obj = null


func _init( obj, states_parent_node, initial_state, debug = false ):
	self.obj = obj
	self.debug = debug
	_set_states_parent_node( states_parent_node )
	state_nxt = initial_state
	pass

func _set_states_parent_node( pnode ):
	if debug: print( "Found ", pnode.get_child_count(), " states" )
	if pnode.get_child_count() == 0:
		return
	var state_nodes = pnode.get_children()
	for state_node in state_nodes:
		if debug: print( "adding state: ", state_node.name )
		states[ state_node.name ] = state_node
		state_node.fsm = self
		state_node.obj = self.obj


func run_machine( delta ):
	if state_nxt != state_cur:
		if state_cur != null:
			if debug:
				print( obj.name, ": changing from state ", state_cur.name, " to ", state_nxt.name )
			state_cur.terminate()
		elif debug:
			print( obj.name, ": starting with state ", state_nxt.name )
		state_lst = state_cur
		state_cur = state_nxt
		state_cur.initialize()
	# run state
	state_cur.run( delta )

