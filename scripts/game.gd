extends Node2D

@onready var pause_menu = $GameCamera/EscMenu
var paused = false

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.levelFailed.connect(_on_levelFailed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

func _on_levelFailed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
