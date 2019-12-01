extends Label

signal message_finished

#var timer
var timer_running = false
var msg = ""
var screen_pos = Vector2()
var duration = 2
#var user_input = true
var color = Color( 1, 1, 1 )
#var end_timer

func _ready():
	self.modulate = color
	text = msg
	var half_size = Vector2( msg.length() * 2, 0 )
	
	#print( msg.length(), ":", screen_pos.x, " ", ( screen_pos.x - half_size.x ) )
	if screen_pos.x < 0: screen_pos.x = 0
	if screen_pos.x > 240: screen_pos.x = 240
	if screen_pos.y < 0: screen_pos.y = 0
	if screen_pos.y > 135: screen_pos.y = 135
	if ( screen_pos.x + half_size.x  ) > 230:
		screen_pos.x -= ( screen_pos.x + half_size.x - 230 )
	if ( screen_pos.x - half_size.x ) < 10:
		screen_pos.x -= ( screen_pos.x - half_size.x - 10 )
		
	
	var text_pos = screen_pos.round() - half_size
	$small_clock.position.x = round( 2.0 * half_size.x )
	
	self.rect_position = text_pos
	if duration > 0:
#		timer = Timer.new()
#		timer.autostart = true
#		timer.one_shot = true
#		timer.connect( "timeout", self, "_on_timeout" )
#		timer.wait_time = duration
#		add_child( timer )
#		timer.start()
		$small_clock.back_clock_speed = 1.0 / duration
		var _ret = $small_clock.connect( "clock_finished", self, "_on_timeout" )
		timer_running = true
	else:
		$small_clock.queue_free()
	
		
#	if user_input:
#		set_process_input( true )
#		end_timer = Timer.new()
#		end_timer.autostart = false
#		end_timer.one_shot = true
#		end_timer.connect( "timeout", self, "_on_end_timer" )
#		end_timer.wait_time = 0.25
#		add_child( end_timer )
#	else:
#		set_process_input( false )
	set_process_input( false )

func hide_message():
	var tw = Tween.new()
	tw.interpolate_property( self, "modulate", Color(1,1,1,1), Color(1,1,1,0),0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0 )
	add_child( tw )
	tw.connect( "tween_completed", self, "_on_end_timer" )
	tw.start()
	
	timer_running = false
#	timer.stop()
#	set_process_input( false )
#	text = ""
#	_on_end_timer()
#	end_timer.start()

func _on_end_timer( _a, _b ):
	emit_signal( "message_finished" )
	queue_free()
	
	
func _on_timeout():
	if not timer_running: return
	hide_message()

func _input(event):
	if event.is_action_pressed( "btn_fire" ) or \
		event.is_action_pressed( "btn_jump" ):
			hide_message()
			