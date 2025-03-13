extends Node

@onready var ui: Control = $UI
@onready var pipe_spawner: Timer = $PipeSpawner
@onready var pipe_spawner_marker: Marker2D = $PipeSpawnerMarker
@onready var pipe_death_marker: Marker2D = $PipeDeathMarker
@onready var pipes_node: Node = $Pipes
@onready var player: CharacterBody2D = $Player  # Initial player

const PipeScene = preload("res://Scenes/pipes.tscn")
# Preload the player scene so we can reinstance it after death
const PlayerScene = preload("res://Scenes/player.tscn")
var rng = RandomNumberGenerator.new()
var player_start_position: Vector2

var score = 0
var end_screen = false

func _ready() -> void:
	rng.randomize()
	pipe_spawner.stop()
	player.set_physics_process(false)
	player_start_position = player.position

func _on_pipe_spawner_timeout() -> void:
	var pipe_instance = PipeScene.instantiate()
	pipe_instance.score_point.connect(_on_pipe_score_point)
	pipe_instance.position = pipe_spawner_marker.position
	pipe_instance.death_x = pipe_death_marker.position.x
	pipe_instance.position.y += rng.randf_range(-50, 50)
	pipes_node.add_child(pipe_instance)

func _on_start_game() -> void:
	if end_screen:
		reset()
	start_game()

func _on_player_death() -> void:
	if not is_instance_valid(player):
		return
	# Stop the pipe spawner
	pipe_spawner.stop()
	pipe_spawner.autostart = false
	player = null
	
	ui.show_ui()
	end_screen = true

func reset() -> void:
	# Reset the score
	score = 0
	ui.update_score(score)
	# stops the timer and removes pipes
	pipe_spawner.stop()
	pipe_spawner.autostart = false
	for pipe in pipes_node.get_children():
		pipe.queue_free()
	

	# If the player node is no longer valid, reinstance a new one.
	if not is_instance_valid(player):
		player = PlayerScene.instantiate()
		add_child(player)
		player.death.connect(_on_player_death)
	
	# Reset the player's position and disable physics processing for now.
	player.position = player_start_position
	player.set_physics_process(false)
	end_screen = false

func start_game():
	ui.hide()
	pipe_spawner.start()
	if is_instance_valid(player):
		player.set_physics_process(true)


func _on_pipe_score_point():
	score += 1
	ui.update_score(score)
