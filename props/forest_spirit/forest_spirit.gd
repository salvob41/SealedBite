extends Node2D

export( bool ) var wave := true setget _set_wave
export( bool ) var set_dark := false setget _set_dark

func _ready():
	if not wave: $wave_animation.stop()

func _set_wave( v ):
	wave = v
	if not Engine.editor_hint and $wave_animation:
		if wave:
			$wave_animation.play("cycle")
		else:
			$wave_animation.stop()

func _set_dark( v ):
	set_dark = v
	if not Engine.editor_hint and $wave_animation:
		if set_dark:
			$spirit_particles.emitting = false
			$dark_particles.emitting = true
		else:
			$spirit_particles.emitting = true
			$dark_particles.emitting = false