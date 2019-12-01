extends Node2D

var timer

func _ready():
	
	for c in get_children():
		if c is RigidBody2D:
			c.apply_impulse( \
				Vector2( rand_range( -2, 2 ), rand_range( -2, 2 ) ), \
				60 * Vector2( rand_range( -1, 1 ), rand_range( -1, 1 ) ) )
			c.add_torque( 10 )
			
	timer = Timer.new()
	timer.wait_time = 6
	timer.one_shot = true
	add_child( timer )
	timer.connect( "timeout", self, "_on_timeout" )
	timer.start()
	set_process( false )

func _on_timeout():
	queue_free()
