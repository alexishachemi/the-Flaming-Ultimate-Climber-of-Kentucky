extends Node2D

@onready var beat_mover = $"../BeatMover"
@onready var player = $"../Player"

var rotation_speed = 100.0
var projectile_scene = preload("res://level/bomba.tscn")
var shoot_force = 1000.0

func _ready():
	beat_mover.connect("beat", _on_BeatMover_beat)

func _process(delta):
	var player_pos = player.position
	var vec_to_player = player_pos - global_position
	var angle_to_player = vec_to_player.angle()
	rotation = lerp_angle(rotation, angle_to_player, rotation_speed * delta)

func _on_BeatMover_beat(beat_passed):
	if (beat_passed % 16) != 0:
		return
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.rotation = rotation
	projectile.apply_impulse(Vector2(1, 0).rotated(rotation) * shoot_force, Vector2())
