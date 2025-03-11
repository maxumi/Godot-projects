extends Node

@onready var ui: Control = $UI
@onready var pipe_spawner: Timer = $PipeSpawner
@onready var pipe_spawner_marker: Marker2D = $PipeSpawnerMarker
@onready var pipe_death_marker: Marker2D = $PipeDeathMarker
@onready var pipes_node: Node = $Pipes
@onready var player: CharacterBody2D = $Player  # Initial player node

const PipeType = preload("res://Scenes/pipes.tscn")
# Preload the player scene so we can reinstance it after death
const PlayerScene = preload("res://Scenes/Player.tscn")
var rng = RandomNumberGenerator.new()
var game_started = false
var player_start_position: Vector2

func _ready() -> void:
	rng.randomize()
	pipe_spawner.stop()
	player.set_physics_process(false)
	player_start_position = player.position

func _on_pipe_spawner_timeout() -> void:
	var pipe_instance = PipeType.instantiate()
	pipe_instance.position = pipe_spawner_marker.position
	pipe_instance.death_x = pipe_death_marker.position.x
	pipe_instance.position.y += rng.randf_range(-50, 50)
	pipes_node.add_child(pipe_instance)

func _on_start_game() -> void:
	if game_started:
		return
	game_started = true
	ui.hide()                # Hide the UI
	pipe_spawner.start()     # Start spawning pipes
	# Ensure the player is active (if reinstance, player will be valid)
	if is_instance_valid(player):
		player.set_physics_process(true)

func _on_player_death() -> void:
	if not is_instance_valid(player):
		return

	# Stop the pipe spawner
	pipe_spawner.stop()
	pipe_spawner.autostart = false
	# Queue the player for deletion and clear the reference immediately.
	player.queue_free()
	player = null
	# Defer the restart call to the next idle frame.
	call_deferred("restart")

# Restart function resets the game state for a new game.
func restart() -> void:
	# Reset game flag
	game_started = false

	# Stop the pipe spawner in case it's still running
	pipe_spawner.stop()
	pipe_spawner.autostart = false

	# Clear any existing pipes from the pipes_node
	for pipe in pipes_node.get_children():
		pipe.queue_free()

	# If the player node is no longer valid, reinstance a new one.
	if not is_instance_valid(player):
		player = PlayerScene.instantiate()
		add_child(player)
		# Reconnect Signal
		player.death.connect(_on_player_death)

	# Reset the player's state, deferring the change
	player.position = player_start_position
	player.call_deferred("set_physics_process", false)

	# Reset the UI. This assumes your UI node implements a show_ui() function
	ui.show_ui()
