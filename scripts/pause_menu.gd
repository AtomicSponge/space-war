extends CanvasLayer

# Resume button pressed
func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

# Quit button pressed
func _on_quit_button_pressed() -> void:
	hide()
	get_tree().paused = false
	get_parent().GameOver()
