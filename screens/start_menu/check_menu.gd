extends SimpleMenu


func _ready():
	var _ret = connect( "selected_item", self, "_on_selected_item" )

func _input(event):
	if event.is_action_pressed( "btn_quit" ):
		emit_signal( "selected_item", 0 )
		queue_free()

func _on_selected_item( _item ):
	queue_free()