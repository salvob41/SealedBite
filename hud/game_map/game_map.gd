extends ViewportContainer

var cur_part

func _ready():
	_update_map()

func highlight( v = true):
	#print( "highlighting ", cur_part )
	if cur_part != null:
		cur_part.flash = v

func _update_map():
	var curfile = gamestate.state.current_lvl
	
#	if cur_part != null:
#		cur_part.flash = false
	
	var part_node = find_node( fname2part( curfile ) )
	for c in get_node( "Viewport/map" ).get_children():
		if c.name == fname2part( curfile ):
			part_node = c
			break
	if part_node == null: return
	
	# center viewport canvas
	$Viewport.canvas_transform.origin = -part_node.position + \
		( $Viewport.size - part_node.region_rect.size ) * 0.5
	
	# make visited sections visible
	for p in $Viewport/map.get_children():
		var fname = part2fname( p.name )
		if gamestate.state.visited_stages.find( fname ) != -1:
			#print( "found ", fname )
			p.show()
		else:
			#print( "hiding ", fname )
			p.hide()
	
	#highlight current part
	#part_node.flash = true
	cur_part = part_node


func part2fname( part ):
	return "res://" + part.substr( 0, part.length() - 3 ).replace( "_", "/" ) + \
		part.substr( part.length() - 3, 3 ) + ".tscn"

func fname2part( fname ):
	return fname.substr( 6, fname.length() - 6 - 5 ).replace( "/", "_" )

