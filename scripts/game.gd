extends Node

@onready var Player = $Player
@onready var MessageLabel = $Overlay/MessageLabel
@onready var PauseMenu = $PauseMenu

# Called when a new game starts
func NewGame() -> void:
	get_tree().paused = true
	Player.hide()
	MessageLabel.text = "GET READY"
	MessageLabel.show()
	GameState.PlayerLives = GameState.NumberLives
	GameState.PlayerContinues = GameState.NumberContinues
	GameState.PlayerScore = 0
	await get_tree().create_timer(2.5).timeout
	MessageLabel.hide()
	Player.show()
	get_tree().paused = false

# Called at the end of a game
func GameOver() -> void:
	get_tree().paused = true
	Player.hide()
	MessageLabel.text = "GAME OVER"
	MessageLabel.show()
	await get_tree().create_timer(2.5).timeout
	get_tree().paused = false
	# Check if player reached a high score
	for idx in GameState.HighScores.size() - 1:
		#  New high score reached
		if GameState.PlayerScore > GameState.HighScores[idx]:
			GameState.HighScores.insert(idx, GameState.PlayerScore)
			GameState.HighScores = GameState.HighScores.slice(0, 9)
			GameState.sort_custom(func(a, b): return a > b)
			# Save gamestate to disk then switch to high scores
			GameState.SaveGameData()
			SceneManager.SwitchScene("HighScores")
	# No high score reached, switch to main menu
	SceneManager.SwitchScene("MainMenu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NewGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Player lost, end game
	if GameState.PlayerLives < 0:
		if GameState.PlayerContinues > 0:
			pass # Ask for continue
		else:
			GameOver()

	# Pause game
	if Input.is_action_pressed("pause_game"):
		get_tree().paused = true
		PauseMenu.show()
