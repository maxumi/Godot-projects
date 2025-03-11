extends Node2D

@onready var label: Label = $Label

func _ready():
	update_score_label()
	print(count_bricks())
	

func add_point():
	GameData.score += 1
	update_score_label()

func update_score_label():
	label.text = "Score: %s" % GameData.score

# Function to check if there are no more bricks and reset the scene
func check_bricks():
	var bricks = get_tree().get_nodes_in_group("brick")
	print(count_bricks())
	if count_bricks() == 1:
		reset_game()

func reset_game():
	# Reload the current scene while the score remains in GameData
	get_tree().reload_current_scene()

func count_bricks() -> int:
	var bricks = get_tree().get_nodes_in_group("brick")
	return bricks.size()
