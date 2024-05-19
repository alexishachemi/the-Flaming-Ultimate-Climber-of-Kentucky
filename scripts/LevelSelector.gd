extends Control

@onready var lvl2Btn = $VBoxContainer/HBoxContainer/lvl2Button
@onready var lvl3Btn = $VBoxContainer/HBoxContainer/lvl3Button


# Called when the node enters the scene tree for the first time.
func _ready():
	lvl2Btn.visible = Global.player_level >= 1
	lvl3Btn.visible = Global.player_level >= 2

func _on_lvl_1_button_pressed():
	Global.currentLevel = 1
	get_tree().change_scene_to_file("res://scenes/levels/level01.tscn")


func _on_lvl_2_button_pressed():
	Global.currentLevel = 2
	pass # Replace with function body.


func _on_lvl_3_button_pressed():
	Global.currentLevel = 3
	pass # Replace with function body.


func _on_shop_button_pressed():
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
