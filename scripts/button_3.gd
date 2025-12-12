# exit_button.gd
extends Button

func _ready():
	pressed.connect(_on_exit_button_pressed)

func _on_exit_button_pressed():
	get_tree().quit()  # Quits the game
