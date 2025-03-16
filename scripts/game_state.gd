extends Node

# Game Settings

# Player Data
var PlayerName: String = ""
var PlayerLives: int = 0
var PlayerExperience: float = 0

# Load game settings - called during startup
func LoadGameSettings() -> void:
	pass

# Save game settings
func SaveGameSettings() -> void:
	const data = {}
	pass

#  Load game settings on start-up
func _ready() -> void:
	LoadGameSettings()
