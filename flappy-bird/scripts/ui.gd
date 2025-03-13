extends Control
signal start_game

@onready var start_button: Button = $StartButton
@onready var score: Label = $Score

var game_started = false

func _on_start_button_pressed():
	game_started = true
	start_game.emit()  # Emit signal to Main

func show_ui():
	game_started = false
	set_process_unhandled_input(true)
	show()

func _unhandled_input(event: InputEvent) -> void:
	if game_started:
		return
	else:
		if event.is_action_pressed("ui_accept"):
			start_game.emit()
			set_process_unhandled_input(false)

func update_score(score_number) -> void:
	score.text = "Score: %s" % score_number
