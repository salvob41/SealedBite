extends Node2D

var timer
var no_damage = false
func _ready():
	call_deferred( "set_impulses" )

func set_impulses():
	
	for c in get_children():
		
		if c is RigidBody2D:
			c.angular_damp = 0
			c.gravity_scale = 1
			var imp = c.position.normalized() * 50
			imp = imp.rotated( rand_range( -0.1, 0.1 ) )
			c.apply_central_impulse( imp )
			c.angular_velocity = 2
			if no_damage:
				c.get_node( "damage/damage_collision" ).call_deferred( "set_disabled", true )
	
	

	
	timer = Timer.new()
	timer.wait_time = 6
	timer.one_shot = true
	add_child( timer )
	timer.connect( "timeout", self, "_on_timeout" )
	timer.start()
	set_process( false )

func _on_timeout():
	queue_free()
