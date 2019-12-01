extends FSM_State

var enemies : Array
var selected_enemy : WeakRef
var aiming_direction : Vector2

var clock
var clock_finished : bool

func _ready():
	call_deferred( "_set_clock" )
func _set_clock():
	clock = obj.get_node( "clock" )
	clock.connect( "clock_finished", self, "_on_clock_finished" )

func start_aim():
	if not gamestate.state.can_attack:
		return
	if fsm.state_cur == fsm.states.aim: return
	if obj.fsm.state_cur == obj.fsm.states.punch or \
		obj.fsm.state_nxt == obj.fsm.states.punch or \
		obj.fsm.state_cur == obj.fsm.states.cutscene or \
		obj.fsm.state_nxt == obj.fsm.states.cutscene:
			return
	
	# show range
	obj.get_node( "player_punch_mask/anim_punch_mask" ).play( "fade_in" )
	
	# slow down time
	Engine.time_scale = 0.1
	
	# start clock
	clock.start_clock()
	clock_finished = false
	
	# start aiming
	fsm.state_nxt = fsm.states.aim
	
	# slow down music
	game.slow_music( 1 )



#
#func initialize():
#	# update enemies
#	enemies = obj._enemy_in_sight()
#
#
#	# find enemy closest to aiming direction
#	if not enemies.empty():
#		selected_enemy = _get_enemy_closest_to_dir( aiming_direction )

func run( _delta ):
	# update enemies
	enemies = obj._enemy_in_sight()
	
	# update aiming direction
	var new_direction = _get_aiming_dir()
	
	
	
	# check if direction is the same and if the enemy is still around
	if new_direction.dot( aiming_direction ) < 0.9 or \
		selected_enemy == null or selected_enemy.get_ref() == null or \
		not find_in_weakarray( selected_enemy, enemies ):
			# search for enemies again
			aiming_direction = new_direction
			selected_enemy = _get_enemy_closest_to_dir( aiming_direction )
	
	#print( "aim: ", aiming_direction, " ", selected_enemy )
	if selected_enemy != null and selected_enemy.get_ref() != null:
		# update arrow indicating selected enemy
		_update_aiming_arrow( selected_enemy )
		pass
	else:
		# hide arrow
		obj.get_node( "target" ).hide()

	if clock_finished or obj.fsm.state_cur == obj.fsm.states.cutscene:
		fsm.state_nxt = fsm.states.aim_idle
	elif not Input.is_action_pressed( "btn_fire" ):
		fsm.state_nxt = fsm.states.aim_idle
		if selected_enemy != null and selected_enemy.get_ref() != null:
			obj.fsm.states.punch.start_punch( selected_enemy )

func terminate():
	game.camera.slowmo_target *= 0
	enemies = []
	selected_enemy = null
	obj.get_node( "target" ).hide()
	obj.get_node( "player_punch_mask/anim_punch_mask" ).stop()
	obj.get_node( "player_punch_mask/anim_punch_mask" ).play( "fade_out" )
	Engine.time_scale = 1.0
	clock.stop_clock()
	game.slow_music( 2 )





func _on_clock_finished():
	clock_finished = true




func _get_aiming_dir() -> Vector2:
	var dir = Vector2( \
		Input.get_action_strength( "btn_right" ) - Input.get_action_strength( "btn_left" ), \
		Input.get_action_strength( "btn_down" ) - Input.get_action_strength( "btn_up" ) )
	if dir.length() < 0.1:
		# player is not pressing direction keys
		dir = Vector2( obj.dir_cur, 0 )
	else:
		dir = dir.normalized()
	return dir

func _get_enemy_closest_to_dir( dir : Vector2 ) -> WeakRef:
	var closest_enemy : WeakRef
	var closest_dot = -10000
	for e in enemies:
		var distn = ( e.get_ref().global_position + e.get_ref().target_offset - obj.get_node( "punch_collision" ).global_position ).normalized()
		var curdot = distn.dot( dir )
		if curdot > closest_dot and curdot > 0.0:
			closest_dot = curdot
			closest_enemy = e
	return closest_enemy

func find_in_weakarray( r : WeakRef, arr : Array ) -> bool:
	if r == null or r.get_ref() == null: return false
	for a in arr:
		if a.get_ref() == null: continue
		if r.get_ref() == a.get_ref():
			return true
	return false

func _update_aiming_arrow( target : WeakRef ):
	var arrow = obj.get_node( "target" )
	var dist = target.get_ref().global_position + target.get_ref().target_offset - obj.get_node( "punch_collision" ).global_position
	arrow.show()
	arrow.position = obj.get_node( "punch_collision" ).position + dist * 0.5
	arrow.rotation = dist.angle()
	
	# update camera
	if game.camera != null:
		game.camera.slowmo_target = dist.normalized() * 16
	














