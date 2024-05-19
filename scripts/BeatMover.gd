# BeatMover.gd
extends Node

signal beat(beats_passed)

# Settable properties
@export var bpm: float = 136.0  # Beats per minute
var beats_passed: int = 0
var seconds_per_beat: float
var next_beat_time: float = 0.0
var paused: bool = false
@onready var audio_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready():
	audio_player.play()
	seconds_per_beat = 60.0 / bpm
	next_beat_time = seconds_per_beat

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		audio_player.stream_paused = paused
	if paused:
		return
	var current_time = $"../AudioStreamPlayer".get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	if current_time >= next_beat_time:
		beats_passed += 1
		emit_signal("beat", beats_passed)  # Emit a signal on each beat
		next_beat_time += seconds_per_beat

func get_beats_passed() -> int:
	return beats_passed
