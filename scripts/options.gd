extends Node

@onready var AudioScrollBar: HSlider = $AudioScrollBar
@onready var MusicScrollBar: HSlider = $MusicScrollBar
@onready var EffectsScrollBar: HSlider = $EffectsScrollBar
@onready var LivesScrollBar: HScrollBar = $LivesScrollBar
@onready var ContinueScrollBar: HScrollBar = $ContinueScrollBar
@onready var NumLivesLabel: Label = $NumLivesLabel
@onready var NumContinuesLabel: Label = $NumContinuesLabel
@onready var DisplayList: ItemList = $DisplayList
@onready var BackButton: Button = $BackButton
@onready var EffectsAudio: AudioStreamPlayer = $EffectsAudio

@onready var MasterBus: int = AudioServer.get_bus_index("Master")
@onready var MusicBus: int = AudioServer.get_bus_index("Music")
@onready var EffectsBus: int = AudioServer.get_bus_index("Effects")

var CurrentDisplayMode: int = 0
var CurrentLives: int = 0
var CurrentContinues: int = 0

signal save_complete

# Save options to disk
func do_options_save() -> void:
	GameState.MainVolume = db_to_linear(AudioServer.get_bus_volume_db(MasterBus))
	GameState.MusicVolume = db_to_linear(AudioServer.get_bus_volume_db(MusicBus))
	GameState.EffectsVolume = db_to_linear(AudioServer.get_bus_volume_db(EffectsBus))
	GameState.NumberLives = int(LivesScrollBar.value)
	GameState.NumberContinues = int(ContinueScrollBar.value)
	CurrentLives = GameState.NumberLives
	CurrentContinues = GameState.NumberContinues
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
		dialog.connect('confirmed', func():
			dialog.queue_free()
			save_complete.emit()
		) # Free node on OK
		add_child(dialog)
		dialog.popup_centered()
		dialog.show()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioScrollBar.value = db_to_linear(AudioServer.get_bus_volume_db(MasterBus))
	MusicScrollBar.value = db_to_linear(AudioServer.get_bus_volume_db(MusicBus))
	EffectsScrollBar.value = db_to_linear(AudioServer.get_bus_volume_db(EffectsBus))
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
		GameState.NumberLives = GameState.DEFAULT_LIVES
		LivesScrollBar.value = GameState.DEFAULT_LIVES
		GameState.NumberContinues = GameState.DEFAULT_CONTINUES
		ContinueScrollBar.value = GameState.DEFAULT_CONTINUES
		do_options_save()
		dialog.queue_free()
	)
	dialog.canceled.connect (dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()

# Save button pressed, apply and save to disk
func _on_save_button_pressed() -> void:
	do_options_save()

# Back button pressed, return to main menu
func _on_back_button_pressed() -> void:
	var changedDialog = func():
		var dialog = ConfirmationDialog.new()
		dialog.title = "SETTINGS CHANGED"
		dialog.dialog_text = "SETTINGS CHANGED DO YOU WANT TO SAVE?"
		dialog.confirmed.connect (func():
			do_options_save()
			dialog.queue_free()
		)
		dialog.canceled.connect (func():
			save_complete.emit()
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
	else:
		SceneManager.SwitchScene("MainMenu")
	await save_complete
	SceneManager.SwitchScene("MainMenu")

# Called when the AudioScrollBar value changes
func _on_audio_scroll_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(value))

# Called when the MusicScrollBar value changes
func _on_music_scroll_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(value))

# Called when the EffectsScrollBar value changes
func _on_effects_scroll_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(EffectsBus, linear_to_db(value))
