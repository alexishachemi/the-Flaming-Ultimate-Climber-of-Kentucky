extends VBoxContainer

@export var upgradeName: String = ""
@export var showedName: String = ""
@export var totalLevels: int = 10
@export var startPrice: int = 10
@export var multiplier: int = 4

@onready var priceTxt = $RichTextLabel
@onready var skillProgress = $TextureProgressBar

var currentUpgrade: int = 0

var actualPrice: int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	currentUpgrade = Global.upgrades[upgradeName]
	actualPrice = startPrice + multiplier * currentUpgrade
	priceTxt.text = "[center]" + showedName + "\n" + str(actualPrice) + "🥔"
	skillProgress.value = currentUpgrade * 100 / totalLevels


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_buy_button_pressed():
	if not Global.spend_money(actualPrice):
		return
	if currentUpgrade >= totalLevels:
		return
	Global.upgrade_feature(upgradeName)
	currentUpgrade += 1
	actualPrice = startPrice + multiplier * currentUpgrade
	priceTxt.text = "[center]" + showedName + "\n" + str(actualPrice) + "🥔"
	skillProgress.value = currentUpgrade * 100 / totalLevels
