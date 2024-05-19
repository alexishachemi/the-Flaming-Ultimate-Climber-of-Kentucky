extends TextureProgressBar

@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	player.staminaChanged.connect(update)
	update()

func update():
	value = player.currentStamina * 100 / player.maxStamina
	visible = value < 99
