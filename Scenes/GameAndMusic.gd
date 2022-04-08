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
