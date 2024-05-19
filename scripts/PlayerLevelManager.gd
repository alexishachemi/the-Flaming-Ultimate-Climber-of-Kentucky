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
	if player.out:
		player.die()
		teleport_player_to_checkpoint()
		player.out = false
		player.reset()


func teleport_player_to_checkpoint():
	# Teleport the player to the last checkpoint.
	player.position = last_checkpoint
	update_camera_position()

func update_camera_position():
	# Update the camera's y position to match the checkpoint.
	camera.position.y = last_checkpoint.y - 100
