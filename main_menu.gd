extends Node

var MENU_OPTIONS = [ "New Game", "High Scores", "Options", "Quit" ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the main menu button is activated
func _on_main_button_pressed() -> void:
	var menu_index = 3
	match menu_index:
		0:
			pass
		1:
			pass
		2:
			pass
		_:
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()

# Mouse entered left button - show
func _on_option_left_button_mouse_entered() -> void:
	pass # Replace with function body.

# Mouse entered right button - show
func _on_option_right_button_mouse_entered() -> void:
	pass # Replace with function body.

# Mouse exited left button - hide
func _on_option_left_button_mouse_exited() -> void:
	pass # Replace with function body.

# Mouse exited right button - hide
func _on_option_right_button_mouse_exited() -> void:
	pass # Replace with function body.
