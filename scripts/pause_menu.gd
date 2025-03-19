extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Resume button pressed
func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

# Quit button pressed
func _on_quit_button_pressed() -> void:
	hide()
	get_tree().paused = false
	get_parent().GameOver()
