extends Node

# Check if a button or key is pressed and return to main menu
func _input(event: InputEvent) -> void:
	if event is InputEventKey or InputEventJoypadButton or InputEventMouseButton:
		if event is InputEventMouseMotion:
			return
		else:
			SceneManager.SwitchScene("MainMenu")
