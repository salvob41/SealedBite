extends Area2D


signal rage_coin_captured

var MAX_VEL = 0
var vel := Vector2()
var move_to_player := false
var start_timer = 0.5
var can_move := false
var can_hit := false

onready var event_name = owner.filename + get_path()

func _ready():
	if gamestate.is_event( event_name ): queue_free()

func _physics_process(delta):
	if start_timer > 0:
		start_timer -= delta
		if start_timer < 0:
			can_move = true
			can_hit = true
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
		x.modulate = Color( 1,0,0,1 )
		get_parent().add_child( x )
	emit_signal( "rage_coin_captured" )
	gamestate.add_event( event_name )
	
	hide()
	$terminate_timer.start()
	$AudioStreamPlayer.play()
	

func _on_terminate_timer_timeout():
	queue_free()



func _on_rage_coin_body_entered(_body):
	if not can_move: return
	#print( "triggered by ", _body.name )
	set_collision_mask_bit( 0, false )
	move_to_player = true
	$tileset/particles.emitting = true
	$anim.stop(true)
