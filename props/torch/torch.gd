extends Node2D

func _ready():
	call_deferred( "set_animation_point" )

func set_animation_point():
	var delay = randf()*0.9
	$torch/torch_anim.seek( delay )
	$torch_light/light_anim.seek( delay )