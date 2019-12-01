extends StaticBody2D



func _on_check_player_body_entered( _body ) -> void:
	#print( "POSITION CHECK: ", (_body.global_position.y - global_position.y))
	if _body.global_position.y <= global_position.y:
		$anim.play( "cycle" )

var is_broken = false
func _break() -> void:
	if is_broken: return
	is_broken = true
	#yield( get_tree().create_timer( 0.2 ), 'timeout' )
	#print( "BREAKING" )
	$collision.disabled = true
	#$check_player/check_player_collision.disabled = true
	$tileset.hide()
	var b = preload( "res://props/crumbling_block/blocks_group.tscn" ).instance()
	b.position = position
	get_parent().add_child( b )
	pass

func _unbreak():
	if not is_broken: return
	is_broken = false
	#print( "UNBREAKING" )
	$collision.disabled = false
	#$check_player/check_player_collision.disabled = false
	$tileset.show()
