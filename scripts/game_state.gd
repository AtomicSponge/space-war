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
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.READ, "dragongelatohierarchy")
	var save_data = file.get_var()
	file.close()
	# De-seralize game data

# Save game settings - called at game over
func SaveGameData() -> void:
	# Serialize game data
	var save_data = {
		"settings": {},
		"high_scores": [
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		]
	}
	
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.WRITE, "dragongelatohierarchy")
	file.store_var(save_data)
	file.close()
	if not FileAccess.file_exists(_save_path):
		alert('Could not save game data!')
		return

# Display an alert
func alert(text: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.dialog_hide_on_ok = false # Disable default behaviour
	dialog.connect('confirmed', dialog.queue_free) # Free node on OK
	var scene_tree = Engine.get_main_loop()
	scene_tree.current_scene.add_child(dialog)
	dialog.popup_centered()

#  Load game settings on start-up
func _ready() -> void:
	LoadGameData()
