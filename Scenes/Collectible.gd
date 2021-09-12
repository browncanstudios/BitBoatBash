extends Area2D

var collectible_collected_sound = preload("res://Assets/Sfx/sfx-collectible-collect.wav")

func die():
	get_tree().queue_delete(self)

func _on_Collectible_body_entered(body):
	if body.is_in_group("Player"):
		if body.alive:
			body.increment_score(1)

			# the collectible will die after the collection sfx finishes playing
			$AudioStreamPlayer2D.stream = collectible_collected_sound
			$AudioStreamPlayer2D.play()
			visible = false

func _on_AudioStreamPlayer2D_finished():
	die()
