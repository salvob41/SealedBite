extends Container


var label_scn = preload( "res://hud/screen_text/screen_text.tscn" )
func show_message( msg, pos, duration, _user_input, color ):
	var a = label_scn.instance()
	a.msg = msg
	a.screen_pos = pos.round()
	a.duration = duration
#	a.user_input = user_input
	a.color = color
	add_child(a)
	return a
	