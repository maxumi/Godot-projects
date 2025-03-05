extends CharacterBody2D

const DEFAULT_SPEED = 275

var _speed = DEFAULT_SPEED
var direction = Vector2.DOWN

@onready var _initial_pos = position

func _physics_process(delta: float) -> void:
	velocity = direction * _speed
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		# Bounce using the collision normal and normalize the direction.
		direction = direction.bounce(collision_info.get_normal()).normalized()
		# Add a slight random offset to the direction's angle.
		var random_offset = randf() * 2 - 1.  # Adjust 0.2 for more/less variation.
		direction = direction.rotated(random_offset)


func reset():
	direction = Vector2.DOWN
	position = _initial_pos
	_speed = DEFAULT_SPEED
