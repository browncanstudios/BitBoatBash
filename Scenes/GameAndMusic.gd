extends Node

var game = null

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			if game != null:
				remove_child(game)
				get_tree().queue_delete(game)
			game = load("res://Scenes/Game.tscn").instance()
			add_child(game)

func _ready():
	game = load("res://Scenes/Game.tscn").instance()
	add_child(game)
