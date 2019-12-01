extends Area2D

const ACCEL = 3
var max_vel := 50.0
var dir : float = 1
var diry : float = -1
onready var vel := Vector2( 0, diry * max_vel )
var timer = 0.0

func _ready() -> void:
	#max_vel +=  rand_range( -20, 20 )
	if game.player != null:
		var dist_to_player = game.player.global_position - global_position
		if dist_to_player.x > 0:
			dir = 1
		else:
			dir = -1

func _physics_process( delta ) -> void:
	position += vel * delta
	
	timer -= delta
	if timer < 0:
		vel = vel.normalized().linear_interpolate( Vector2( dir, 0 ), ACCEL * delta ) * max_vel
		max_vel = lerp( max_vel, 0, 0.6 * delta )
	
	
func _on_run_bullet_body_entered(body):
	#print( "BULLET BODY ENTERED: ", body.name )
	if body.has_method( "damage" ):
		body.damage( self )
	yield( get_tree().create_timer(0.1), "timeout" )
	terminate()

func _on_run_bullet_area_entered(_area):
	#print( "BULLET AREA ENTERED: ", area.name )
	terminate()
	#_on_run_bullet_body_entered( area.get_parent() )

func _on_lifetime_timeout():
	terminate()

func terminate():
	var x = preload( "res://enemies/explosion.tscn" ).instance()
	x.position = position
	x.modulate = Color( "e4d2aa" )
	# AGAIN: STUPID WAY TO SOLVE THIS!!!
	if filename.find( "snow" ) != -1:
		x.modulate = Color( "e3e6ff" )
	get_parent().add_child( x )
	queue_free()










