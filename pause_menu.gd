extends Control
var menu_scene = load("res://scene/mainMenu.tscn")
func _ready():
	hide()

func resume():
	get_tree().paused = false
	hide()
	
func pause():
	get_tree().paused = true
	show()
	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()



func _on_resume_pressed() -> void:
	resume()



func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_packed(menu_scene)


func _process(delta):
	testEsc()
