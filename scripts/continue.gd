extends CanvasLayer

@onready var CounterLabel = $MarginContainer/VBoxContainer/CenterContainerBottom/CounterLabel
@onready var ContinueTimer = $ContinueTimer

var ContinueSelected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	ContinueTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not ContinueTimer.is_stopped():
		CounterLabel.text = "%d" % snappedi(ContinueTimer.time_left, 1)

# Check if a button or key is pressed
func _unhandled_input(event: InputEvent) -> void:
	if not ContinueTimer.is_stopped():
		if event is InputEventKey or InputEventJoypadButton or InputEventMouseButton:
			ContinueSelected = true
			ContinueTimer.stop()
