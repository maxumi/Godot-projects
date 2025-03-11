extends CharacterBody2D

const DEFAULT_SPEED = 300

var _speed = DEFAULT_SPEED
var direction = Vector2.DOWN

@onready var _initial_pos = position

func _physics_process(delta: float) -> void:
	velocity = direction * _speed
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		# Bounce using the collision normal and normalize the direction.
		direction = direction.bounce(collision_info.get_normal()).normalized()
		# Add a tiny random offset (e.g., ±0.1 radians) for unpredictability.
		var random_offset = (randf() * 2 - 1) * 0.2
		direction = direction.rotated(random_offset)
		
		var collider = collision_info.get_collider()
		if collider.is_in_group("brick"):
			collider.queue_free()
			var main_node = get_tree().get_root().get_node("Main")
			if main_node:
				main_node.add_point()
				main_node.check_bricks();

func reset():
	direction = Vector2.DOWN
	position = _initial_pos
	_speed = DEFAULT_SPEED
