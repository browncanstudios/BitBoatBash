extends Area2D

var coffee_collected_sound = preload("res://Assets/Sfx/sfx-collectible-collect.wav")

func die():
	get_tree().queue_delete(self)

func _on_Coffee_body_entered(body):
	if body.is_in_group("Player"):
		if body.alive:
			body.become_invincible()

			# the coffee will die after the coffee sfx finishes playing
			$AudioStreamPlayer2D.stream = coffee_collected_sound
			$AudioStreamPlayer2D.play()
			visible = false

func _on_AudioStreamPlayer2D_finished():
	die()
