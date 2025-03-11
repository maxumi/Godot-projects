extends Control
signal start_game

@onready var start_button: Button = $StartButton

var game_started = false

func _on_start_button_pressed():
	emit_signal("start_game")  # Emit signal to Main

func show_ui():
	game_started = false
	set_process_unhandled_input(true)
	show()
	
func reset_ui() -> void:
	game_started = false
	set_process_unhandled_input(true)
	show()

func _unhandled_input(event: InputEvent) -> void:
	if game_started:
		return
	else:
		if event.is_action_pressed("ui_accept"):
			emit_signal("start_game")
			set_process_unhandled_input(false)
