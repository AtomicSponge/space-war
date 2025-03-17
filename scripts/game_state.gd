extends Node

# Game Settings

# Player Data
var PlayerName: String = ""
var PlayerLives: int = 0
var PlayerExperience: float = 0

# Private variables
const _save_path = "user://game.dat"

# Load game settings - called during startup
func LoadGameData() -> void:
	if not FileAccess.file_exists(_save_path):
		return
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.READ, "dragongelatohierarchy")
	var save_data = file.get_var()
	file.close()

# Save game settings
func SaveGameData() -> void:
	var save_data = {
		"settings": {},
		"high_scores": [
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		]
	}
	
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.WRITE, "dragongelatohierarchy")
	if not FileAccess.file_exists(_save_path):
		return
	file.store_var(save_data)
	file.close()

#  Load game settings on start-up
func _ready() -> void:
	LoadGameData()
