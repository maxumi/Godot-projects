extends CharacterBody3D

@onready var visuals: Node3D = $Visuals
@onready var camera_mount: Node3D = $CameraMount
@onready var animation_player: AnimationPlayer = $Visuals/mixamo_base/AnimationPlayer

var SPEED = 3.0
const WALKING = 3.0
const RUNNING = 5.0
const JUMP_VELOCITY = 4.5
var is_running  = false
var is_locked = false

@export var sens_horizontal:float = 0.5
@export var sens_vertical:float = 0.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y((deg_to_rad(-event.relative.x * sens_horizontal)))
		camera_mount.rotate_x((deg_to_rad(-event.relative.y * sens_vertical)))


func _physics_process(delta: float) -> void:
	if !animation_player.is_playing():
		is_locked = false
		
	if Input.is_action_just_pressed("kick"):
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			is_locked = true
				
	if Input.is_action_pressed("run"):
		SPEED = RUNNING
		is_running = true
	else:
		SPEED = WALKING
		is_running = false
	
	# Apply gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the movement input.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if !is_locked:
			# Choose animation based on running state.
			if is_running:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
			visuals.look_at(position + direction)

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_locked:
			# No directional input; play idle.
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if !is_locked:
		move_and_slide()
