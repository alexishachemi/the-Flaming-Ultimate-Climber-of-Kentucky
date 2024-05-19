extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_button_pressed(): # reset
	Global.money_owned = 0
	Global.player_level = 0
	Global.upgrades = {
		"health": 0,
		"stamina": 0,
		"jump_force": 0,
		"jump_count": 0
	}


func _on_button_2_pressed(): # cheat
	Global.add_money(9999)
