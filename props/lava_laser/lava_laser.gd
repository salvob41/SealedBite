extends Polygon2D

export( bool ) var jet_on := true setget setjet

const speed = 3.0

var is_hitting := false
var target_point : Vector2
var target_normal : Vector2
var dist_to_target := 1.0
var target_dist = 0.0

func _ready():
	$lava_animation.seek( randf(), true )
	if jet_on:
		$sfx.play()


func setjet( v ):
	jet_on = v
	if jet_on:
		#show()
		$death.set_collision_layer_bit( 8, true )
		target_dist = 1.0
		$sfx.play()
	else:
		#hide()
		$death.set_collision_layer_bit( 8, false )
		target_dist = 0.0
		$sfx.stop()
	
func _physics_process( delta ):
	if jet_on:
		dist_to_target += speed * delta
	else:
		dist_to_target -= 2*speed * delta
	dist_to_target = clamp( dist_to_target, 0.0, 1.0 )
	set_polygon_and_collision()

	
#	dist_to_target = 0.5#lerp( dist_to_target, 1, 1*delta )
#	if dist_to_target> 0.99:
#		dist_to_target = 1.0

func set_polygon_and_collision():
	target_point = global_position + Vector2( 240, 0 )
	target_normal = Vector2( -1, 0 )
	if $target_ray.is_colliding():
		target_point = $target_ray.get_collision_point()
		target_normal = $target_ray.get_collision_normal()
		is_hitting = true
	else:
		is_hitting = false
		target_point = global_position + Vector2( 240, 0 )
		target_normal = Vector2( -1, 0 )
	# vary target point
	target_point = global_position + ( target_point - global_position ) * dist_to_target
	
	#print( "laser ", is_hitting, " ", target_normal )
	polygon[1].x = ( target_point - global_position ).length()
	polygon[2].x = polygon[1].x
	$death/death_collision.polygon[1].x = polygon[1].x + 8
	$death/death_collision.polygon[2].x = polygon[1].x + 8
	
	if dist_to_target < 0.99:
		$lava_jet_hit.hide()
	else:
		$lava_jet_hit.show()
	$lava_jet_hit.position.x = polygon[1].x
	$lava_jet_hit.global_rotation = -target_normal.angle_to( Vector2.LEFT )# - rotation
	
	
	
	#print( "laser ", is_hitting, " ", target_normal, " ", rad2deg( -target_normal.angle_to( Vector2.LEFT )) )

#func _on_hit_timer_timeout():
#	if is_hitting:
#		var h = hitscn.instance()
#		h.position = position + ( target_point - global_position )
#		h.position += Vector2( rand_range( -2, 2 ), rand_range( -2, 2 ) )
#		h.rotation = rotation - target_normal.angle_to( Vector2.LEFT )
#		get_parent().add_child( h )
