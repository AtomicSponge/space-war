extends Node

@onready var LivesScrollBar = $LivesScrollBar
@onready var ContinueScrollBar = $ContinueScrollBar
@onready var NumLivesLabel = $NumLivesLabel
@onready var NumContinuesLabel = $NumContinuesLabel
@onready var DisplayList = $DisplayList
@onready var BackButton = $BackButton

var CurrentDisplayMode: int = 0
var CurrentLives: int = 0
var CurrentContinues: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LivesScrollBar.max_value = GameState.MAX_LIVES
	LivesScrollBar.min_value = GameState.MIN_LIVES
	LivesScrollBar.value = GameState.NumberLives
	CurrentLives = GameState.NumberLives
	ContinueScrollBar.max_value = GameState.MAX_CONTINUES
	ContinueScrollBar.min_value = GameState.MIN_CONTINUES
	ContinueScrollBar.value = GameState.NumberContinues
	CurrentContinues = GameState.NumberContinues
	NumLivesLabel.text = "%d" % LivesScrollBar.value
	NumContinuesLabel.text = "%d" % ContinueScrollBar.value
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		CurrentDisplayMode = 0
		DisplayList.select(0)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		CurrentDisplayMode = 1
		DisplayList.select(1)
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
	dialog.confirmed.connect (func():
		dialog.queue_free()
		GameState.NumberLives = GameState.DEFAULT_LIVES
		LivesScrollBar.value = GameState.DEFAULT_LIVES
		GameState.NumberContinues = GameState.DEFAULT_CONTINUES
		ContinueScrollBar.value = GameState.DEFAULT_CONTINUES
		GameState.SaveGameData()
	)
	dialog.canceled.connect (dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()

# Save button pressed, apply and save to disk
func _on_save_button_pressed() -> void:
	GameState.NumberLives = LivesScrollBar.value
	GameState.NumberContinues = ContinueScrollBar.value
	if DisplayList.is_selected(0) and CurrentDisplayMode == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		CurrentDisplayMode = 0
	elif DisplayList.is_selected(1) and CurrentDisplayMode == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		CurrentDisplayMode = 1
	if GameState.SaveGameData() != -1:
		var dialog = AcceptDialog.new()
		dialog.title = "SAVED"
		dialog.dialog_text = "SETTINGS SAVED"
		dialog.dialog_hide_on_ok = false # Disable default behaviour
		dialog.connect('confirmed', dialog.queue_free) # Free node on OK
		add_child(dialog)
		dialog.popup_centered()
		dialog.show()

# Back button pressed, return to main menu
func _on_back_button_pressed() -> void:
	var changedDialog = func():
		var dialog = ConfirmationDialog.new()
		dialog.title = "SETTINGS CHANGED"
		dialog.dialog_text = "SETTINGS CHANGED DO YOU WANT TO SAVE?"
		dialog.confirmed.connect (func():
			dialog.queue_free()
			GameState.SaveGameData()
		)
		dialog.canceled.connect (func():
			dialog.queue_free()
		)
		add_child(dialog)
		dialog.popup_centered()
		dialog.show()
	if LivesScrollBar.value != CurrentLives or ContinueScrollBar.value != CurrentContinues:
		changedDialog.call()
	elif DisplayList.is_selected(0) and CurrentDisplayMode == 1:
		changedDialog.call()
	elif DisplayList.is_selected(1) and CurrentDisplayMode == 0:
		changedDialog.call()
	SceneManager.SwitchScene("MainMenu")
