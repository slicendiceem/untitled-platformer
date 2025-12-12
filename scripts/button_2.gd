extends Button

@export var options_scene_path: String = "res://scene/options.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button's pressed signal to our function
	pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	# Load the game scene
	var options_scene = load(options_scene_path)
	
	# Check if scene loaded successfully
	if options_scene:
		# Change to the game scene
		get_tree().change_scene_to_packed(options_scene)
	else:
		push_error("Failed to load scene: " + options_scene_path)
