extends TextureRect

#var bubbles_scn = preload( "res://props/water/lava_bubbles.tscn" )

func _ready():
	call_deferred( "_set_collisions" )
func _set_collisions():
	$player_death/collision.shape.extents = rect_size / 2.0
	$player_death.position = rect_size / 2.0
##	if name == "lava":
##		print( "LAVA: ", rect_size )
##		print( $player_death.position )
##		print( $player_death/collision.shape.extents )
##
#	$particles.position = Vector2( rect_size.x / 2, 3 )
#	$particles.process_material.emission_box_extents.x = 1
#	$particles.process_material.emission_box_extents.y = rect_size.x / 2
#	$particles.amount = int( rect_size.x / 128.0 * 30.0 )
#
#func _on_bubbles_timer_timeout():
##	$player_death/collision.shape.extents = rect_size / 2.0
##	$player_death.position = rect_size / 2.0
#	var b = bubbles_scn.instance()
#	b.position = Vector2( round( rand_range( 16, rect_size.x - 16 ) ), 3 )
#	add_child( b )
#	$bubbles_timer.wait_time = rand_range( 0.1, 0.4 )
#	$bubbles_timer.start()
#
#
#func _on_collision_item_rect_changed():
#	print( "CHANGED" )
#	pass # Replace with function body.
