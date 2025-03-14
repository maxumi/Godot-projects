extends CharacterBody2D

const SPEED = 300.0
const THRUST = -300.0  # Adjust for desired upward force

# When true, the player's horizontal (forward) movement is frozen.
var freeze_forward: bool = false

func _physics_process(delta: float) -> void:
	# Apply gravity continuously.
	velocity += get_gravity() * delta
	
	# Activate jetpack thrust when the button is pressed.
	if Input.is_action_pressed("ui_accept"):
		velocity.y = THRUST
	
	else:
		velocity.x = SPEED
	
	velocity.x = 0
	# Move and slide while checking for collisions.
	move_and_slide()
	
