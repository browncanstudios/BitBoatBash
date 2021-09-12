extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func soft_restart():
	$Player.alive = true
	$Player.visible = true
	$Player.score = 0
	$CanvasLayer/HUD/HBoxContainer/ScoreContainer/Label.set_text("X" + String($Player.score))
	for node in get_children():
		if node.is_in_group("Mine"):
			node.die()
		elif node.is_in_group("Collectible"):
			node.die()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			soft_restart()
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if $Player.alive == false:
				soft_restart()

func _process(_delta):
	if Input.is_action_pressed("ui_select"):
		soft_restart()
		
	if $WaveSpawnTimer.is_stopped():
		var min_time = 0.25
		var max_time = 0.5
		$WaveSpawnTimer.start(rng.randf_range(min_time, max_time))

	if $MineSpawnTimer.is_stopped():
		# make the spawn timer shorter the larger the player's score
		var min_time = max(1.0 - float($Player.score) / 100.0, 0.1)
		var max_time = max(2.0 - float($Player.score) / 100.0, 0.1)
		$MineSpawnTimer.start(rng.randf_range(min_time, max_time))

	if $CollectibleSpawnTimer.is_stopped():
		var min_time = 1.0
		var max_time = 2.0
		$CollectibleSpawnTimer.start(rng.randf_range(min_time, max_time))

func _on_MineSpawnTimer_timeout():
	if $Player.alive:
		var mine = load("res://Scenes/Mine.tscn").instance()
		mine.position.x = $Player.position.x + 854
		mine.position.y = rng.randf_range(208 - 5, 480 - 10)
		add_child(mine)

func _on_CollectibleSpawnTimer_timeout():
	if $Player.alive:
		var collectible = load("res://Scenes/Collectible.tscn").instance()
		collectible.position.x = $Player.position.x + 854
		collectible.position.y = rng.randf_range(208 - 5, 480 - 10)
		add_child(collectible)

func _on_WaveTimer_timeout():
	var wave = load("res://Scenes/Wave.tscn").instance()
	wave.position.x = rng.randf_range($Player.position.x - 720 / 2, $Player.position.x + 720)
	wave.position.y = rng.randf_range(208 - 5, 480 - 10)
	add_child(wave)

func _on_Player_score_changed():
	if $Player.alive:
		$CanvasLayer/HUD/HBoxContainer/ScoreContainer/Label.set_text("X" + String($Player.score))

func _on_Player_died():
	$Player.alive = false
