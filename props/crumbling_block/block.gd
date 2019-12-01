extends RigidBody2D


var timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	add_child( timer )
	timer.connect( "timeout", self, "_on_timeout" )
	timer.start()
	set_process( false )

func _on_timeout():
	set_process( true )
	#queue_free()


func _process( delta ):
	$sprite.modulate.a = lerp( $sprite.modulate.a, 0, 0.7 * delta )
	if $sprite.modulate.a < 0.05:
		set_process( false )
		queue_free()