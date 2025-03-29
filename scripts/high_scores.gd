extends Node

@onready var ScoresLabel: Label = $MarginContainer/VBoxContainer/CenterContainerBottom/ScoresLabel
@onready var BackButton: Button = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scores = ""
	for score in GameState.HighScores:
		scores += "%016d\n\n" % score
	ScoresLabel.text = scores
	BackButton.grab_focus()

# Back btn to return to Main Menu
func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene("MainMenu")
