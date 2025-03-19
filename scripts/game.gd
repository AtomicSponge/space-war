extends Node

# Called when a new game starts
func NewGame() -> void:
	pass

# Called at the end of a game
func GameOver() -> void:
	GameState.SaveGameData()
	SceneManager.SwitchScene("MainMenu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("pause_game"):
		get_tree().paused = true
		$PauseMenu.show()
