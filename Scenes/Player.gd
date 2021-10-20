extends KinematicBody2D

signal score_changed

export var speed = 300

var velocity = Vector2(speed, 0.0)
var score = 0
var alive = true
var invincible = false

# TODO: figure out how to do this, maybe with 3 AudioStreamPlayer2D objects?
var engine_cruise_sound = preload("res://Assets/Sfx/sfx-engine-cruise.wav")
var engine_slow_sound = preload("res://Assets/Sfx/sfx-engine-slow.wav")
var engine_fast_sound = preload("res://Assets/Sfx/sfx-engine-fast.wav")

func increment_score(amount):
	if !alive:
		return

	score += amount
	emit_signal("score_changed")

func _physics_process(_delta):
	if !alive:
		return

	# vertical movement (using analog joystick or buttons)
	var left_vertical_analog_value = Input.get_joy_axis(0, JOY_AXIS_1)
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or Input.is_action_pressed("ui_up"):
		velocity.y = -speed
	elif Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN) or Input.is_action_pressed("ui_down"):
		velocity.y = speed
	elif abs(left_vertical_analog_value) > 0.1:
		velocity.y = left_vertical_analog_value * speed
	else:
		velocity.y = 0

	# horizontal movement (using analog joystick or buttons)
	var left_horizontal_analog_value = Input.get_joy_axis(0, JOY_AXIS_0)
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) or Input.is_action_pressed("ui_left"):
		velocity.x = 0.5 * speed
		$AnimatedSprite.set_speed_scale(0.5)
	elif Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT) or Input.is_action_pressed("ui_right"):
		velocity.x = 2.0 * speed
		$AnimatedSprite.set_speed_scale(2.0)
	elif left_horizontal_analog_value > 0.1:
		velocity.x = speed + left_horizontal_analog_value * speed
		$AnimatedSprite.set_speed_scale(2.0)
	elif left_horizontal_analog_value < -0.1:
		velocity.x = speed + left_horizontal_analog_value * speed * 0.5
		$AnimatedSprite.set_speed_scale(0.5)
	else:
		velocity.x = speed
		$AnimatedSprite.set_speed_scale(1.0)

	# mouse/touch input
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var horizontal_analog_value = clamp((get_global_mouse_position() - global_position).x / 160.0, -1.0, 1.0)
		var vertical_analog_value = clamp((get_global_mouse_position() - global_position).y / 136.0, -1.0, 1.0)

		if horizontal_analog_value > 0.1:
			velocity.x = speed + horizontal_analog_value * speed
			$AnimatedSprite.set_speed_scale(2.0)
		elif horizontal_analog_value < -0.1:
			velocity.x = speed + horizontal_analog_value * speed * 0.5
			$AnimatedSprite.set_speed_scale(0.5)

		if abs(vertical_analog_value) > 0.1:
			velocity.y = vertical_analog_value * speed

	var _returned_velocity = move_and_slide(velocity, Vector2(0, 0), false, 4, 0, false)
	
	if position.y < 208 - 13:
		position.y = 208 - 13
	if position.y > 480 - 15:
		position.y = 480 - 15

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Mine"):
			collision.collider.collided()
			if !invincible:
				sink()

func sink():
	alive = false
	$InvincibilityOverlay.visible = false
	$AnimatedSprite.set_speed_scale(1.0)
	$AnimatedSprite.play("sinking")

func become_invincible():
	invincible = true
	$InvincibilityOverlay.visible = true
	$InvincibilityTimer.start()
	
func _on_InvincibilityTimer_timeout():
	invincible = false
	$InvincibilityOverlay.visible = false
