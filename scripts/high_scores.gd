extends Node

@onready var ScoresLabel = $MarginContainer/VBoxContainer/CenterContainerBottom/ScoresLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scores = ""
	for score in GameState.HighScores:
		scores += "%016d\n\n" % score
	ScoresLabel.text = scores

# Back btn to return to Main Menu
func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene("MainMenu")
