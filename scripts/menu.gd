extends Node2D
class_name SimpleMenu

signal selected_item( item_no )



export var is_active = false
export var SELECTED_ITEM_OPACITY = 1.0
export var UNSELECTED_ITEM_OPACITY = 0.3
export var UNSELECTABLE_ITEM_OPACITY = 0.1

var items = []
var cur_item = 0





func _ready():
	if not is_active:
		set_process_input( false )
	update_menu()
func update_menu():
	items = []
	for c in get_children():
		if c is SimpleMenuItem:
			if c.selectable:
				items.append( c )
				c.modulate.a = UNSELECTED_ITEM_OPACITY
			else:
				c.modulate.a = UNSELECTABLE_ITEM_OPACITY
	items[cur_item].modulate.a = SELECTED_ITEM_OPACITY

func activate():
	is_active = true
	set_process_input( true )
	cur_item = 0
	set_item()

func deactivate():
	is_active = false
	set_process_input( false )

func _input( evt ):
	if evt.is_action_pressed( "btn_down" )or \
			evt.is_action_pressed( "btn_right" ):
		cur_item += 1
		if cur_item >= items.size(): cur_item -= items.size()
		set_item()
	if evt.is_action_pressed( "btn_up" ) or \
			evt.is_action_pressed( "btn_left" ):
		cur_item -= 1
		if cur_item < 0: cur_item += items.size()
		set_item()
	if evt.is_action_pressed( "btn_jump" ) or evt.is_action_pressed( "btn_fire" ):
		emit_signal( "selected_item", cur_item )

func set_item():
	for idx in range( items.size() ):
		if cur_item == idx:
			items[idx].modulate.a = SELECTED_ITEM_OPACITY
		else:
			items[idx].modulate.a = UNSELECTED_ITEM_OPACITY



#func _ready():
#	items = get_children()
#	for idx in range( 1, items.size() ):
#		items[idx].modulate.a = UNSELECTED_ITEM_OPACITY
#	max_pos = items.size() - 1
#
#func set_active( v ):
#	if v: set_physics_process( true )
#	else: set_physics_process( false )
#
#func set_unselectable_item( no ):
#	items[no].modulate.a = UNSELECTABLE_ITEM_OPACITY
#	unselectable_items.append( no )
#
#func _physics_process(delta):
#	if Input.is_action_just_pressed( "btn_fire" ) or \
#			Input.is_action_just_pressed( "btn_start" ) or\
#			Input.is_action_just_pressed( "btn_jump" ):
#		#SoundManager.Play("inter_confirm")
#		emit_signal( "selected_item", cur_pos )
#		set_physics_process( false )
#		return
#	if Input.is_action_just_pressed( "btn_down" ) or Input.is_action_just_pressed( "btn_select" ):
#		if unselectable_items.find( nxt_pos + 1 ) != -1:
#			if nxt_pos + 2 <= max_pos:
#				nxt_pos += 2
#		else:
#			nxt_pos += 1
#	elif Input.is_action_just_pressed( "btn_up" ):
#		if unselectable_items.find( nxt_pos - 1 ) != -1:
#			if nxt_pos - 2 >= 0:
#				nxt_pos -= 2
#		else:
#			nxt_pos -= 1
#
#	if nxt_pos < 0: nxt_pos = 0
#	elif nxt_pos > max_pos: nxt_pos = max_pos
#
#	if nxt_pos != cur_pos:
#		cur_pos = nxt_pos
#	_update_pos( cur_pos )
#
#func _update_pos( pos ):
#	for idx in range( items.size() ):
#		if idx == pos:
#			items[idx].modulate.a = 1#set_opacity( 1 )
#		else:
#			if unselectable_items.find( idx ) == -1:
#				items[idx].modulate.a = 0.3#set_opacity( 0.3 )
#			else:
#				items[idx].modulate.a = 0.1#set_opacity( 0.1 )

