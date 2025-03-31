extends Node

@onready var MainBtn: Button = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/Container/MainButton
@onready var ScrollTimer: Timer = $ScrollTimer
@onready var CreditsTimer: Timer = $CreditsTimer

# Array of strings for the main button
const MenuOptions: Array[String] = [ 
	"NEW GAME", "HIGH SCORES", "OPTIONS", "QUIT"
]
# Current menu option selected by player
var CurrentOption: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScrollTimer.stop()
	CreditsTimer.start()
	MainBtn.text = MenuOptions[CurrentOption]

# Move menu index left
func _menu_left() -> void:
	if CurrentOption > 0:
		CurrentOption = CurrentOption - 1
	else:
		CurrentOption = MenuOptions.size() - 1
	MainBtn.text = MenuOptions[CurrentOption]

# Move menu index right
func _menu_right() -> void:
	if CurrentOption < MenuOptions.size() - 1:
		CurrentOption = CurrentOption + 1
	else:
		CurrentOption = 0
	MainBtn.text = MenuOptions[CurrentOption]

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left") and $ScrollTimer.is_stopped():
		_menu_left()
		ScrollTimer.start()
	if Input.is_action_pressed("ui_right") and $ScrollTimer.is_stopped():
		_menu_right()
		ScrollTimer.start()
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_select"):
		_menu_select()
		
	# Credits timer ended, show credits scene
	if CreditsTimer.is_stopped():
		SceneManager.SwitchScene("Credits")

# Called when the main menu button is activated
func _on_main_button_pressed() -> void:
	_menu_select()

# Left option button pressed
func _on_option_left_button_pressed() -> void:
	_menu_left()

# Right option button pressed
func _on_option_right_button_pressed() -> void:
	_menu_right()
