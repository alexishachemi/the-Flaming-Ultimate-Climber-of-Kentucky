extends Control

@onready var bg = $bg

@onready var butts = $VBoxContainer

@onready var lvlSel = $LevelSelector


var speed = 15.0

var started : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.gameStarted == true:
		bg.position.y = 0
		lvlSel.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		butts.visible = true
		Global.gameStarted = true
			
	if bg.position.y > 0:
		bg.position.y -= speed * delta
	else:
		if not started:
			butts.visible = true
			started = true
			Global.gameStarted = true
	
	
func _on_start_button_pressed():
	butts.visible = false
	lvlSel.visible = true


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
