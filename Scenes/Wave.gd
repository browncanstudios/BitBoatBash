extends AnimatedSprite

func die():
	get_tree().queue_delete(self)

func _on_Timer_timeout():
	die()
