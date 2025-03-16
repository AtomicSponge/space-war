extends Node

@onready var main_btn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/MainButton
@onready var option_left_btn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/OptionLeftButton
@onready var option_right_btn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/OptionRightButton

const MENU_OPTIONS = [ "New Game", "High Scores", "Options", "Quit" ]
var current_option = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_btn.text = MENU_OPTIONS[current_option]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the main menu button is activated
func _on_main_button_pressed() -> void:
	match current_option:
		0:
			# New Game
			# add_child(Game.new())
			pass
		1:
			# High Scores
			pass
		2:
			# Options
			pass
		_:
			# Quit
			SceneManager.QuitGame()

# Left option button pressed
func _on_option_left_button_pressed() -> void:
	if current_option > 0:
		current_option = current_option - 1
		main_btn.text = MENU_OPTIONS[current_option]

# Right option button pressed
func _on_option_right_button_pressed() -> void:
	if current_option < MENU_OPTIONS.size() - 1:
		current_option = current_option + 1
		main_btn.text = MENU_OPTIONS[current_option]
