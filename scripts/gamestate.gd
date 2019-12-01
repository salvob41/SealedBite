extends Node

signal gamestate_changed

var _fname := "gamestate.dat"
var state := {} setget _set_state
var saved_state := {} # backup if unable to save
var first_start := true


func _ready():
	initiate()
	
	
func set_state( k, v, save_file := false ) -> bool:
	self.state[k] = v
	if save_file:
		return _save_gamestate()
	return true

func _set_state( v ):
	state = v
	emit_signal( "gamestate_changed" )

# Define initial game state
func initiate():
	state = _get_initial_gamestate()
	if game.debug:
		state.active_checkpoint = [ \
			state.current_pos, state.current_lvl ]
		pass
	saved_state = state.duplicate( true )
	
	

func _get_initial_gamestate():
	if game.debug:
			return debug_gamestate
	return { \
		"events" : [], \
		"active_checkpoint": [ "", "" ], \
		"visited_stages" : [], \
		"current_lvl" : "", \
		"current_pos" : "", \
		"current_dir" : 1, \
		"can_double_jump" : false, \
		"can_wall_jump" : false, \
		"can_attack" : false, \
		"can_push" : false, \
		"green_chrystal" : false, \
		"white_chrystal" : false, \
		"red_chrystal" : false, \
		"attack_reach" : 0.7, \
		"energy" : 3, \
		"max_energy" : 3 }

# save game state to file
func save_gamestate() -> bool:
	return _save_gamestate()
func _save_gamestate() -> bool:
	print( "SAVING GAMESTATE:" )
	saved_state = state.duplicate( true )
#	return false
	var f := File.new()
	var err := f.open_encrypted_with_pass( \
			_fname, File.WRITE, OS.get_unique_id() )
	if err == OK:
		f.store_var( state )
		f.close()
		return true
	else:
		f.close()
		return false


# load game state from file
func load_gamestate() -> bool:
	var aux = _load_gamestate()
	if aux.empty():
		if game.debug: print( "gamestate: unable to load gamestate file" )
		if not saved_state.empty():
			if game.debug: print( "gamestate: using locally saved variable" )
			state = saved_state.duplicate( true )
		else:
			if game.debug: print( "gamestate: using initial gamestate" )
			state = _get_initial_gamestate()
			saved_state = state.duplicate( true )
		return false
	state = aux
	saved_state = state.duplicate( true )
	first_start = false
	return true

func _load_gamestate() -> Dictionary:
	var f := File.new()
	if not f.file_exists( _fname ):
		return {}
	var err = f.open_encrypted_with_pass( \
			_fname, File.READ, OS.get_unique_id() )
	if err != OK:
		f.close()
		return {}
	var data = f.get_var()
	f.close()
	return data

func check_gamestate_file() -> bool:
	var tempstate = _load_gamestate()
	if tempstate.empty(): return false
	return true


#===========================
# events
#===========================
func is_event( evtname ):
	if state[ "events" ].find( evtname ) == -1:
		return false
	return true
func add_event( evtname ):
	if state[ "events" ].find( evtname ) == -1:
		state[ "events" ].append( evtname )
		return true
	return false




var debug_gamestate = { \
	"datetime" : 0, \
	"events" : [], \
#		"events" : [ "first dialog with wolf", "bitten" ], \
#	"events" : [ "first dialog with wolf", "bitten" ,"black chrystal"], \
#	"events" : ["green chrystal"], \
#		"events" : ["green chrystal","white chrystal"], \
#		"events" : ["green chrystal","white chrystal","red chrystal"], \
	"destructibles" : [], \
	"dead_robots": [], \
	"active_checkpoint": [ "", "" ], \
	"switches" : [], \
	"visited_stages" : [], \
#	"current_lvl" : "", \
	"current_lvl" : "res://zones/mountain/stage_05.tscn", \
#	"current_lvl" : "res://zones/forest/stage_01.tscn", \
#	"current_lvl" : "res://zones/cave/stage_04.tscn", \
#		"current_pos" : "finish_position", \
#		"current_pos" : "cutscene_position", \
	"current_pos" : "", \
	"current_dir" : 1, \
	"current_player_status" : "start", \
	"can_double_jump" : true, \
	"can_wall_jump" : true, \
	"can_attack" : true, \
	"can_push" : true, \
	"green_chrystal" : false, \
	"white_chrystal" : false, \
	"red_chrystal" : false, \
	"attack_reach" : 0.7, \
	"energy" : 3, \
	"max_energy" : 3 }


