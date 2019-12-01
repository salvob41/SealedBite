extends Sprite

signal clock_finished

var ang := 0.0
var backang := 0.0

export( float ) var speed := 1.0
#export( String ) var action_name := "btn_fire"
export( bool ) var back_clock := true
export( float ) var back_clock_speed := 0.25

var is_ticked := false
func _ready():
	material.set_shader_param( "max_angle", ang )
	if back_clock:
		$back_clock.material.set_shader_param( "max_angle", backang )
	else:
		$back_clock.queue_free()

func _physics_process(delta):
	if is_ticked: return
	if Input.is_action_pressed( "btn_fire" ) or \
		Input.is_action_pressed( "btn_jump" ):
		if ang < 1.0:
			ang += speed * delta
	else:
		if ang > 0.0:
			ang -= 2 * speed * delta
	material.set_shader_param( "max_angle", ang )
	
	if ang >= 1:
		is_ticked = true
		emit_signal( "clock_finished" )
		return
	
	if back_clock:
		backang += back_clock_speed * delta
		$back_clock.material.set_shader_param( "max_angle", backang )
		if backang >= 1:
			is_ticked = true
			emit_signal( "clock_finished" )