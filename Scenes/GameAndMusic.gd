extends Node

var game = null

var song_index = 0
var songs = [
	{ 
		"name": "Rockboy",
		"album": "Chiprock Houseparty",
		"artist": "Nikola Whallon",
		"stream": preload("res://Assets/Music/Nikola Whallon - Chiprock Houseparty - 09 Rockboy (DMG Mix).ogg")
	},
	{ 
		"name": "Slime Time",
		"album": "Chiprock Houseparty",
		"artist": "Nikola Whallon",
		"stream": preload("res://Assets/Music/Nikola Whallon - Chiprock Houseparty - 11 Slime Time (DMG Mix).ogg")
	},
	{ 
		"name": "Sparkles",
		"album": "Chiprock Houseparty",
		"artist": "Nikola Whallon",
		"stream": preload("res://Assets/Music/Nikola Whallon - Chiprock Houseparty - 16 Sparkles (DMG Mix).ogg")
	}
	]

func restart_game_scene():
	if game != null:
		remove_child(game)
		get_tree().queue_delete(game)
	game = load("res://Scenes/Game.tscn").instance()
	add_child(game)
	game.init()
	game.get_node("Player").connect("player_sunk", self, "_on_Player_sunk")

func _unhandled_input(event):
	OS.window_fullscreen = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and ($PressPlayUI/MarginContainer.visible or $GameOverUI/MarginContainer.visible):
			$PressPlayUI/MarginContainer.visible = false
			$GameOverUI/MarginContainer.visible = false
			restart_game_scene()

func _ready():
	game = load("res://Scenes/Game.tscn").instance()
	add_child(game)
	
	$MusicPlayer.stream = songs[song_index]["stream"]
	$MusicPlayer.play()
	$MusicUI/Container/SongLabel.text = songs[song_index]["name"]

func _process(_delta):
	if !$MusicPlayer.is_playing():
		if song_index + 1 >= songs.size():
			song_index = 0
		else:
			song_index += 1
		$MusicPlayer.stream = songs[song_index]["stream"]
		$MusicPlayer.play()
		$MusicUI/Container/SongLabel.text = songs[song_index]["name"]

	if Input.is_action_pressed("ui_accept") and ($PressPlayUI/MarginContainer.visible or $GameOverUI/MarginContainer.visible):
		$PressPlayUI/MarginContainer.visible = false
		$GameOverUI/MarginContainer.visible = false
		restart_game_scene()

func _on_Player_sunk():
	$GameOverUI/MarginContainer.visible = true
