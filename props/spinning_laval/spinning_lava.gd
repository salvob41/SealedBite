extends Node2D

export( bool ) var spin_clockwise := true
export( float ) var spin_speed := 0.05
func _ready():
	$AnimationPlayer.playback_speed = spin_speed
	if not spin_clockwise:
		$AnimationPlayer.play_backwards("cycle")