extends Sprite

signal clock_finished

func _ready():
	var _ret = $anim.connect("animation_finished",self,"_on_animation_finished" )

func _on_animation_finished( _anim_name ):
	#print( "CLOCK FINISHED" )
	emit_signal( "clock_finished" )
	
func start_clock():
	$anim.play("cycle")

func stop_clock():
	$anim.play( "default" )
