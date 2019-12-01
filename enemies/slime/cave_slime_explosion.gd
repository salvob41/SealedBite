extends Area2D

func _activate_collision():
	call_deferred( "_turn_on_collision" )
func _turn_on_collision():
	$collision.disabled = false
func _deactivate_collision():
	call_deferred( "_turn_off_collision" )
func _turn_off_collision():
	$collision.disabled = true