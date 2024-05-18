extends CharacterBody2D

@onready var beat_mover = $"../BeatMover"

# Enemy settings
var speed = 100.0
var rotation_speed = 50.0  # Higher values mean quicker, smoother rotations
var projectile_scene = preload("res://scenes/projectile.tscn")


# Called when the node enters the scene tree for the first time
func _ready():
	# Connect the "beat" signal from another node (e.g., a game controller) to this enemy
	# Assuming the game controller has a method that emits "beat" signal
	beat_mover.connect("beat", _on_GameController_beat)

func _process(delta):
	# Rotate towards the mouse position
	var mouse_pos = get_global_mouse_position()
	var vec_to_mouse = mouse_pos - global_position
	var angle_to_mouse = vec_to_mouse.angle()
	rotation = lerp_angle(rotation, angle_to_mouse, rotation_speed * delta)

	# Move towards the mouse position
	var move_vec = vec_to_mouse.normalized() * speed
	velocity = move_vec
	move_and_slide()

# Signal handler for shooting
func _on_GameController_beat(Bbeats_passed):
	# Shoot a projectile
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)  # Adding to the parent to avoid transform complications
	projectile.global_position = global_position
	projectile.rotation = rotation
	projectile.apply_impulse(Vector2(1, 0).rotated(rotation) * 400, Vector2())  # Adjust the impulse as needed
