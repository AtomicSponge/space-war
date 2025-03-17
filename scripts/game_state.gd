extends Node

# Game Settings

# Player Data
var PlayerName: String = ""
var PlayerLives: int = 0
var PlayerExperience: float = 0

# Private variables
const _save_path = "user://save.dat"

# Load game settings - called during startup
func LoadGameSettings() -> void:
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.READ, "changeme")

# Save game settings
func SaveGameSettings() -> void:
	var save_data = {
		"settings": {},
		"high_scores": [
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		]
	}
	
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.WRITE, "changeme")
	file.store_var(save_data)
	file.close()

#  Load game settings on start-up
func _ready() -> void:
	pass
