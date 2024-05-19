extends Camera2D

@onready var beat_mover = $"../BeatMover"

var camera_speed = 30  # Speed at which the camera moves upward, adjust as needed

# References to background images for the parallax effect
@onready var background1 = $Background1
@onready var background2 = $Background2
@onready var background3 = $Background3
@onready var background4 = $Background4

var initBG1;
var initBG2;
var initBG3;
var initBG4;

# Offsets for parallax scrolling
var parallax_offsets = [-1.1, -1.2, -1.4, -1.8]

# Signal connection (assuming the BeatMover emits 'beat' and the camera is a child or reachable by the BeatMover)
func _ready():
	beat_mover.connect("beat", _on_beat)
	# Initialize the position of backgrounds
	initBG1 = background1.position.y
	initBG2 = background2.position.y
	initBG3 = background3.position.y
	initBG4 = background4.position.y
	update_background_positions()

func _process(delta):
	# Move camera upward continuously
	position.y -= camera_speed * delta
	update_background_positions()

func update_background_positions():
	# Update the position of each background relative to the camera
	background1.position.y = initBG1 + position.y * parallax_offsets[0]
	background2.position.y = initBG2 + position.y * parallax_offsets[1]
	background3.position.y = initBG3 + position.y * parallax_offsets[2]
	background4.position.y = initBG4 + position.y * parallax_offsets[3]

func _on_beat(beats_passed):
	# Start the zoom effect
	$zoom_effect.play("zoom_effect")
