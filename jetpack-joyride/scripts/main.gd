extends Node

const OBSTACLE_A_POS: Vector2 = Vector2(1160.0, 390)
const OBSTACLE_B_POS: Vector2 = Vector2(1160.0, 0)  # Higher (i.e. smaller y value)

@onready var death_zone: Area2D = $DeathZone
@onready var player: CharacterBody2D = $Player
@export var obstacle_scene_a: PackedScene
@export var obstacle_scene_b: PackedScene

@onready var score_label: Label = $ScoreLabel
@onready var obstacle_timer: Timer = $ObstacleTimer  # Make sure a Timer node named "ObstacleTimer" exists

var score = 0
var stop_game = false

func _physics_process(_delta: float) -> void:
	# Update the score only if the game hasn't stopped.
	if not stop_game:
		score += 0.5
		score_label.text = str(score)

func spawn_obstacle():
	# If the game has stopped, don't spawn obstacles.
	if stop_game:
		return
	
	var scene_to_spawn: PackedScene
	var spawn_position: Vector2
	
	# Randomly choose either obstacle A or B.
	if (randi() % 2) == 0:
		scene_to_spawn = obstacle_scene_a
		spawn_position = OBSTACLE_A_POS
	else:
		scene_to_spawn = obstacle_scene_b
		spawn_position = OBSTACLE_B_POS
	
	# Instantiate and position the chosen obstacle.
	var obstacle = scene_to_spawn.instantiate()
	obstacle.position = spawn_position
	$Obstacles.add_child(obstacle)
	obstacle.add_to_group("obstacle")
	print("Spawned obstacle at ", spawn_position)

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		body.queue_free()
		print("Player freed")
		stop_game = true
		# Stop the obstacle timer so no more obstacles spawn.
		obstacle_timer.stop()

func _on_obstacle_timer_timeout() -> void:
	spawn_obstacle()

func _on_despawn_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacle"):
		body.queue_free()
		print("Obstacle freed")
