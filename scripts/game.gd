extends Node

enum EnemyTypes {
	Type0, Type1, Type2, Type3, Type4
}

@export var EnemyType0: PackedScene
@export var EnemyType1: PackedScene
@export var EnemyType2: PackedScene
@export var EnemyType3: PackedScene

@onready var Player = $Player
@onready var MessageLabel = $Overlay/MessageLabel
@onready var PauseMenu = $PauseMenu
@onready var StartPosition = $StartPosition
@onready var Continue = $Continue
@onready var SpawnTimer = $SpawnTimer

# Flag to check if the game is in session
var GameStarted: bool = false

# Used to regulate spawning to 1/10 sec ticks
var LastTick: float = 0.0

# Called when a new game starts
func NewGame() -> void:
	SceneManager.BGMuisc[SceneManager.Audio.Menu].stop()
	SceneManager.BGMuisc[SceneManager.Audio.Game].play()
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
	SpawnTimer.start()
	GameStarted = true

# Called at the end of a game
func GameOver() -> void:
	SceneManager.BGMuisc[SceneManager.Audio.Game].stop()
	GameStarted = false
	get_tree().paused = true
	Player.hide()
	MessageLabel.text = "GAME OVER"
	MessageLabel.show()
	await get_tree().create_timer(2.5).timeout
	get_tree().paused = false
	# Check if player reached a high score
	var do_high_score = false
	for idx in GameState.HighScores.size() - 1:
		#  New high score reached
		if GameState.PlayerScore > GameState.HighScores[idx]:
			GameState.HighScores.insert(idx, GameState.PlayerScore)
			GameState.HighScores = GameState.HighScores.slice(0, 10)
			GameState.HighScores.sort_custom(func(a, b): return a > b)
			# Save gamestate to disk then switch to high scores
			GameState.SaveGameData()
			do_high_score = true
			break
	GameState.PlayerScore = 0
	SceneManager.BGMuisc[SceneManager.Audio.Menu].play()
	if do_high_score:
		SceneManager.SwitchScene("HighScores")
	else:
		SceneManager.SwitchScene("MainMenu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.game_over.connect(GameOver)
	Events.game_continue_selected.connect(_continue_selected)
	Player.set_position(StartPosition.position)
	Player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not GameStarted:
		NewGame()

	# Sample player location
	GameState.PlayerLocation = Player.position

	# Pause game - check GameStarted flag to prevent pop-up during game start/end events
	if Input.is_action_pressed("pause_game") and GameStarted:
		get_tree().paused = true
		PauseMenu.show()
		PauseMenu.ResumeButton.grab_focus()
	
	# Spawn enemies
	if LastTick != snapped(SpawnTimer.time_left, 0.1):
		var enemies = Spawner.GetEnemies(snapped(SpawnTimer.time_left, 0.1))
		for enemy in enemies:
			match enemy["type"]:
				EnemyTypes.Type0:
					var e = EnemyType0.instantiate()
					add_child(e)
					e.position = enemy["location"]
				EnemyTypes.Type1:
					var e = EnemyType1.instantiate()
					add_child(e)
					e.position = enemy["location"]
				EnemyTypes.Type2:
					var e = EnemyType2.instantiate()
					add_child(e)
					e.position = enemy["location"]
					e.rotation = deg_to_rad(enemy["rotation"])
				EnemyTypes.Type3:
					var e = EnemyType3.instantiate()
					add_child(e)
					e.position = enemy["location"]
					e.rotation = deg_to_rad(enemy["rotation"])
				EnemyTypes.Type4:
					pass
				_:
					pass
	LastTick = snapped(SpawnTimer.time_left, 0.1)

# Called when a contine is selected
func _continue_selected() -> void:
	GameState.PlayerLives = GameState.NumberLives
	GameState.PlayerContinues -= 1
	GameState.PlayerScore -= (GameState.DEATH_PENALTY * 10)
	if GameState.PlayerScore < 0:
		GameState.PlayerScore = 0
	Player.PlayerRespawn()

# Called when selecting quit game from the pause menu
func _on_pause_menu_quit_game() -> void:
	GameOver()
