extends Node2D

# Variables to store the player and camera references.
@onready var player = $"../Player"
@onready var camera = $"../GameCamera"

# Variable to store the last checkpoint position.
var last_checkpoint = Vector2()

func _ready():
	last_checkpoint = player.position
	# Initialize the checkpoint manager.
	connect_signals()

func connect_signals():
	# Connect signals from all checkpoint nodes to this manager.
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.connect("checkpoint_reached", _on_Checkpoint_reached)

func _on_Checkpoint_reached(checkpoint_position):
	# Update the last checkpoint when a checkpoint is reached.
	last_checkpoint = checkpoint_position

func _process(delta):
	# Check if the player leaves the screen and teleport them back.
	if is_player_off_screen():
		teleport_player_to_checkpoint()

func is_player_off_screen():
	# Define the logic to determine if the player is off the screen with some margin.
	var screen_bounds = get_viewport_rect()
	var margin = Vector2(200, 200)  # Margin of 50 pixels on each side

	# Create an expanded screen boundary that incorporates the margin.
	var expanded_bounds = Rect2(
		screen_bounds.position - margin,
		screen_bounds.size + margin * 2
	)

	# Check if the player's position is outside the expanded boundaries.
	return not expanded_bounds.has_point(player.position)

func teleport_player_to_checkpoint():
	# Teleport the player to the last checkpoint.
	player.position = last_checkpoint
	update_camera_position()

func update_camera_position():
	# Update the camera's y position to match the checkpoint.
	camera.position.y = last_checkpoint.y - 300
