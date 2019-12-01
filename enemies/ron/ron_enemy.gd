tool
extends Enemy


export( bool ) var on_ceiling := false setget _set_on_ceiling

onready var fsm : FSM



var player_in_area := false

var anim_cur = ""
var anim_nxt = "run"

var dir_cur = 1
var dir_nxt = 1

var hit_dir : Vector2
var energy = 1

# warning-ignore:unused_class_variable
var vel = Vector2()

# warning-ignore:unused_class_variable
onready var initial_position = position

func _ready():
	if Engine.editor_hint:
		set_physics_process( false )
		return
	fsm = FSM.new( self, $states, $states/run, false )

func _exit_tree():
	if fsm != null:
		fsm.free()

func _set_on_ceiling( v ):
	on_ceiling = v
	if on_ceiling:
		$rotate.scale.y = -1
		$collision.position.y = 2
		target_offset.y = 4
	else:
		$rotate.scale.y = 1
		$collision.position.y = -2
		target_offset.y = -4

func _physics_process(delta) -> void:
	if fsm == null: return
	fsm.run_machine( delta )
	
	if anim_cur != anim_nxt:
		anim_cur = anim_nxt
		$anim.play( anim_cur )
	
	if dir_cur != dir_nxt:
		dir_cur = dir_nxt
		$rotate.scale.x = dir_cur
	
	if fsm.state_cur != fsm.states.shoot and \
		fsm.state_cur != fsm.states.hit and fsm.state_cur != fsm.states.dead and \
		player_in_area and _player_line_of_sight():
			fsm.state_nxt = fsm.states.shoot


func check_wall() -> bool:
	if not $rotate/ray_down.is_colliding() or \
		$rotate/ray_front.is_colliding():
			return true
	return false


func _on_detect_player_body_entered( _body ):
	player_in_area = true

func _on_detect_player_body_exited( _body ):
	player_in_area = false

func _player_line_of_sight() -> bool:
	var firepos : Vector2 = $rotate/firepos.global_position
	var playerpos : Vector2 = game.player.global_position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray( firepos, playerpos, [ self ], 1 )
	if result.empty():
		return true
	return false



func fire() -> void:
	# THIS IS THE WORST POSSIBLE WAY TO DO THIS!!!!
	var b
	if filename.find( "snow" ) != -1:
		b = preload( "res://enemies/ron/run_snow_bullet.tscn" ).instance()
	else:
		b = preload( "res://enemies/ron/run_bullet.tscn" ).instance()
	b.dir = float( dir_cur )
	b.diry = -$rotate.scale.y
	b.global_position = $rotate/firepos.global_position
	get_parent().add_child( b )



func _on_hitbox_area_entered( area ):
	if fsm.state_cur == fsm.states.hit or fsm.state_cur == fsm.states.dead: return
	$anim.stop()
	energy -= 1
	if energy > 0:
		fsm.state_nxt = fsm.states.hit
		hit_dir = global_position - area.global_position
	else:
		fsm.state_nxt = fsm.states.dead

#func hit( area, hit_energy : float = 1.0 ):
#	if fsm.state_cur == fsm.states.dead: return
#	$anim.stop()
#	energy -= hit_energy
#	if energy > 0:
#		fsm.state_nxt = fsm.states.hit
#		hit_dir = global_position - area.global_position
#	else:
#		fsm.state_nxt = fsm.states.dead
















