extends CanvasLayer

signal continue_selected

@onready var CounterLabel = $MarginContainer/VBoxContainer/CenterContainerBottom/CounterLabel
@onready var ContinueTimer = $ContinueTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	ContinueTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not ContinueTimer.is_stopped():
		CounterLabel.text = "%d" % snappedi(ContinueTimer.time_left, 1)

func _unhandled_input(event: InputEvent) -> void:
	if not ContinueTimer.is_stopped():
		if event is InputEventKey or InputEventJoypadButton or InputEventMouseButton:
			continue_selected.emit()
