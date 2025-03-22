extends Node

@onready var MainBtn: TextureButton = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/MainButton

# Array of textures for the main button
# This is manualy created
var MenuOptions: Array[Resource] = [ 
	preload("res://gfx/new_game_btn.png"),
	preload("res://gfx/high_scores_btn.png"),
	preload("res://gfx/options_btn.png"),
	preload("res://gfx/quit_btn.png")
]
# Current menu option selected by player
var CurrentOption: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScrollTimer.stop()
	MainBtn.texture_normal = MenuOptions[CurrentOption]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("menu_left") and $ScrollTimer.is_stopped():
		_menu_left()
		$ScrollTimer.start()
	if Input.is_action_pressed("menu_right") and $ScrollTimer.is_stopped():
		_menu_right()
		$ScrollTimer.start()
	if Input.is_action_pressed("menu_select"):
		_menu_select()

# Called when the main menu button is activated
func _on_main_button_pressed() -> void:
	_menu_select()

# Left option button pressed
func _on_option_left_button_pressed() -> void:
	_menu_left()

# Right option button pressed
func _on_option_right_button_pressed() -> void:
	_menu_right()
	
# Move menu index left
func _menu_left() -> void:
	if CurrentOption > 0:
		CurrentOption = CurrentOption - 1
	else:
		CurrentOption = MenuOptions.size() - 1
	MainBtn.texture_normal = MenuOptions[CurrentOption]

# Move menu index right
func _menu_right() -> void:
	if CurrentOption < MenuOptions.size() - 1:
		CurrentOption = CurrentOption + 1
	else:
		CurrentOption = 0
	MainBtn.texture_normal = MenuOptions[CurrentOption]

# Select a menu option
func _menu_select() -> void:
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
