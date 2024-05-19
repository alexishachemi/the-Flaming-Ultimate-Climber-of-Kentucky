extends Node2D

@export var options: Array[PackedScene] = [
	preload("res://scenes/powerups/chicken.tscn"),
	preload("res://scenes/powerups/ice_cream.tscn"),
	preload("res://scenes/powerups/old_watch.tscn"),
	preload("res://scenes/powerups/tabasco.tscn")
]

@onready var powerup: Node2D = options.pick_random().instantiate()

func on_powerup_delete():
	queue_free()

func _ready():
	$sprite.hide()
	add_child(powerup)
	powerup.connect("tree_exited", on_powerup_delete)
