extends Node2D
@export var move_speed: float = 200.0
@export var gap: float = 150.0
@export var vertical_range: float = 100.0
@export var death_x: float = -100.0  # Will be set by the main scene
@export var spawn_offset: Vector2  # Will be set by the main scene

@onready var top_pipe: CollisionShape2D = $PipeParts/Top
@onready var bottom_pipe: CollisionShape2D = $PipeParts/Bottom



func _process(delta: float) -> void:
	# Move the pipe left
	position.x -= move_speed * delta
	
	# Remove the pipe if it has passed the designated death x-position.
	if position.x < death_x:
		remove_pipe()

func remove_pipe() -> void:
	queue_free()
