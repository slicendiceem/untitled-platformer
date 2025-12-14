extends Area2D

var menu_scene = load("res://scene/mainMenu.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.checkpoint = Vector2(-125, 100)
		body.respawn()
		get_tree().change_scene_to_packed(menu_scene)
