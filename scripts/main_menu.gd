# main_menu.gd
extends Control

func _ready():
	# Load your music file
	var menu_music = preload("res://music/good.mp3")
	# Play it through MusicManager
	MusicManager.play_music(menu_music)
