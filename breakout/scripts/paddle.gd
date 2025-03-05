extends StaticBody2D
@onready var _screen_size_x = get_viewport_rect().size.x
@onready var sprite_half_width = get_node("Sprite").texture.get_width() / 2

func _physics_process(delta: float) -> void:
	var vect = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		vect.x -= 1
	elif Input.is_action_pressed("ui_right"):
		vect.x += 1
		
	var new_x = position.x + vect.x * delta * 275
	# 50 is paddle isn't cut in half for postion
	position.x = clamp(new_x, 50, _screen_size_x - 50)
