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
	NumLivesLabel.text = "%d" % LivesScrollBar.value
	NumContinuesLabel.text = "%d" % ContinueScrollBar.value
	BackButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	NumLivesLabel.text = "%d" % LivesScrollBar.value
	NumContinuesLabel.text = "%d" % ContinueScrollBar.value

# Reset button pressed, reset settings and save to disk
func _on_reset_button_pressed() -> void:
	var dialog = ConfirmationDialog.new()
	dialog.title = "CONFIRM RESET"
	dialog.dialog_text = "CONFIRM RESET SETTINGS"
	dialog.confirmed.connect (_reset_dialog_confirmed)
	dialog.canceled.connect (dialog.queue_free)
	dialog.add_theme_color_override("default_color", Color(1, 1, 0, 1))
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()

# Save button pressed, apply and save to disk
func _on_save_button_pressed() -> void:
	GameState.NumberLives = LivesScrollBar.value
	GameState.NumberContinues = ContinueScrollBar.value

	var dialog = AcceptDialog.new()
	dialog.title = "SAVED"
	dialog.dialog_text = "SETTINGS SAVED"
	dialog.dialog_hide_on_ok = false # Disable default behaviour
	dialog.connect('confirmed', dialog.queue_free) # Free node on OK
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()

	GameState.SaveGameData()

# Back button pressed, return to main menu
func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene("MainMenu")

# Reset dialog confirmed - reset values and save to disk
func _reset_dialog_confirmed() -> void:
	GameState.NumberLives = GameState.DEFAULT_LIVES
	LivesScrollBar.value = GameState.DEFAULT_LIVES
	GameState.NumberContinues = GameState.DEFAULT_CONTINUES
	ContinueScrollBar.value = GameState.DEFAULT_CONTINUES
	GameState.SaveGameData()
