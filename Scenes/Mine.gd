extends RigidBody2D

var mine_explosion_sound = preload("res://Assets/Sfx/sfx-mine-explosion.wav")

func die():
	get_tree().queue_delete(self)

func _on_AudioStreamPlayer2D_finished():
	die()

func collided():
	$AudioStreamPlayer2D.stream = mine_explosion_sound
	$AudioStreamPlayer2D.play()
	# we kill the mine object after its explosion sfx finishes
	# but until then we still want the mine sprite to vanish
	# (and actually, we really want an explosion animation)
	visible = false
