extends Enemy

signal boss_hit

enum STATES { IDLE, HIT, SPIKES, NEW_SPIKES, DEAD }
var state = STATES.IDLE
var anim_cur = ""
var anim_nxt = ""
var timer := 0.1
var damage_area

func _ready():
	damage_area = preload( "res://enemies/spirit_boss/spirit_boss_damage.tscn" ).instance()
	add_child( damage_area )


func _shoot( _dir = -1 ):
	var b = preload("res://enemies/spirit_laser/spirit_laser.tscn").instance()
	b.position = position + Vector2( 0, 8 )
	var offset = game.player.global_position.x - global_position.x
	if offset >= 0:
		_dir = 1
	else:
		_dir = -1
	b.dir_nxt = _dir
	b.vel = Vector2( _dir * 20, 10 )
	get_parent().add_child( b )

func _on_hitbox_area_entered(_area):
	if state != STATES.IDLE or $face/spikes.visible:
		return
	emit_signal( "boss_hit" )
	$collision.disabled = true
	state = STATES.HIT
	timer = 0.5
	anim_nxt = "hit"

func explode_spikes():
	$collision.call_deferred( "set_disabled", true )
	state = STATES.SPIKES
	anim_nxt = "explode_spikes"
	timer = 2
func _explode_spikes( damage = true):
	var x = preload( "res://enemies/spirit_boss/breaking_spikes.tscn" ).instance()
	x.position = position
	if not damage:
		x.no_damage = true
	get_parent().add_child( x )

func rebuild_spikes():
	$collision.call_deferred( "set_disabled", true )
	state = STATES.NEW_SPIKES
	anim_nxt = "start_spikes"
	timer = 1.5

func dead():
	$collision.call_deferred( "set_disabled", true )
	damage_area.get_node( "collision" ).call_deferred( "set_disabled", true )
	$anim.stop()
	$face.hide()
	$Particles2D2.emitting = true

func _physics_process(delta):
	match state:
		STATES.IDLE:
			anim_nxt = "idle"
		STATES.HIT:
			timer -= delta
			if timer <= 0:
				state = STATES.IDLE
				$collision.call_deferred( "set_disabled", false )
		STATES.SPIKES:
			timer -= delta
			if timer <= 0:
				state = STATES.IDLE
				$collision.call_deferred( "set_disabled", false )
				damage_area.get_node( "collision" ).call_deferred( "set_disabled", true )
		STATES.NEW_SPIKES:
			timer -= delta
			if timer <= 0:
				state = STATES.IDLE
				$collision.call_deferred( "set_disabled", true )
				damage_area.get_node( "collision" ).call_deferred( "set_disabled", false )
	

	if anim_nxt != anim_cur:
		anim_cur = anim_nxt
		$anim.play( anim_cur )