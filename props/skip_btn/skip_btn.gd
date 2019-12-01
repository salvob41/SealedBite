extends Node2D

signal skip

var is_pressing := false

func _ready():
	$clock/anim.playback_speed = 3
	var _ret = $clock.connect( "clock_finished", self, "_on_clock_finished" )

func _input(event):
	if event.is_action_pressed( "btn_fire" ):
		is_pressing = true
		$clock.show()
		$flash_label.hide()
		$clock.start_clock()
	elif event.is_action_released( "btn_fire" ):
		is_pressing = false
		$clock.hide()
		$flash_label.show()
		$clock.stop_clock()


func _on_clock_finished():
	if not is_pressing: return
	emit_signal( "skip" )