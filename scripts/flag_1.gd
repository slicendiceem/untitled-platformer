extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.checkpoint = Vector2(3648, 160)
		body.respawn()
		

		
