extends Area2D

var velocity = Vector2.ZERO
var destination = null

func _ready():
	$AnimatedSprite.animation = "portal"

func die():
	get_tree().queue_delete(self)
	
func _physics_process(delta):
	position.x += velocity.x * delta
	position.y += velocity.y * delta

	if destination and velocity.y > 0.0:
		if position.y > destination:
			stop_falling()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "splashing":
		$AnimatedSprite.animation = "drowning"
	if $AnimatedSprite.animation == "portal":
		$AnimatedSprite.animation = "falling"
		velocity.y = 400.0
		velocity.x = 0.0

func stop_falling():
	velocity.y = 0.0
	$AnimatedSprite.animation = "splashing"

func _on_Bear_body_entered(body):
	if body.is_in_group("Mine"):
		body.collided()
		stop_falling()
		position.y += 24
	if body.is_in_group("Player"):
		body.sink()
		stop_falling()
		position.y += 24
