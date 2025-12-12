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

func play_music(music: AudioStream, volume_db: float = -10.0):
	# Don't restart if same music is already playing
	if stream == music and playing:
		return
	
	stream = music
	volume_db = volume_db
	play()

func stop_music(fade_time: float = 0.0):
	if fade_time > 0:
		var tween = create_tween()
		tween.tween_property(self, "volume_db", -80.0, fade_time)
		await tween.finished
	
	stop()
