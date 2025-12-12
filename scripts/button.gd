extends Button

@export var menu_scene_path: String = "res://scene/mainMenu.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button's pressed signal to our function
	pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	# Load the game scene
	var menu_scene = load(menu_scene_path)
	
	# Check if scene loaded successfully
	if menu_scene:
		# Change to the game scene
		get_tree().change_scene_to_packed(menu_scene)
	else:
		push_error("Failed to load scene: " + menu_scene_path)
