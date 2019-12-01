extends Node2D
class_name VerletChain

export( float ) var gravity := 10.0
export( float ) var resistance := 0.80
export( float ) var friction := 0.90
export( float ) var chain_link_length := 2.0


var loops = []
var links = []



func _ready():
	call_deferred( "setup_chain" )
	
func setup_chain():
	# find anchor
	loops = []
	links = []
	var children = get_children()
	for c in children:
		if c is VerletLoop:
			loops.append( c )
			break
	
	# recursively create chain
	create_chain( loops[0] )
	
	# set initial positions
	for loop in loops:
		loop.pos_cur = loop.global_position
		loop.pos_prv = loop.global_position
#		print( loop.anchor )
#		print( loop.pos_cur )
	for link in links:
		link.global_position = ( link.parent.global_position + link.child.global_position ) * 0.5
		link.global_rotation = link.parent.pos_cur.angle_to_point( link.child.pos_cur ) + PI / 2


func create_chain( parent ):
	var found_loop = false
	var children = parent.get_children()
	for c in children:
		if c is VerletLoop:
			loops.append( c )
			found_loop = true
			break
	for c in children:
		if c is VerletLink:
			links.append( c )
			c.parent = parent
			c.child = loops[-1]
			break
	if found_loop:
		create_chain( loops[-1] )


func _physics_process( delta ):
	_update_loops( delta )
	_constrain_links( delta )
	_render_frame()


func _update_loops( delta ):
	for loop in loops:
		if loop.anchor:
			loop.pos_prv = loop.pos_cur
			loop.pos_cur = loop.global_position
		else:
			var vel = ( loop.pos_cur - loop.pos_prv ) * resistance * friction
			loop.pos_prv = loop.pos_cur
			loop.pos_cur += vel
			loop.pos_cur.y += gravity * delta


func _constrain_links( delta ):
	for link in links:
		#print( link.get_parent().name )
		var vector = ( link.child.pos_cur - link.parent.pos_cur ) / delta
		var distance = link.child.pos_cur.distance_to( link.parent.pos_cur )
		if distance < 0.01: distance = 0.01
		var difference = chain_link_length - distance
		var percentage = difference / distance
		if percentage > 1: percentage = 1
		vector *= percentage
		link.child.pos_cur += vector * delta
	pass

func _render_frame():
	for loop in loops:
		loop.global_position = loop.pos_cur#.round()
	for link in links:
		link.global_position = ( ( link.parent.global_position + link.child.global_position ) * 0.5 )#.round()
		link.global_rotation = link.parent.pos_cur.angle_to_point( link.child.pos_cur ) + PI / 2
	pass

