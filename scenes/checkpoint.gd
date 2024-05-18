extends Node2D

signal checkpoint_reached(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_checkpoint_trigger_body_entered(body):
	# Check if the collided body is the player
	if body.name == "Player":
		# Emit the signal with this checkpoint's position
		emit_signal("checkpoint_reached", position)
