extends Node

@onready var BackButton = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene("MainMenu")
