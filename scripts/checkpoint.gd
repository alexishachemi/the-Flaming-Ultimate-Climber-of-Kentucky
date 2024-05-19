extends Node2D

signal checkpoint_reached(position)

@export var finalCheckPoint: bool = false

@onready var flame = $Flame

var has_been_passed: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_checkpoint_trigger_body_entered(body):
	if has_been_passed:
		return
	# Check if the collided body is the player
	if body.name == "Player":
		# Emit the signal with this checkpoint's position
		emit_signal("checkpoint_reached", position)
		has_been_passed = true
		flame.visible = true
		if finalCheckPoint and Global.currentLevel > Global.player_level:
			Global.player_level = Global.currentLevel
	if finalCheckPoint:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/LevelSelector.tscn")
		
