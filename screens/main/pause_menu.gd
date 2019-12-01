extends SimpleMenu

signal pause_finished

func _ready():
	var _ret = connect( "selected_item", self, "_on_selected_item" )

func _input(event):
	if not is_active: return
	if event.is_action_pressed( "btn_quit" ) or \
		event.is_action_pressed( "btn_start" ):
			emit_signal( "pause_finished", true )

func _on_selected_item( opt ):
	match opt:
		0:
			emit_signal( "pause_finished", true )
		1:
			emit_signal( "pause_finished", false )
	