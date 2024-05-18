extends Camera2D

@onready var beat_mover = $"../BeatMover"

var camera_speed = 30  # Speed at which the camera moves upward, adjust as needed

# References to background images for the parallax effect
@onready var background1 = $Background1
@onready var background2 = $Background2
@onready var background3 = $Background3
@onready var background4 = $Background4

# Offsets for parallax scrolling
var parallax_offsets = [-0.05, -0.1, -0.2, -0.4]

# Signal connection (assuming the BeatMover emits 'beat' and the camera is a child or reachable by the BeatMover)
func _ready():
	beat_mover.connect("beat", _on_beat)
	# Initialize the position of backgrounds
	update_background_positions()

func _process(delta):
	# Move camera upward continuously
	position.y -= camera_speed * delta
	update_background_positions()

func update_background_positions():
	# Update the position of each background relative to the camera
	background1.position.y = position.y * parallax_offsets[0]
	background2.position.y = position.y * parallax_offsets[1]
	background3.position.y = position.y * parallax_offsets[2]
	background4.position.y = position.y * parallax_offsets[3]

func _on_beat(beats_passed):
	# Start the zoom effect
	$zoom_effect.play("zoom_effect")
