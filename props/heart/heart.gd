extends Area2D


signal heart_captured

var MAX_VEL = 0
var vel := Vector2()
var move_to_player := false
var start_timer = 0.5
var can_move := false
var can_hit := false





func _physics_process(delta):
	if start_timer > 0:
		start_timer -= delta
		if start_timer < 0:
			can_move = true
			can_hit = true
			$collision.call_deferred( "set_disabled", false )
			#set_collision_mask_bit( 1, true )
		vel *= 0.95
		position += vel * delta
	#print( move_to_player )
	if move_to_player:
		var dist = game.player.global_position + Vector2( 0, -8 ) - global_position
		var distlen = dist.length()
		var desired_vel = dist.normalized() * MAX_VEL * delta * 5
		if distlen < 24:
			desired_vel = dist.normalized() * MAX_VEL * delta * distlen / 24
		vel += desired_vel
		vel = vel.clamped( MAX_VEL )
		position += vel * delta
		
		MAX_VEL += 100 * delta
	



var is_hit = false
func _on_hit_player_body_entered(_body):
#	print( "PLAYER ENTERED" )
	if not can_hit: return
	if is_hit: return
	is_hit = true
	
	# Increase attack range
	var new_range = gamestate.state.attack_reach + 0.05
	new_range = clamp( new_range, 0, 1.3 )
	gamestate.state.attack_reach = new_range
	
	if game.player != null:
		var x = preload( "res://enemies/explosion.tscn" ).instance()
		x.position = game.player.position + Vector2( 0, -8 )
		x.modulate = Color( 1,0.8,0.8,1 )
		get_parent().add_child( x )
	emit_signal( "heart_captured" )
	gamestate.state.energy = min( gamestate.state.energy + 1, \
		gamestate.state.max_energy )
	
	
	hide()
	$terminate_timer.start()
	$AudioStreamPlayer.play()
	

func _on_terminate_timer_timeout():
	queue_free()

func _on_rage_coin_body_entered(_body):
	if not can_move: return
	#print( "heart triggered by ", _body.name )
	#set_collision_mask_bit( 0, false )
	set_collision_mask_bit( 1, false )
	move_to_player = true
	#$tileset/particles.emitting = true
	$anim.stop(true)





