extends Node

@onready var Player = $Player
@onready var MessageLabel = $Overlay/MessageLabel
@onready var PauseMenu = $PauseMenu
@onready var StartPosition = $StartPosition
@onready var Continue = $Continue

# Flag to check if the game is in session
var GameStarted: bool = false

# Called when a new game starts
func NewGame() -> void:
	get_tree().paused = true
	Player.set_position(StartPosition.position)
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
	GameStarted = true

# Called at the end of a game
func GameOver() -> void:
	GameStarted = false
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
	Player.set_position(StartPosition.position)
	Player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Game not running, start it.
	if GameStarted == false:
		NewGame()

	# Player lost, end game
	if GameState.PlayerLives < 0:
		# Player has continues, ask to resume
		if GameState.PlayerContinues > 0:
			get_tree().paused = true
			Continue.ContinueSelected = false
			Continue.show()
			Continue.ContinueTimer.start()
			await Continue.ContinueTimer.timeout
			get_tree().paused = false
			# Continue selected, resume game
			if Continue.ContinueSelected:
				Player.show()
				GameState.PlayerLives = GameState.NumberLives
				GameState.PlayerContinues = GameState.PlayerContinues - 1
				GameState.PlayerScore = GameState.PlayerScore - (GameState.DEATH_PENALTY * 10)
				if GameState.PlayerScore < 0:
					GameState.PlayerScore = 0
			# Continue not selected, end game
			else:
				GameOver()
		# No continues, just end the game
		else:
			GameOver()

	# Pause game - check GameStarted flag to prevent pop-up during game start/end events
	if Input.is_action_pressed("pause_game") and GameStarted:
		get_tree().paused = true
		PauseMenu.show()
		PauseMenu.ResumeButton.grab_focus()

# Called when selecting quit game from the pause menu
func _on_pause_menu_quit_game() -> void:
	GameOver()
