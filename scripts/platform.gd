# Platform.gd
extends Node2D

@onready var beat_mover = $"../BeatMover"

# Exported properties for user-defined target transform
@export var target_position: Vector2
@export var target_rotation_degrees: float
@export var target_scale: Vector2
@export var speed: float = 20.0  # Movement speed

# State variables to store initial transform
var initial_position: Vector2
var initial_rotation_degrees: float
var initial_scale: Vector2

# State flag to determine the current target
var moving_to_target: bool = true

func _ready():
	beat_mover.connect("beat", _on_BeatMover_beat)
	# Store the initial transform of the platform
	initial_position = position
	initial_rotation_degrees = rotation_degrees
	initial_scale = scale

func _process(delta):
	# Choose the current target based on the flag
	var current_target_position = target_position + initial_position if moving_to_target else initial_position
	var current_target_rotation = deg_to_rad(target_rotation_degrees + initial_rotation_degrees) if moving_to_target else deg_to_rad(initial_rotation_degrees)
	var current_target_scale = target_scale * initial_scale if moving_to_target else initial_scale

	# Interpolate towards the current target
	position = position.lerp(current_target_position, clamp(delta * speed, 0, 1))
	rotation = lerp_angle(rotation, current_target_rotation, clamp(delta * speed, 0, 1))
	scale = scale.lerp(current_target_scale, clamp(delta * speed, 0, 1))

func _on_BeatMover_beat(beats_passed):
	# Toggle the target on each beat
	moving_to_target = !moving_to_target
