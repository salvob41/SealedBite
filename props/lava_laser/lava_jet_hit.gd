extends Sprite

func _ready():
	$hit_anim.play("cycle")
	$hit_anim.seek( randf() * 0.7, true )