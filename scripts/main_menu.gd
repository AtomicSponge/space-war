extends Node

@onready var MainBtn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/MainButton

const MenuOptions = [ "New Game", "High Scores", "Options", "Quit" ]
var CurrentOption: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainBtn.text = MenuOptions[CurrentOption]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the main menu button is activated
func _on_main_button_pressed() -> void:
	match CurrentOption:
		# New Game
		0:
			SceneManager.SwitchScene("Game")
		# High Scores
		1:
			SceneManager.SwitchScene("HighScores")
		# Options
		2:
			SceneManager.SwitchScene("Options")
		# Quit
		_:
			SceneManager.QuitGame()

# Left option button pressed
func _on_option_left_button_pressed() -> void:
	if CurrentOption > 0:
		CurrentOption = CurrentOption - 1
		MainBtn.text = MenuOptions[CurrentOption]

# Right option button pressed
func _on_option_right_button_pressed() -> void:
	if CurrentOption < MenuOptions.size() - 1:
		CurrentOption = CurrentOption + 1
		MainBtn.text = MenuOptions[CurrentOption]
