extends KinematicBody2D
class_name Enemy

# warning-ignore:unused_class_variable
var target_offset = Vector2( 0, -6 )

func _ready():
	call_deferred( "_connect_to_target_area" )


func _connect_to_target_area():
	var a = find_node( "target_area" )
	if a == null: return
	
func _highlight_target():
	pass

func _clear_target():
	pass

