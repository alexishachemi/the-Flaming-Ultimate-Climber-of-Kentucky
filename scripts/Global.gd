extends Node

# Declare your global variables
var money_owned: int = 0
var upgrades: Dictionary = {
	"health": 0,
	"stamina": 0,
	"jump_force": 0,
	"jump_count": 0
}

func _ready():
	load_game()  # Automatically load game data at startup

# Function to add money
func add_money(amount: int):
	money_owned += amount

# Function to spend money
func spend_money(amount: int) -> bool:
	if money_owned >= amount:
		money_owned -= amount
		return true
	return false

# Function to upgrade a feature
func upgrade_feature(feature: String):
	if feature in upgrades:
		upgrades[feature] += 1

# Save the game state to a file
func save_game():
	var file = ConfigFile.new()
	file.set_value("game", "money_owned", money_owned)
	file.set_value("game", "upgrades", upgrades)
	
	var error = file.save("user://game_data.cfg")
	if error != OK:
		print("Failed to save game data!")

# Load the game state from a file
func load_game():
	var file = ConfigFile.new()
	var error = file.load("user://game_data.cfg")
	
	if error == OK:
		money_owned = file.get_value("game", "money_owned", 0)
		upgrades = file.get_value("game", "upgrades", {})
	else:
		print("Failed to load game data or no save file exists.")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
