extends KinematicBody2D

func squash_left( no_dust : bool = false ):
	$block_anim.play( "squash_left" )
	if not no_dust:
		var dscn = preload( "res://player/dust_particles/run_dust.tscn" )
		var d = dscn.instance()
		d.scale = Vector2( -1, -1 )
		d.rotation = -PI / 2
		d.position = position + $pos_top_left.position
		get_parent().add_child( d )
		
		d = dscn.instance()
		d.scale = Vector2( 1, -1 )
		d.rotation = -PI / 2
		d.position = position + $pos_bottom_left.position
		get_parent().add_child( d )
		
func squash_right( no_dust : bool = false ):
	$block_anim.play( "squash_right" )
	if not no_dust:
		var dscn = preload( "res://player/dust_particles/run_dust.tscn" )
		var d = dscn.instance()
		d.scale = Vector2( -1, 1 )
		d.rotation = -PI / 2
		d.position = position + $pos_top_right.position
		get_parent().add_child( d )
		
		d = dscn.instance()
		d.scale = Vector2( 1, 1 )
		d.rotation = -PI / 2
		d.position = position + $pos_bottom_right.position
		get_parent().add_child( d )
		
func squash_up( no_dust : bool = false ):
	$block_anim.play( "squash_up" )
	if not no_dust:
		var dscn = preload( "res://player/dust_particles/run_dust.tscn" )
		var d = dscn.instance()
		d.scale = Vector2( 1, -1 )
		d.rotation = -PI / 2
		d.position = position + $pos_top_left.position
		get_parent().add_child( d )
		
		d = dscn.instance()
		d.scale = Vector2( -1, -1 )
		d.rotation = -PI / 2
		d.position = position + $pos_top_right.position
		get_parent().add_child( d )
		
func squash_down( no_dust : bool = false ):
	$block_anim.play( "squash_down" )
	if not no_dust:
		var dscn = preload( "res://player/dust_particles/run_dust.tscn" )
		var d = dscn.instance()
		d.scale = Vector2( 1, 1 )
		d.rotation = 0
		d.position = position + $pos_bottom_left.position
		get_parent().add_child( d )
		
		d = dscn.instance()
		d.scale = Vector2( -1, 1 )
		d.rotation = 0
		d.position = position + $pos_bottom_right.position
		get_parent().add_child( d )