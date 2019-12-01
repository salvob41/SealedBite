extends SimpleMenu

func _ready() -> void:
	var _err = connect( "selected_item", self, "_on_selected_item" )


func _on_selected_item( itemno : int ) -> void:
	match itemno:
		0:
			pass
		1:
			pass
	pass