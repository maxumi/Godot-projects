extends CharacterBody2D

signal death
const SPEED = 300.0
const JUMP_VELOCITY = -245.0

var starting_position: Vector2


func _ready() -> void:
	starting_position = position


func _physics_process(delta: float) -> void:
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		# If no collider is found, skip.
		if collision.get_collider() == null:
			continue
			
		if collision.get_collider().is_in_group("death"):
			#var pipe = collision.get_collider()
			die()
			break



	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
 

	move_and_slide()

func die():
	print("DEATH")
	death.emit()
	
func reset() -> void:
	position = starting_position
	velocity = Vector2.ZERO
