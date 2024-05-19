extends TextureProgressBar

@onready var player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	player.healthChanged.connect(update)


func update():
	value = player.currentHealth * 100 / player.maxHealth
