extends Node

# Game Settings
static var NumberLives: int = 2
static var NumberContinues: int = 0
# Constants for setting options
const MIN_LIVES: int = 0
const MAX_LIVES: int = 5
const MIN_CONTINUES: int = 0
const MAX_CONTINUES: int = 3
const DEFAULT_LIVES: int = 2
const DEFAULT_CONTINUES: int = 0
# Score penalty on death
const DEATH_PENALTY: int = 1000

# Player Data
static var PlayerLives: int = 2
static var PlayerContinues: int = 0
static var PlayerScore: int = 0

# Scores
static var HighScores: Array[int] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

# Display Settings
static var DisplayMode: int = 0

# Private variables
const _save_path: String = "user://game.dat"

# Global location of player, updates in the main loop
static var PlayerLocation: Vector2 = Vector2(0, 0)

# Globals for volume.  Used for saving settings
static var MainVolume: float = 0.0
static var MusicVolume: float = 0.0
static var EffectsVolume: float = 0.0

# Load game settings - called during startup
func LoadGameData() -> int:
	if not FileAccess.file_exists(_save_path):
		return 1

	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.READ, "dragongelatohierarchy")
	if file == null:
		alert('Could not load game data!')
		return -1
	var save_data = file.get_var()
	file.close()

	# De-seralize game data
	NumberLives = save_data["number_lives"]
	NumberContinues = save_data["number_continues"]
	HighScores = save_data["high_scores"]
	DisplayMode = save_data["display_mode"]

	return 0

# Save game settings - called at game over
func SaveGameData() -> int:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayMode = 0
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayMode = 1

	# Serialize game data
	var save_data = {
		"number_lives": NumberLives,
		"number_continues": NumberContinues,
		"high_scores": HighScores,
		"display_mode": DisplayMode
	}
	
	var file = FileAccess.open_encrypted_with_pass(_save_path, FileAccess.WRITE, "dragongelatohierarchy")
	if file == null:
		alert('Could not save game data!')
		return -1
	file.store_var(save_data)
	file.close()
	return 0

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
	if LoadGameData() == 0:
		if DisplayMode == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		elif DisplayMode == 1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
