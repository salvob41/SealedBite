extends Node2D

func _ready():
	for c in $balls.get_children():
		if c is Sprite:
			c.get_node( "anim" ).playback_speed = rand_range( 0.8, 1.2 )