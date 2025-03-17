extends Node

@onready var MainBtn: TextureButton = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/MainButton

# Array of textures for the main button
# This is manualy created
var MenuOptions: Array = [ 
	preload("res://gfx/new_game_btn.png"),
	preload("res://gfx/high_scores_btn.png"),
	preload("res://gfx/options_btn.png"),
	preload("res://gfx/quit_btn.png")
]
# Current menu option selected by player
var CurrentOption: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainBtn.texture_normal = MenuOptions[CurrentOption]
	pass

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
		MainBtn.texture_normal = MenuOptions[CurrentOption]

# Right option button pressed
func _on_option_right_button_pressed() -> void:
	if CurrentOption < MenuOptions.size() - 1:
		CurrentOption = CurrentOption + 1
		MainBtn.texture_normal = MenuOptions[CurrentOption]
