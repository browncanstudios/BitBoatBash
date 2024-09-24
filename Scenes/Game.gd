extends Node

signal restart

var rng = RandomNumberGenerator.new()
var counter = 0

func _ready():
	rng.randomize()
	$Player.alive = false
	$Player.visible = false

func init():
	$Player.alive = true
	$Player.visible = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if $Player.alive == false:
				emit_signal("restart")
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_M or event.scancode == KEY_K:
			$Player.become_invincible()

func _process(_delta):
	if Input.is_action_pressed("ui_select"):
		emit_signal("restart")
		
	if $WaveSpawnTimer.is_stopped():
		var min_time = 0.25
		var max_time = 0.5
		$WaveSpawnTimer.start(rng.randf_range(min_time, max_time))

	if $MineSpawnTimer.is_stopped():
		# make the spawn timer shorter the larger the player's score
		var min_time = max(1.0 - float(counter) / 20.0, 0.1)
		var max_time = max(2.0 - float(counter) / 20.0, 0.1)
		$MineSpawnTimer.start(rng.randf_range(min_time, max_time))

	if $CollectibleSpawnTimer.is_stopped():
		var min_time = 1.0
		var max_time = 2.0
		$CollectibleSpawnTimer.start(rng.randf_range(min_time, max_time))

	if $CoffeeSpawnTimer.is_stopped():
		if counter >= 20:
			var min_time = 2.0
			var max_time = 7.0
			$CoffeeSpawnTimer.start(rng.randf_range(min_time, max_time))

func _on_MineSpawnTimer_timeout():
	if $Player.alive:
		var mine = load("res://Scenes/Mine.tscn").instance()
		mine.position.x = $Player.position.x + 854
		mine.position.y = rng.randf_range(160, 480 - 10)
		add_child(mine)

func spawnBear():
	if $Player.alive:
		var bear = load("res://Scenes/Bear.tscn").instance()
		bear.position.x = $Player.position.x + 196 +  rng.randf_range(64, 300)
		bear.position.y = 24
		bear.velocity.x = $Player.velocity.x
		bear.destination = rng.randf_range(160 + 20, 480 - 30)
		add_child(bear)

func _on_CollectibleSpawnTimer_timeout():
	if $Player.alive:
		var collectible = load("res://Scenes/Collectible.tscn").instance()
		collectible.position.x = $Player.position.x + 854
		collectible.position.y = rng.randf_range(160, 480 - 10)
		add_child(collectible)

func _on_WaveTimer_timeout():
	var wave = load("res://Scenes/Wave.tscn").instance()
	wave.position.x = rng.randf_range($Player.position.x - 720 / 2, $Player.position.x + 720)
	wave.position.y = rng.randf_range(160, 480 - 10)
	add_child(wave)

func _on_Player_score_changed():
	if $Player.alive:
		$CanvasLayer/HUD/HBoxContainer/ScoreContainer/Label.set_text("X" + String($Player.score))
		counter += 1

func _on_CoffeeSpawnTimer_timeout():
	if counter < 20:
		return

	if $Player.alive:
		var coffee = load("res://Scenes/Coffee.tscn").instance()
		coffee.position.x = $Player.position.x + 854
		coffee.position.y = rng.randf_range(160 - 5, 480 - 10)
		add_child(coffee)

	if $Player.alive:
		var clock = load("res://Scenes/Clock.tscn").instance()
		clock.position.x = $Player.position.x + 854 + 854
		clock.position.y = rng.randf_range(160 - 5, 480 - 10)
		clock.connect("collected", self, "_on_Clock_collected")
		add_child(clock)

func _on_Clock_collected():
	counter = 0
	var mines = get_tree().get_nodes_in_group("Mine")
	for mine in mines:
		mine.collided()

	var clocks = get_tree().get_nodes_in_group("Clock")
	for clock in clocks:
		clock.die()

	var coffees = get_tree().get_nodes_in_group("Coffee")
	for coffee in coffees:
		coffee.die()


func _on_Websocket_event_received(event):
	print("handling event")
	print(event)
	if event == "WarpEntered":
		spawnBear()
	if event == "CoffeeCollected":
		$Player.become_invincible()

