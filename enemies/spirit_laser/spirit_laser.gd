extends KinematicBody2D

enum STATES { IDLE, START_FIRE, FIRE, END_FIRE }
var state = STATES.IDLE
var vel = Vector2()
var timer = 0.5
var dir_nxt = 1
var dir_cur = 1
var soundstart = false

func _physics_process(delta):
	if dir_nxt != dir_cur:
		dir_cur = dir_nxt
		$rotate.scale.x = dir_cur
	
	match state:
		STATES.IDLE:
			vel *= 0.98
			vel = move_and_slide( vel )
			timer -= delta
			if timer <= 0:
				state = STATES.START_FIRE
				$anim.play( "start_fire" )
				timer = 1.02
		STATES.START_FIRE:
			timer -= delta
			if timer < 0.1 and not soundstart:
				$AudioStreamPlayer.play()
				soundstart = true
			if timer <= 0:
				state = STATES.FIRE
				$anim.play( "fire" )
				timer = 0.25
				game.camera_shake( timer, 60, 2 )
		STATES.FIRE:
			timer -= delta
			if timer <= 0:
				state = STATES.END_FIRE
				$anim.play("end_fire")
				timer = 10
		STATES.END_FIRE:
			pass
				