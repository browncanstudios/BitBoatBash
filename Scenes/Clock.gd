extends Area2D

signal collected

func die():
	get_tree().queue_delete(self)

func _on_AnimatedSprite_animation_finished():
	die()

func _on_Clock_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("collected")
		die()

func _on_Timer_timeout():
	$AnimatedSprite.playing = true
