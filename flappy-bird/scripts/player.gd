extends CharacterBody2D

signal death
const SPEED = 300.0
const JUMP_VELOCITY = -245.0

var starting_position: Vector2
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	starting_position = position


func _physics_process(delta: float) -> void:
	# Handle collisions
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("death"):
			die()
			break

	# Apply gravity if not on the floor.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump input.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		rotation = 0

	# Gradually rotate downward if falling.
	if velocity.y > 0:
		rotation = lerp(rotation, deg_to_rad(90), delta * 1.5)

	move_and_slide()
	
func jump():
	pass


var is_dead: bool = false

func die() -> void:
	if is_dead:
		return
	is_dead = true
	
	# Disable visuals, physics, and collisions. Otherwise weird behavior
	visible = false
	set_physics_process(false)
	if collision_shape:
		# Deferred here as errors pop due to flushing or something
		collision_shape.set_deferred("disabled", true)
	
	# Play death sound.
	death_sound.play()
	
	# Get the tree here and creater for audio length
	await get_tree().create_timer(death_sound.stream.get_length()).timeout
	
	# Emit death signal and free this node.
	death.emit()
	queue_free()

func reset() -> void:
	position = starting_position
	velocity = Vector2.ZERO
