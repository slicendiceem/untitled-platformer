extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

var start_position = Vector2.ZERO

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func respawn():
	self.global_position = Vector2(-125, 100)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():	
		velocity += get_gravity() * delta

	

		
	if Input.is_action_just_pressed("MoveDown") and is_on_floor():
		position.y += 5

	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement Input
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	
	# Flip Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	# Run Animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		if velocity.y <= 0:
			animated_sprite.play("Jump"	)
		else:
			animated_sprite.play("Fall"	)

	
	# Movement Speed
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		respawn()
	if body is AnimatableBody2D:
		respawn()
