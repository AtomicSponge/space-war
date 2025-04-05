extends CanvasLayer

@onready var CounterLabel = $MarginContainer/VBoxContainer/CenterContainerBottom/CounterLabel
@onready var ContinueTimer = $ContinueTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ContinueTimer.stop()
	Events.game_continue.connect(_do_continue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not ContinueTimer.is_stopped():
		CounterLabel.text = "%d" % snappedi(ContinueTimer.time_left - 1, 1)
		if ContinueTimer.time_left < 1.0:
			ContinueTimer.stop()
			hide()
			get_tree().paused = false
			Events.game_over.emit()

# Check if a button or key is pressed
func _unhandled_input(event: InputEvent) -> void:
	if not ContinueTimer.is_stopped():
		if event is InputEventKey or InputEventJoypadButton or InputEventMouseButton:
			if event is InputEventMouseMotion:
				return
			else:
				ContinueTimer.stop()
				get_tree().paused = false
				GameState.PlayerContinues -= 1
				GameState.PlayerLives = GameState.NumberLives
				GameState.PlayerScore -= (GameState.DEATH_PENALTY * 10)
				if GameState.PlayerScore < 0:
					GameState.PlayerScore = 0
				Events.game_continue_selected.emit()
				hide()

# Show the continue screen
func _do_continue() -> void:
	get_tree().paused = true
	show()
	ContinueTimer.start()
