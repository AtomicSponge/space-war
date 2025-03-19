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
	$PauseMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("pause_game"):
		$PauseMenu.show()
	pass

# Pause menu - resume button pressed
func _on_resume_button_pressed() -> void:
	pass # Replace with function body.

# Pause menu - quit button pressed
func _on_quit_button_pressed() -> void:
	GameOver()
