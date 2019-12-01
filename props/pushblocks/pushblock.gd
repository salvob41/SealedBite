extends KinematicBody2D

var vel = Vector2()
#var old_ret_len : float

#func _ready():
#	position = position.round()

func _physics_process(delta):
	if not $RayCast2D.is_colliding():
		vel.y = min( vel.y + 400 * delta, 160 )
		var _ret = move_and_slide( vel, Vector2.UP )
	else:
		vel.y = 0
#	vel.y = min( vel.y + 400 * delta, 160 )
#	var _ret = move_and_slide( vel, Vector2.UP )
	
#	var ret_len = abs( _ret.x )#.length()
#	if ret_len < 1.0 and old_ret_len > 1.0:
#		position = position.round()
		#print("X")
#	old_ret_len = ret_len

func _on_check_player_body_exited(_body):
#	position = position.round()
	#print("Y")
	pass
