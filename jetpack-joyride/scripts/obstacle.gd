extends Node2D

@export var speed: float = 300.0
# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	# Move the obstacle to the right every frame.
	position.x -= speed * delta
