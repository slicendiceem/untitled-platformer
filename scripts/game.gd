# main_menu.gd
extends Node2D
func _ready():
	# Load your music file
	var game_music = preload("res://music/Echoes of the Deep Hall.mp3")
	
	MusicManager.play_music(game_music)
