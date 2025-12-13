# music_manager.gd
extends AudioStreamPlayer2D

# You can preload your music here or set it in the inspector
@export var default_music: AudioStream

func _ready():
	# Set to always process (play across scene changes)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Start playing default music if set
	if default_music and not playing:
		stream = default_music
		play()

func play_music(music: AudioStream):
	# Don't restart if same music is already playing
	if stream == music and playing:
		return
	
	stream = music
	play()
