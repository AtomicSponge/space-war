extends Node

@onready var LivesScrollBar = $LivesScrollBar
@onready var ContinueScrollBar = $ContinueScrollBar
@onready var NumLivesLabel = $NumLivesLabel
@onready var NumContinuesLabel = $NumContinuesLabel
@onready var BackButton = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LivesScrollBar.max_value = GameState.MAX_LIVES
	LivesScrollBar.min_value = GameState.MIN_LIVES
	LivesScrollBar.value = GameState.NumberLives
	ContinueScrollBar.max_value = GameState.MAX_CONTINUES
	ContinueScrollBar.min_value = GameState.MIN_CONTINUES
	ContinueScrollBar.value = GameState.NumberContinues
	BackButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	NumLivesLabel.text = "%d" % LivesScrollBar.value
	NumContinuesLabel.text = "%d" % ContinueScrollBar.value

func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene("MainMenu")
