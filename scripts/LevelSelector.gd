extends Control

@onready var lvl2Btn = $VBoxContainer/HBoxContainer/lvl2Button
@onready var lvl3Btn = $VBoxContainer/HBoxContainer/lvl3Button

@onready var shop = $Shop
@onready var butts = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	shop.shopClosed.connect(_on_shopClosed)
	lvl2Btn.visible = Global.player_level >= 1
	lvl3Btn.visible = Global.player_level >= 2


func _on_lvl_1_button_pressed():
	Global.currentLevel = 1
	get_tree().change_scene_to_file("res://scenes/levels/level01.tscn")


func _on_lvl_2_button_pressed():
	Global.currentLevel = 2
	get_tree().change_scene_to_file("res://scenes/levels/level02.tscn")


func _on_lvl_3_button_pressed():
	Global.currentLevel = 3
	get_tree().change_scene_to_file("res://scenes/levels/level03.tscn")


func _on_shop_button_pressed():
	butts.visible = false
	shop.visible = true

func _on_shopClosed():
	butts.visible = true
	shop.visible = false
