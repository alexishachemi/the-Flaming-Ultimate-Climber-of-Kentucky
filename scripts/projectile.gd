extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var notifier = VisibleOnScreenEnabler2D.new()
	add_child(notifier)
	notifier.connect("screen_exited", _on_ScreenExited)

func _on_ScreenExited():
	queue_free()  # Deletes the object


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.hurt(20)
