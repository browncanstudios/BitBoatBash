extends RigidBody2D

var mine_explosion_sound = preload("res://Assets/Sfx/sfx-mine-explosion.wav")

var explosion_sound_finished = false
var explosion_animation_finished = false

func collided():
	# disable collisions so that while we are doing the explosion animation
	# and explosion sfx, we don't continue to act like a static body
	collision_layer = 0
	collision_mask = 0
	# we kill the mine object after its explosion sfx finishes
	# and after its explosion animation finishes
	$AudioStreamPlayer2D.stream = mine_explosion_sound
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.animation = "explosion"

func die():
	get_tree().queue_delete(self)

func _on_AudioStreamPlayer2D_finished():
	explosion_sound_finished = true
	if explosion_sound_finished and explosion_animation_finished:
		die()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		explosion_animation_finished = true
		visible = false
		if explosion_animation_finished and explosion_sound_finished:
			die()
