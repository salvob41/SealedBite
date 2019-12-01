extends KinematicBody2D

# warning-ignore:unused_signal
signal player_dead

const GRAVITY = 600#500
const COYOTE_TIME = 0.1
const JUMP_AGAIN_MARGIN = 0.2
const TERM_VEL = 160
const SNAP_LEN = 8

const JUMP_VEL = -150.0
const MAX_VEL = 70
const AIR_ACCEL = 10

const REF_ATTACK_RANGE = 72.0


onready var fsm = FSM.new( self, $states, $states/idle, false )
onready var aimfsm = FSM.new( self, $aimstates, $aimstates/aim_idle, false )
var anim_cur = ""
var anim_nxt = "idle"

# warning-ignore:unused_class_variable
onready var anim_fx = $anim_fx
var dir_cur = 1
var dir_nxt = 1

# warning-ignore:unused_class_variable
var vel = Vector2()

var is_invulnerable := false
var invulnerable_timer := 0.0
var cur_target = null


func _ready():
#	cur_params = parameters[gamestate.state.current_player_status]
	game.player = self
	var _ret = gamestate.connect( "gamestate_changed", self, "set_attack_reach", [], Object.CONNECT_DEFERRED )
	call_deferred( "set_attack_reach" )
	
	

func _exit_tree():
	fsm.free()
	aimfsm.free()


func set_attack_reach():
	$player_punch_mask.scale = Vector2( 1, 1 ) * gamestate.state.attack_reach
	$find_enemies/find_enemies_collision.shape.radius = \
		round( gamestate.state.attack_reach * REF_ATTACK_RANGE )
	#print( "ATTACK RADIUS: ", $find_enemies/find_enemies_collision.shape.radius )


func _physics_process(delta):
	fsm.run_machine( delta )
	aimfsm.run_machine( delta )
	
	if anim_cur != anim_nxt:
		anim_cur = anim_nxt
		$anim.play( anim_cur )
	
	if dir_cur != dir_nxt:
		dir_cur = dir_nxt
		$rotate.scale.x = dir_cur
	
	var punch_dir = Vector2( \
		Input.get_action_strength( "btn_right" ) - Input.get_action_strength( "btn_left" ), \
		Input.get_action_strength( "btn_down" )- Input.get_action_strength( "btn_up" ) )
	if punch_dir.length() < 0.1:
		punch_dir = Vector2( dir_cur, 0 )
	$find_enemies.rotation = punch_dir.angle()
	
	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false







func start_jump() -> void:
	#print( "Starting jump" )
	vel.y = JUMP_VEL
	vel += get_floor_velocity()# * 2
	#print( "FLOOR VEL: ",  get_floor_velocity() )
	vel = move_and_slide( vel, Vector2.UP )
	$jump.play()

func can_wall_jump() -> bool:
	if not gamestate.state.can_wall_jump:
		return false
#	if( OS.get_ticks_msec() - last_grab ) < 300 or \
#		not obj.get_node( "rotate/check_wall" ).is_colliding():
#		return false
	if not $rotate/check_wall.is_colliding():
		return false
	if not $rotate/check_wall2.is_colliding():
		return false
	return true


func can_be_hit( area = null ) -> bool:
	if fsm.state_cur == fsm.states.hit: return false
	if fsm.state_cur == fsm.states.dead: return false
	if is_invulnerable: return false
	#print( cur_target, " ", area, " ", cur_target.get_ref().name, " ", area.get_parent(), " ", area.owner.name )
	if cur_target != null and \
		area != null and \
		cur_target.get_ref() != null and \
		cur_target.get_ref() == area.owner:
			return false
	return true

func _on_hitbox_area_entered( area ):
	#print( "PLAYER HIT AREA ENTERED" )
	if not can_be_hit( area ): return
	
	var hit_dir = global_position - area.global_position
	print( "PLAYER HIT from ", hit_dir )
	gamestate.state.energy -= 1
	if gamestate.state.energy == 0:
		game.camera_shake( 0.15, 60, 6, hit_dir.normalized() )
		fsm.state_nxt = fsm.states.dead
	else:
		vel = hit_dir.normalized() * 100
		vel = move_and_slide( vel )
		fsm.state_nxt = fsm.states.hit
		game.camera_shake( 0.15, 60, 4, hit_dir.normalized() )

func _on_force_jump_area_entered( _area ):
	if fsm.state_cur == fsm.states.hit or fsm.state_cur == fsm.states.dead or \
		fsm.state_cur == fsm.states.punch: return
	if vel.y <= 0: return
	start_jump()
	vel.y *= 1.2
	fsm.state_nxt = fsm.states.jump
#	var ap = area.get_parent()
#	if ap.has_method( "force_jump" ):
#		ap.force_jump()
	


func _enemy_in_sight() -> Array:
	var enemies = $find_enemies.get_overlapping_bodies()
	#print( "Overlapping: ", enemies )
	if enemies.empty(): return []
	enemies.sort_custom( self, "_closest" )
	var visible_enemies = []
	var space_state = get_world_2d().direct_space_state
	for e in enemies:
		if not e is Enemy: continue
		var result = space_state.intersect_ray( \
			$punch_collision.global_position, \
			e.global_position + e.target_offset, [], 1 )
		if result.empty():
			visible_enemies.append( weakref( e ) )
		else:
			var collider = result.collider
			if e.global_position.y < global_position.y and collider is TileMap:
				var tile = collider.get_cellv( \
					collider.world_to_map( result.position ) )
				if tile != -1 and collider.tile_set.tile_get_shape_one_way( tile, 0 ):
					visible_enemies.append( weakref( e ) )
	return visible_enemies

func _closest( a, b ) -> bool:
	var da = a.global_position - global_position
	var db = b.global_position - global_position
	if da.length_squared() < db.length_squared():
		return true
	return false

func _on_death_areas_area_entered(_area):
#	print( "PLAYER KILLED BY ", _area.name, " ", _area.get_parent().name )
	fsm.state_nxt = fsm.states.dead


func is_push_block() -> bool:
	if not gamestate.state.can_push: return false
	if $rotate/check_pushblock.is_colliding(): return true
	return false


func set_cutscene( cutscene_on = true, has_gravity = true, has_animation = true ):
	if cutscene_on:
		fsm.states.cutscene.has_gravity = has_gravity
		fsm.states.cutscene.has_animation = has_animation
		fsm.state_nxt = fsm.states.cutscene
		aimfsm.state_nxt = aimfsm.states.aim_idle
	else:
		fsm.state_nxt = fsm.state_lst
	


#-----------------------------
# dust effects
#-----------------------------
func run_dust() -> void:
	var d = preload( "res://player/dust_particles/run_dust.tscn" ).instance()
	d.scale.x = dir_cur
	d.position = position + Vector2( 0, 0 )
	get_parent().add_child( d )





func random_pitch_step():
	$step.pitch_scale = 1.0 + 0.2 * rand_range( -1, 1 )
	$step.play()





