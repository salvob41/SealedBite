extends RigidBody2D


var timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	add_child( timer )
	timer.connect( "timeout", self, "_on_timeout", [], Object.CONNECT_DEFERRED )
	timer.start()
	set_process( false )
	
	contact_monitor = true
	contacts_reported = 1
	var _ret = connect( "body_entered", self, "_on_body_entered", [], Object.CONNECT_DEFERRED )

func _on_timeout():
	_stop_damage()
	set_process( true )
	#queue_free()


func _process( delta ):
	$sprite.modulate.a = lerp( $sprite.modulate.a, 0, 0.7 * delta )
	if $sprite.modulate.a < 0.05:
		set_process( false )
		queue_free()

func _on_body_entered( _body ):
	timer.stop()
	_stop_damage()
	set_process( true )

var is_stopped = false
func _stop_damage():
	if is_stopped: return
	is_stopped = true
	$damage/damage_collision.disabled = true