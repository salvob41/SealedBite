extends Node

const GAMESTATE_FILE = "gamedata.dat"

var player = null setget _set_player, _get_player
var camera = null setget _set_camera, _get_camera
var nav = null setget _set_nav, _get_nav

# warning-ignore:unused_class_variable
var main = null

# warning-ignore:unused_class_variable
var debug = false

#--------------------------------------
func _set_player( v ):
	player = weakref( v )
func _get_player():
	if player == null: return null
	return player.get_ref()
#--------------------------------------
func _set_camera( v ):
	camera = weakref( v )
func _get_camera():
	if camera == null: return null
	return camera.get_ref()
#--------------------------------------
func _set_nav( v ):
	nav = weakref( v )
func _get_nav():
	if nav == null: return null
	return nav.get_ref()
#--------------------------------------

func _ready():
	self.pause_mode = PAUSE_MODE_PROCESS


#--------------------------------------
# camera control
#--------------------------------------
func camera_shake( duration : float, frequency : float, amplitude : float, direction : Vector2 = Vector2( 1, 1 ) ):
	if camera == null or camera.get_ref() == null:
		return
	camera.get_ref().shake( duration, frequency, amplitude, direction )



var is_fullscreen := false
var window_size : Vector2
var window_pos : Vector2
func _input(_event):
	if Input.is_action_just_pressed( "btn_fullscreen" ):
		if not is_fullscreen:
			OS.set_borderless_window(true)
			window_size = OS.window_size
			OS.window_size = OS.get_screen_size()
			window_pos = OS.window_position
			OS.window_position = Vector2.ZERO
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			is_fullscreen = true
		else:
			OS.set_borderless_window(false)
			OS.window_size = window_size
			OS.window_position = window_pos
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_fullscreen = false



func am_i_visible( obj, offset = Vector2.ZERO ) -> bool:
	if camera == null or camera.get_ref() == null: return false
	if game.player == null: return true
#	var is_on_camera = obj.get_viewport_rect().has_point( obj.get_global_transform_with_canvas().origin + offset )
	var distance_from_player = ( ( obj.global_position + offset ) - game.player.global_position ).length()
	return distance_from_player < 100
#	return is_on_camera






func show_message( msg, target_obj, offset, duration, user_input, pause_game = false ):
	if main == null: return
	var pos = target_obj.get_global_transform_with_canvas().origin + offset + Vector2( 0, -24 )
	var color = Color( 1, 0.6, 0.2 )
	color = Color( 1, 1, 1 )
	if target_obj == game.player: color = Color( 1, 1, 1 )
	var outobj = main.get_node( "text_layer/text_container" ).show_message( \
		msg, pos, duration, user_input, color )
	if pause_game:
		get_tree().paused = true
		yield( outobj, "message_finished" )
		get_tree().paused = false
	return outobj




func set_music( no : int, fade_out : float = 0.5, fade_in : float = 0.5, match_position : bool = false ):
	if game.main == null: return
	game.main.set_music( no, fade_out, fade_in, match_position )
	
func slow_music( n : int ):
	if game.main == null: return
	game.main.slow_music( n )
	





# Make life a little easier for the player
func heart_drop_rate():
	if gamestate.state.energy <= 1:
		return 0.7
	elif gamestate.state.energy <= 2:
		return 0.3
	else:
		return 0.0
	





