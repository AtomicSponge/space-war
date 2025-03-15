extends Node

@onready var main_btn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/MainButton
@onready var option_left_btn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/OptionLeftButton
@onready var option_right_btn = $MarginContainer/VBoxContainer/CenterContainerBottom/HBoxContainer/OptionRightButton

const MENU_OPTIONS = [ "New Game", "High Scores", "Options", "Quit" ]
var current_option = 0

# Called when the node enters the scene tree for the first time.
# Hide the left/right option btns until a mouse enters them.
func _ready() -> void:
	option_left_btn.modulate.a = 0
	option_right_btn.modulate.a = 0
	main_btn.text = MENU_OPTIONS[current_option]
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the main menu button is activated
func _on_main_button_pressed() -> void:
	match current_option:
		0:
			# New Game
			pass
		1:
			# High Scores
			pass
		2:
			# Options
			pass
		_:
			# Quit
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()

# Mouse entered left button - show
func _on_option_left_button_mouse_entered() -> void:
	option_left_btn.modulate.a = 255

# Mouse entered right button - show
func _on_option_right_button_mouse_entered() -> void:
	option_right_btn.modulate.a = 255

# Mouse exited left button - hide
func _on_option_left_button_mouse_exited() -> void:
	option_left_btn.modulate.a = 0

# Mouse exited right button - hide
func _on_option_right_button_mouse_exited() -> void:
	option_right_btn.modulate.a = 0

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

# Blink option select buttons
func _on_main_button_mouse_entered() -> void:
	pass # Replace with function body.
