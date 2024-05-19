extends Control

signal shopClosed

func _on_button_pressed():
	shopClosed.emit()
