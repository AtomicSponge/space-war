extends Node

# Called when a new game starts
func NewGame() -> void:
	pass

# Called at the end of a game
func GameOver() -> void:
	# Check if player reached a high score
	for idx in GameState.HighScores.size() - 1:
		if GameState.PlayerScore > GameState.HighScores[idx]:
			GameState.HighScores.insert(idx, GameState.PlayerScore)
			GameState.HighScores = GameState.HighScores.slice(0, 9)
	# Save gamestate to disk then switch to main menu
	GameState.SaveGameData()
	SceneManager.SwitchScene("MainMenu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Pause game
	if Input.is_action_pressed("pause_game"):
		get_tree().paused = true
		$PauseMenu.show()
