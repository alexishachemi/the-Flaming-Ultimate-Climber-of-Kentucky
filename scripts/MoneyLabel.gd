extends RichTextLabel

var shownValue

# Called when the node enters the scene tree for the first time.
func _ready():
	shownValue = Global.money_owned
	text = (
		"[center]\n[font_size=20]POTATOES 🥔[/font_size]\n[font_size=60]"
		+ str(shownValue) + "[/font_size]"
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shownValue == Global.money_owned:
		return
	shownValue = Global.money_owned
	text = (
		"[center]\n[font_size=20]POTATOES 🥔[/font_size]\n[font_size=60]"
		+ str(shownValue) + "[/font_size]"
		)
