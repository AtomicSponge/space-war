extends Node

# Game Settings
var NumberLives: int = 2
var NumberContinues: int = 0
const MIN_LIVES: int = 0
const MAX_LIVES: int = 5
const MIN_CONTINUES: int = 0
const MAX_CONTINUES: int = 3
const DEFAULT_LIVES: int = 2
const DEFAULT_CONTINUES: int = 0

# Player Data
var PlayerLives: int = 2
var PlayerContinues: int = 0
var PlayerScore: int = 0

# Scores
var HighScores: Array[int] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

# Private variables
const _save_path: String = "user://game.dat"

# Load game settings - called during startup
func LoadGameData() -> void:
	if not FileAccess.file_exists(_save_path):
		return

	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.READ, "dragongelatohierarchy")
	if file == null:
		alert('Could not load game data!')
		return
	var save_data = file.get_var()
	file.close()

	# De-seralize game data
	NumberLives = save_data["number_lives"]
	NumberContinues = save_data["number_continues"]
	HighScores = save_data["high_scores"]

# Save game settings - called at game over
func SaveGameData() -> void:
	# Serialize game data
	var save_data = {
		"number_lives": NumberLives,
		"number_continues": NumberContinues,
		"high_scores": HighScores
	}
	
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.WRITE, "dragongelatohierarchy")
	if file == null:
		alert('Could not save game data!')
		return
	file.store_var(save_data)
	file.close()

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
